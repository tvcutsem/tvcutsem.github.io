---
title: Notification Proxies
layout: post
tags: javascript proxies membranes
permalink: notification-proxies
excerpt_separator: <!--more-->
comments: true
---
At the May TC39 meeting I [presented](http://soft.vub.ac.be/~tvcutsem/invokedynamic/presentations/Notification Proxies-TC39-May-2013.pdf) [pdf] an overview of Notification Proxies, as a possible alternative to Direct Proxies. This post briefly summarizes my talk, and the feedback I got from the committee. tl;dr: notification proxies are off the table, we're sticking to direct proxies in ES6.<!--more-->

Notification Proxies were first proposed on the es-discuss mailing list by E. Dean Tribble as a way to circumvent the [invariant checks]({% post_url 2012-05-07-proxies-and-frozen-objects %}) required by Direct Proxies to ensure that proxies don't violate the general JavaScript object invariants. Notification Proxies are simpler and easier to specify than Direct Proxies. The key idea behind notification proxies is that they turn traps into event notification callbacks, which can _react_ to operations intercepted on the proxy, but cannot _directly affect_ the outcome of the intercepted operation. Instead, the intercepted operation is always forwarded to the wrapped target object. Since the trap is still invoked _before_ the intercepted operation is forwarded, the proxy handler can still update the target object before forwarding, so it can still _indirectly_ influence the outcome of the intercepted operation.

Here's a simple logger proxy that logs the outcome of all property accesses, written using direct proxies:

{% highlight javascript %}
var target = {};
var handler = {
  get: function(target, name, receiver) {
    console.log("getting: " + name);
    var result = Reflect.get(target, name, receiver);
    console.log("got: " + result);
    return result;
  }
};
var proxy = new Proxy(target,handler);
{% endhighlight %}

And here is the same example, implemented using notification proxies:

{% highlight javascript %}
var target = {};
var handler = {
  onGet: function(target, name, receiver) {
    console.log("getting: " + name);
    return function(target, name, receiver, result) {
      console.log("got: " + result);
    }
  }
};
var proxy = new Proxy(target,handler);
{% endhighlight %}

The <tt>onGet</tt> method is called when a property access is intercepted on the proxy, e.g. <tt>proxy.x</tt>. I renamed the <tt>get</tt> trap to <tt>onGet</tt> to make it clear that the trap is now a simple callback that doesn't compute and return a result. Second, the <tt>onGet</tt> trap no longer manually forwards the operation and manually returns the result. The forwarding happens automatically. The <tt>onGet</tt> trap does get to return a function that will act as a "post-trap": a hook that will be called _after_ the operation was forwarded to the target. This "post-trap" accepts the same arguments as the <tt>onGet</tt> "pre-trap" except that it additionally takes the outcome of the operation. In the above example, when intercepting <tt>proxy.x</tt>, <tt>result</tt> will be whatever value was returned from <tt>target.x</tt>. The post-trap can inspect the result (and if the result is a mutable object, it could still mutate it), but it cannot change the outcome of the intercepted operation anymore. That is to say, <tt>proxy.x</tt> will return <tt>result</tt> regardless of what the post-trap does.

Because the notification proxy always returns values that were retrieved directly from the target object, rather than provided by the handler trap (as in the case for direct proxies), the notification proxy doesn't need to verify whether the handler's return value is consistent with the target object's invariants. For example, if <tt>target</tt> is frozen, then <tt>target.x</tt> is a non-configurable, non-writable property. In that case, <tt>proxy.x</tt> must consistently return the same value that <tt>target.x</tt> denotes. With notification proxies, this is trivially enforced without any explicit assertions.

## Direct and Notification Proxy Polyfills

I previously [implemented](https://github.com/tvcutsem/harmony-reflect) direct proxies on top of [original harmony:proxies](http://wiki.ecmascript.org/doku.php?id=harmony:proxies) so that one can already experiment with direct proxies on platforms that implement the original proxies, but not yet direct proxies (at the time of writing that would be Chrome and node.js. Firefox provides both original and direct proxies.). To similarly test notification proxies, I did a similar [implementation](https://github.com/tvcutsem/harmony-reflect/tree/master/notification) of notification proxies on top of original proxies. Interestingly, the proxy handler logic for notification proxies took 850 LoC, compared to 312 LoC for notification proxies, testifying to the simplicity of notification proxies.

## Implementing Membranes with Direct Proxies

To further compare notification proxies with direct proxies, I implemented the [membrane](js-membranes) abstraction using both. The goal of a membrane is to isolate two object graphs. Membranes serve as a "litmus test" for the expressiveness of a Proxy API, as they are quite tricky to implement: the membrane must keep the wrapped object graphs isomorphic, and must maintain invariants across the membrane, i.e. a frozen object inside the membrane must be represented as a frozen proxy object outside of the membrane.

Implementing membranes with direct proxies is relatively straightforward as long as you don't care about invariants (i.e. frozen objects). This is the "try 1" approach from the slides. The basic idea is that a membrane proxy, in each of its intercepted operations, forwards the operation to its target object on the other side of the membrane by wrapping all non-primitive arguments to the operation and unwrapping the result. Note that in the slides, I use the convention of prefixing variables with a "wet" or "dry" prefix to describe whether they refer to values inside or outside of the membrane.

The straightforward membrane implementation of membranes with direct proxies breaks down when the direct proxy wraps a frozen object. In that case, the direct proxy [invariant checks]({% post_url 2012-05-07-proxies-and-frozen-objects %}) will prevent the proxy from returning wrappers for frozen properties, to guarantee immutability. To make matters more concrete, consider the following setup:

{% highlight javascript %}
var wetB = {};
var wetA = Object.freeze({ x: wetB });
var dryA = wet2dry(wetA);
var dryB = dryA.x;
{% endhighlight %}

Visualised:

<center><img src="/assets/Membrane_Frozen.jpg" width="60%" alt="membranes and frozen objects"></src></center>

However, when executing the above code, a problem occurs when accessing <tt>dryA.x</tt>:

{% highlight javascript %}
dryA.x
// TypeError: cannot report inconsistent value for non-writable, non-configurable property ‘x’
{% endhighlight %}

What is going on here? Because <tt>wetA</tt> is frozen, <tt>wetA.x</tt> is a so-called "non-configurable non-writable" property. This means that <tt>wetA.x</tt> will forever refer to the <tt>wetB</tt> object. The <tt>dryA</tt> direct proxy for <tt>wetA</tt> will not allow the proxy to return any other object than <tt>wetB</tt> from its <tt>get</tt> trap for the "x" property. However, the membrane returns a wrapper (a proxy) for <tt>wetB</tt>, which causes the assertion inside the proxy to fail, resulting in the above TypeError.

The necessary workaround is to have the direct proxy wrap a dummy, "shadow target" that will store wrapped properties of the "real" target. The basic idea is that, when a frozen (immutable) property is accessed, the proxy handler defines a wrapped version of the frozen property on its shadow and returns the wrapped frozen property. The direct proxy will then find the same wrapped frozen property on the shadow target, so the assertion succeeds. The "shadow target" is the target object that the direct proxy refers to directly. The direct proxy doesn't know about the "real target" directly. Only the proxy handler holds onto a reference to the "real target". The technique is described in full in [this paper](http://soft.vub.ac.be/Publications/2013/vub-soft-tr-13-03.pdf) (section 4).

Applying the shadow target technique to membranes, the key idea (due to Mark S. Miller) is to have the shadow and the real target sit on opposite sides of the membrane. For instance, for a dry-to-wet proxy, the "real target" is "wet" (i.e. inside the membrane), while the "shadow target" is dry (i.e. outside the membrane). Whenever the dry-to-wet membrane proxy intercepts an operation, it retrieves the wet target's property and wraps it, defining a dry equivalent property on the shadow. Afterwards, it just forwards the intercepted operation to the dry shadow, which will at that point be correctly initialized.

<center><img src="/assets/Membrane_Shadow.jpg" width="60%" alt="membranes and shadow targets"></src></center>

One "optimization" that membranes implemented using direct proxies can perform is to test whether the target object is frozen and if not, use the simple "try 1" approach of forwarding the operation to the target directly. If the target is frozen, the membrane can fall back on using the shadow target to define the wrapped property. In other words: as long as the target object is not actually frozen, the membrane does not need to copy properties onto the shadow target.

[Here's](https://github.com/tvcutsem/harmony-reflect/blob/master/examples/membrane.js) the full implementation of membranes using direct proxies.

## Implementing Membranes with Notification Proxies

Implementing membranes using notification proxies is similar to implementing membranes using direct proxies. Just like direct proxies, notification proxies must make use of the "shadow target" technique. The big difference is that while direct proxies must use this technique only when dealing with frozen objects, notification proxies must _always_ use this technique, even for non-frozen objects. This is because the notification proxy will always forward any intercepted operation to its (shadow) target, regardless of invariants, so the notification proxy handler must always make sure to "synchronize" the state of its real and shadow targets in the pre-trap.

[Here's](https://github.com/tvcutsem/harmony-reflect/blob/master/notification/membrane.js) the full implementation of membranes using notification proxies.

The conclusion of my little membrane experiment is that both direct and notification proxies can express membranes. Comparing lines of code, the direct proxy membrane implementation weighs in at 470 LoC, versus 402 LoC for notification proxy membranes. The direct proxy implementation does perform the optimization that if the target is not frozen, the shadow target is not consulted. The notification proxy implementation naively always updates the shadow for each intercepted operation. That explains the difference in LoC. In terms of overall complexity of the membrane implementation, I would say that direct and notification proxies are on-par.

## Micro-benchmarks

In order to get _some_ indication of the _relative_ performance difference between direct and notification proxies, I ran some [micro-benchmarks](https://github.com/tvcutsem/harmony-reflect/tree/master/test/membranes).

The basic setup is that we create a large data structure (a large array, and a large binary tree), which then gets wrapped in a membrane. The micro-benchmark then measures the time taken to traverse this large data structure from outside of the membrane. This requires each individual array element or tree node to cross the membrane. I ran these micro-benchmarks both for the case where the data structure is frozen (i.e. has strong invariants) vs. non-frozen (i.e. has no invariants). This matters because of the previously described "optimization" that direct proxies can do when they're wrapping non-frozen objects.

I ran the benchmarks in the two browsers that currently provide support for proxies and weak maps: Firefox and Chrome. I believe this comparison between direct and notification proxies is apples-to-apples in that both are self-hosted implementations in JavaScript. Note that I am only looking at _relative_ perf. I'm not interested in absolute numbers because my <tt>reflect.js</tt> shim is adding too much noise. Built-in proxy implementations will be orders-of-magnitude faster. Similarly I'm not interested in the difference in timing between Firefox and Chrome, or between frozen and non-frozen objects. I'm only interested in the relative perf difference from running the same traversal, in the same browser, with direct vs notification proxies.

As the results in the [slide deck](http://soft.vub.ac.be/~tvcutsem/invokedynamic/presentations/Notification Proxies-TC39-May-2013.pdf) show, the results are very inconclusive. From these results one cannot say whether one API is faster than the other. My gut feeling is that either API can probably be made efficient. The key point is that notification proxies must always use the shadow target technique when they're implementing "virtual object" wrappers such as membranes.

## Summary

Eventually, TC39 decided to stick with direct proxies, for two (good) reasons. The first is that notification proxies, while they are simpler and easier to specify, put more burden on Proxy users because they require Proxy users to use the (admittedly complex) "shadow target" technique for all virtual object use cases. In other words, they make life easier for the spec but not necessarily for the developer. That's optimizing for the wrong audience.

Notification proxies were also motivated by a fear that the invariant checks for direct proxies are hard to get right, and easy to overlook, thus allowing attackers to create proxy objects that deliberately violate JavaScript's invariants to confuse other scripts. Such bugs in the specification [have come up before](https://bugzilla.mozilla.org/show_bug.cgi?id=795903). The counter-argument that was made is that such spec loopholes can be closed, and implementations can issue patches swiftly when security is at stake.

All in all, I think Notification Proxies provide an attractive, simpler alternative to Direct Proxies given JavaScript's fairly complex [object model]({% post_url 2012-06-14-a-brief-tour-of-javascripts-object-model %}). That said, the need to use the "shadow target" technique to express certain abstractions such as membranes or higher-order contracts, even for non-frozen objects, is pretty tedious. With three proxy designs now worked out in detail (original proxies, direct proxies and notification proxies) we have a solid overview of the design space. Language design always entails trade-offs, so every API will always have use cases that it supports better than the others. Overall though, I'm happy to settle on the direct proxies API.