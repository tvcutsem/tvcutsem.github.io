---
title: Proxies and Frozen Objects
layout: post
tags: javascript proxies freezing invariants
permalink: frozen-proxies
excerpt_separator: <!--more-->
comments: true
---
This post is about how frozen Javascript objects interact with the upcoming [Proxy API](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies).

<!--more-->

Since [ECMAScript 5th edition](http://es5.github.com/), Javascript objects can be _frozen_. John Resig has a good [blog post](http://ejohn.org/blog/ecmascript-5-objects-and-properties/) on the matter. To quote from his post:

> _Freezing an object is the ultimate form of lock-down. Once an object has been frozen it cannot be unfrozen - nor can it be tampered in any manner. This is the best way to make sure that your objects will stay exactly as you left them, indefinitely._

Once you call <tt>Object.freeze(obj)</tt> on an object <tt>obj</tt>, you have basically established two _invariants_ on that object, i.e. properties of the object that will hold forever after:

*   The object becomes **non-extensible**: once frozen, you (or anyone else) can't add any more properties to the object, ever.
*   All properties of the object become **non-configurable**: they can no longer be deleted, updated or have their attributes (like enumerability) changed in any way, ever.

I should note at this point that ECMAScript 5 has additional primitives to apply these invariants to just a subset of an object's properties (<tt>Object.defineProperty</tt>), and also introduces the weaker notions of "non-extensible" and "sealed" objects (<tt>Object.preventExtensions, Object.seal</tt>). See [John's post](http://ejohn.org/blog/ecmascript-5-objects-and-properties/) for more details. Freezing an object is simply the most extreme type of lock-down you can apply to an object, and consequently involves the strongest invariants, so we'll only focus on frozen objects here.

If you can establish that an object is frozen, i.e. <tt>Object.isFrozen(obj) === true</tt>, then you can count on the above invariants. For instance, if <tt>obj.x</tt> isn't a getter (an "accessor property"), then you can count on the fact that <tt>obj.x</tt> is effectively a "constant" property: you can read its current value and cache it, knowing the cached value will always be correct.

With the introduction of proxies, an obvious question is whether and how proxies affect these invariants. Can proxies masquerade as frozen objects? And if yes, can they violate the associated invariants? The short answers are yes, and no.

## Proxies: brief recap

I [wrote earlier]({% post_url 2012-02-07-designing-the-ecmascript-reflection-api %}) about how the Proxy API has undergone several revisions. Here, I'll briefly introduce the latest revision of the API, called "direct proxies". The Proxy API allows you to create a proxy for an object (which we will consistently refer to as the proxy's "target"), as follows:

{% highlight javascript linenos %}
var target = {x:0,y:0}; // some existing object
var handler = {}; // the handler's methods are called "traps"
var proxy = Proxy(target, handler);
{% endhighlight %}

Here, <tt>proxy</tt> is a special proxy object that can intercept a number of Javascript operations. For instance, the <tt>in</tt> operator, when applied to a proxy: <tt>"x" in proxy</tt>, will trigger a corresponding "trap" in the proxy handler, and calls <tt>handler.has(target, "x")</tt>, which is supposed to return a boolean indicating whether the proxy has a property named "x". If the trap is undefined, as in the above example, the proxy by default delegates the operation to the target, i.e. <tt>"x" in proxy</tt> is then interpreted as <tt>"x" in target</tt>.

Below is a schematic representation that shows the relationship between a proxy, a target and its handler. Proxies can intercept many operations, such as property access and assignment, property lookup, enumeration, and so on. On the left, we show a couple of operations applied to the proxy, and how the proxy interprets them by dispatching to the handler.

<center>
  <img src="/assets/proxy_api.jpg" alt="Proxy API" width="100%">
</center>

In short, the proxy can fully customize the way it advertises its own properties to clients. In general, a proxy is not even obliged to return results that are consistent with its own target:

{% highlight javascript linenos %}
handler.has = function(target, name) { return false; }
"x" in target // returns true
"x" in proxy // returns false
proxy.x // returns 0
{% endhighlight %}

In the extreme, one can even create a proxy that totally ignores its target object for all operations. This is sometimes useful, e.g. the target could just be a dummy placeholder, and the proxy might represent a remote object (on the server or in a different web worker) or an object stored in a remote database.

## Frozen Proxies

Back to frozen objects and proxies. Is it possible to create a frozen proxy? Yes: just create a proxy whose target is frozen:

{% highlight javascript linenos %}
var target = Object.freeze({ x: 0 });
var handler = {};
var proxy = Proxy(target, handler);
Object.isFrozen(proxy) // true!
{% endhighlight %}

However, now we're in a potentially dangerous situation: depending on how the handler implements this proxy's traps, it may return results that are inconsistent with its target, and may thus potentially violate the invariants of frozen objects. To prevent this, the Proxy API includes an [invariant enforcement mechanism](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies#invariant_enforcement), which is simply a series of assertions on the behavior of a proxy handler. If one of the proxy handler's traps returns a result that is inconsistent with the fact that its target is frozen, an assertion will fail and cause an exception to be thrown, thus notifying clients of the proxy's misbehavior.

Continuing with the previous example, assume a client of the proxy observes the "x" property:

{% highlight javascript %}
proxy.x // 0
{% endhighlight %}

The handler does not define a "get" trap, so the proxy simply forwards the property access to the (frozen) target, and returns 0\. Now, assume that the handler is updated as follows:

{% highlight javascript %}
handler.get = function(target, name) {
  return 1;
}
{% endhighlight %}

Let's see what happens when we try to access properties on the proxy:

{% highlight javascript %}
proxy.foo // returns 1, so far so good...
proxy.x // TypeError: cannot report inconsistent value for non-writable, non-configurable property 'x' 
{% endhighlight %}

When you encounter such an exception, what Javascript is really telling you is:

> Son, this proxy is writing cheques its target can't cash!

Seriously: <tt>proxy.x</tt> fails because the proxy knows that <tt>target</tt> is frozen, and has a property named "x" which is bound to the value 0\. It cannot now let the proxy claim that <tt>proxy.x</tt> is 1, while it returned 0 just a while ago. After all, the proxy is supposedly frozen, and frozen objects wouldn't exhibit such behavior. In this example, the "get" trap always returns 1, which on the surface seems OK for frozen objects, but in general the "get" trap may return a different value each time it's called. The proxy instead detects such inconsistencies, and throws.

Since frozen objects are supposedly non-extensible, why is the proxy allowed to report a value for a "foo" property, while the frozen target doesn't have such a property? The answer has to do with prototypal inheritance: a frozen object can still inherit from a non-frozen object, which may define a "foo":

{% highlight javascript linenos %}
var parent = {} ; // note: parent isn't frozen
var child = Object.create(parent); // child inherits from parent
Object.freeze(child);
child.foo // undefined
parent.foo = 1;
child.foo // 1
{% endhighlight %}

In the above example, the expression <tt>child.foo</tt> returned different values even though <tt>child</tt> is frozen. This is why the above proxy was allowed to return a value for "foo", even though that property wasn't defined on the target. The proxy won't verify whether the target actually inherits from a non-frozen object that has a "foo", but just assumes that this is possible.

Matters are different if the proxy actually tries to advertise "foo" as an "own" property (i.e. a property defined on the proxy itself, not inherited from some other object):

{% highlight javascript linenos %}
Object.keys(proxy);  // [ "x" ]
handler.keys = function(target) { return [ "x", "foo" ]; };
Object.keys(target); // [ "x" ]
Object.keys(proxy)  // TypeError: keys trap cannot list a new property 'foo' on a non-extensible object
{% endhighlight %}

What's going on here? <tt>Object.keys</tt>, new since ES5, lists all of an object's own, enumerable properties. When applied to the proxy, it invokes the handler's "keys" trap, which should return an array of strings. On line 1, the proxy handler doesn't yet define a "keys" trap, so just forwards the call to <tt>Object.keys</tt> to the target, returning the array <tt>["x"]</tt>. On line 2, the handler installs a "keys" trap that claims both "x" and "foo" as own properties of the (frozen) proxy. On line 4, the program throws an exception. It would be wrong for <tt>Object.keys(proxy)</tt> on line 4 to return "foo" in the list of own properties since doing so would violate the invariants of frozen objects. After all, on line 1, the "foo" property was not present, and <tt>proxy</tt> was supposedly frozen, so clients would be very surprised if later, they noticed <tt>proxy</tt> had a new property!

## Try it yourself

At the time of writing, direct proxies are being prototyped in Firefox. I wrote a little [shim](https://github.com/tvcutsem/harmony-reflect) that already implements the most recent API in terms of an older revision that is already available since Firefox 4\. Just include [this script](https://raw.github.com/tvcutsem/harmony-reflect/master/reflect.js) in your page and you're ready to play around with direct proxies (tested in Firefox 12). This is work-in-progress, so any feedback is more than welcome.