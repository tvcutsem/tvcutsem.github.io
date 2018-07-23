---
title: Membranes in JavaScript
layout: post
tags: javascript proxies membranes
permalink: js-membranes
excerpt_separator: <!--more-->
comments: true
---
Membranes are a powerful new feature enabled by Javascript proxies, with various use cases. The goal of a membrane is to fully isolate two object graphs.
Before I can dive into more practical applications of membranes, I need to explain what a membrane is in more detail, so bear with me.

<!--more-->

**Update**: I explain the ideas behind membranes more generally in [this article]({% post_url 2018-07-22-membranes.md %}).

## What is a membrane?

A membrane is a wrapper around an entire object graph, as opposed to a wrapper for just a single object. Typically, the creator of a membrane starts out wrapping just a single object in a membrane. The key idea is that any object reference that crosses the membrane is itself transitively wrapped in the same membrane. Object references typically cross the membrane in one direction (out->in) by passing parameters to an object's method, and in the opposite direction (in->out) by being returned as a value from a method or by being thrown as an exception.

To ease speaking about membranes, I will use the term "wet objects" for objects that live inside of the membrane, and the term "dry objects" to refer to objects that live outside of the membrane. The key thing about membranes is that they convert any outbound reference to a wet object that crosses them into a proxy, which is a dry object representing the corresponding wet object on the other side of the membrane. Similarly, the membrane converts any inbound dry object reference into a proxy which is a wet object that represents the corresponding dry object on the other side of the membrane.

Here's a simple example of how a membrane can be constructed:

{% highlight javascript %}
var wetB = { y: 0 }
var wetA = { x: wetB }
var dryA = makeMembrane(wetA)
{% endhighlight %}

So now, <tt>dryA</tt> is a proxy to the corresponding <tt>wetA</tt> object. Once a dry wrapper like <tt>dryA</tt> is created, it is possible for clients to navigate transparently through the wrapped object graph via the dry wrapper, yet never getting a direct reference to the wet objects:

{% highlight javascript %}
var dryB = dryA.x
{% endhighlight %}

Now, <tt>dryB</tt> is a wrapper for the corresponding <tt>wetB</tt> object. Typically, primitives are passed through the membrane unwrapped:

{% highlight javascript %}
dryB.y === 0
{% endhighlight %}

After executing all this code, we end up with the following object graph:

<center>
  <img src="/assets/Membrane1.png" alt="Membrane 1" width="60%">
</center>

The full circles represent regular Javascript objects, the half-circles represent proxies. Now, if we want to add references in the other direction, we'll need to add a method to one of our wet objects:

{% highlight javascript %}
wetA.m = function(wetC) { var wetD = { z: wetC }; return wetD; }
{% endhighlight %}

If the outside (dry) world now passes in a dry object to <tt>m</tt>, the membrane will receive a wrapped version instead:

{% highlight javascript %}
var dryC = {};
var dryD = dryA.m(dryC);
{% endhighlight %}

And we end up with the following object graph:

<center>
  <img src="/assets/Membrane2.png" alt="Membrane 2" width="60%">
</center>

## Revocable Membranes

This is all fine, but why is it useful? A membrane provides its creator with the power to intervene whenever a reference crosses the membrane (either in->out or out->in). One simple use case is for instance to install a kill-switch on the membrane: while the switch has not yet been triggered, all the wrappers belonging to the same membrane do nothing but transparently and dutifully forwarding all operations to their corresponding targets on the other side of the membrane. However, once the kill-switch is triggered, these wrappers instantaneously stop forwarding, drop the reference to their target, and will complain whenever clients still try to access their target. In effect, the membrane has hermetically sealed off its wrapped object graph from the world outside it: clients that only have membrane-wrapped references will hold on to nothing but useless pointers. After revocation, we are left with the following object graph:

<center>
  <img src="/assets/Membrane3.png" alt="Membrane 3" width="60%">
</center>

Such membranes are called "revocable" membranes, and triggering the kill-switch is also called "revoking" the membrane. Revocable membranes are useful to exercise the principle of least authority in application design: module A may only want to provide module B with access to its objects for a limited amount of time. A can thus wrap its objects in a membrane, pass the wrapped version to B, and when A (the rightful owner of the objects) decides that B no longer has the right to access its objects, it revokes the membrane.

Revocable membranes require a slightly updated API: when we create a new revocable membrane, we don't get back just the wrapped object, but also a <tt>revoke()</tt> function that we can call to trigger the kill-switch:

{% highlight javascript %}
var wetB = { y: 0 }
var wetA = { x: wetB }
var membrane = makeMembrane(wetA)
var dryA = membrane.wrapper
var revoke = membrane.revoke
// by the way, destructuring in ES6 will turn the above 3 lines
// into the following pleasant one-liner:
// let { wrapper: dryA, revoke } = makeMembrane(wetA)
{% endhighlight %}

Again, a client object receiving only <tt>dryA</tt> can make use of the object as if it was the <tt>wetA</tt> object: the membrane will dutifully mimic the corresponding object inside of the membrane:

{% highlight javascript %}
var dryB = dryA.x
dryB.y // returns 0
{% endhighlight %}

But now for the interesting part: the moment the membrane creator calls <tt>revoke</tt>, clients with access to <tt>dryA</tt> or <tt>dryB</tt> only lose all ability to continue using these objects:

{% highlight javascript %}
// membrane creator calls:
revoke();
// in client code:
dryA.x // error: membrane was revoked
dryB.y // error: membrane was revoked
{% endhighlight %}

Of course, if some code has access to _both_ the original <tt>wetA</tt> and the wrapped <tt>dryA</tt>, then that code can still continue using the <tt>wetA</tt> object (but not via the revoked <tt>dryA</tt> reference). Often when using membranes, the code will arrange for the original wrapped objects to be well encapsulated (perhaps hidden within the scope of a closure) so that clients can only ever get wrapped references to it.

## How are membranes implemented?

I will not go into full detail in this post, but let me just mention a couple of points.

Naturally, membranes require [Harmony proxies](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies) in order to implement the transparent wrappers. Until the new direct proxies API lands, I have been [experimenting with membranes](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/simpleMembrane.js) using my [DirectProxies.js](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/DirectProxies.js) shim, which implements the new direct proxies API in terms of the older one.

Perhaps surprisingly, proper membranes also require [WeakMaps](http://wiki.ecmascript.org/doku.php?id=harmony:weak_maps), another Harmony feature (the one-line summary is that WeakMaps are like object-identity-keyed hashtables that hold on to their key weakly, ideal for building caches). Membranes need WeakMaps for two reasons: first, to preserve object identity _across_ the membrane. Consider the following:

{% highlight javascript %}
var dryB = dryA.x
var dryB2 = dryA.x
// dryB === dryB2 ?
{% endhighlight %}

We would like the answer to this question to be yes. In other words: a membrane should cache whatever wrapper it creates for <tt>wetB</tt> and consistently return the same wrapper whenever <tt>wetB</tt> crosses the membrane (in this case, by being accessed via <tt>wetA</tt>'s <tt>x</tt> property).

The second reason is more subtle and has to do with preserving object identity _on either side of_ the membrane. Consider the following:

{% highlight javascript %}
wetA.test = function(x) { return x === wetB; }
dryA.test(dryB) // returns true or false?
{% endhighlight %}

Here, again, we would expect <tt>true</tt> to be returned. For this to happen, however, when <tt>dryB</tt> (which is an in->out wrapper for <tt>wetB</tt>) crosses the membrane (in the out->in direction), we want the <tt>x</tt> parameter to be bound to _the original <tt>wetB</tt>_ object, i.e. we want the membrane wrapper to be automatically _unwrapped_. Again, the membrane implementation needs WeakMaps to be able to distinguish and unwrap its own wrappers. The same kind of unwrapping is needed in the other direction (in->out):

{% highlight javascript %}
wetA.identity = function(x) { return x; }
var result = dryA.identity(dryC);
// result === dryC? yes!
{% endhighlight %}

My current [experimental version](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/simpleMembrane.js) of membranes doesn't uphold identity yet, but a sketch of how it would work using the old proxy API is still available [here](http://wiki.ecmascript.org/doku.php?id=harmony:proxies#an_identity-preserving_membrane). **Update**: a membrane implementation using the latest direct proxies API, which upholds object identity across both sides of the membrane, is available [here](https://github.com/tvcutsem/harmony-reflect/blob/master/examples/membrane.js).

## Only scratching the surface...

Revocable membranes only scratch the surface of what membranes can support. Often one can think of the wet objects inside of the membrane as some precious resource needing protection. But one can think of opposite use cases as well, where the dry outside world wants to be protected from the wet objects inside of the membrane. For instance, Mark Miller (designer of the Caja secure subset of Javascript) [came up with the idea](http://code.google.com/p/es-lab/#Script_Compartments) of wrapping (a secure version of) the Javascript <tt>eval</tt> function in a membrane so that any untrusted third-party code eval-ed with this wrapped <tt>eval</tt> function is born inside of a membrane: any references that code ever establishes to the outside environment would be wrapped. When the untrusted third-party code is no longer needed or wanted, the membrane can be revoked. Not only does this render the third-party code harmless (it no longer has access to anything in the enclosing environment), if the membrane is carefully implemented and the Javascript engine fully supports WeakMaps, then the GC can recognize that the membraned object graph is now fully isolated, and can be garbage-collected.

**Update**: read more about [the general principles behind membranes]({% post_url 2018-07-22-membranes.md %}).
