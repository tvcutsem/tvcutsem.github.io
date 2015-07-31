---
title: Designing the ECMAScript Reflection API
layout: post
tags: javascript reflection proxies ecmascript
permalink: esharmony_reflect
excerpt_separator: <!--more-->
comments: true
---
For the past two years, I have been working on a new Reflection API for ECMAScript (the Javascript standard) together with [Mark Miller](http://research.google.com/pubs/author35958.html). Its most novel feature is its support for proxies, objects whose behavior in response to a large number of built-in functions and operators can be controlled in Javascript itself.

Last week, I finally [finished a paper](http://soft.vub.ac.be/Publications/2012/vub-soft-tr-12-03.pdf) that not only describes the new API in some detail, but also describes the principles that helped steer our design. From the paper's abstract:

<!--more-->

> We describe in detail the new reflection API of the upcoming Javascript standard. The most prominent feature of this new API is its support for creating proxies: virtual objects that behave as regular objects, but whose entire "meta-object protocol" is implemented in Javascript itself. Next to a detailed description of the API, we describe a more general set of design principles that helped steer the API's design, and which should be applicable to similar APIs for other languages. We also describe access control abstractions implemented in the new API, and provide an operational semantics of an extension of the untyped lambda-calculus featuring proxies.

Some history: early 2010, Mark and I proposed a first version of our Proxy API that got accepted as a [Harmony proposal](http://wiki.ecmascript.org/doku.php?id=harmony:proxies). While that API was sufficient to cover its stated goals, it suffered from a number of drawbacks:

*   Proxies could not emulate non-extensible, sealed or frozen objects. Proxies were always extensible, and could not advertise non-configurable properties.
*   The handler API distinguished between what we called "fundamental" and "derived" traps, where the former were mandatory and the latter were optional. The interaction between fundamental and derived traps was subtle, and always having to implement all fundamental traps was cumbersome.
*   A large number of proxy use cases involve wrapping an existing "target" object, to which intercepted operations are forwarded. These use cases were cumbersome to write, requiring an accompanying [ForwardingHandler](http://wiki.ecmascript.org/doku.php?id=harmony:proxy_defaulthandler) to be able to forward operations.
*   Due to various spec. details, we ended up making a distinction between "object proxies" and "function proxies", where only function proxies could emulate functions. This introduced irregularity in our API.

Despite these drawbacks, the API was well-received and prototyped, very early on in Mozilla's tracemonkey engine (since Firefox 4, docs are [here](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Proxy)) and later [also](http://code.google.com/p/v8/issues/detail?id=1543) in Google's v8 engine.

Late 2011, when Mark visited our lab in Brussels, we substantially revised our earlier API to address the above issues (in all honesty, the first issue was what got us started, the other issues were fixed somewhat as a consequence of our refactoring). We referred to our revised API as [direct proxies](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies), since in the revised API, a proxy always directly refers to a wrapped target object, as opposed to the old API in which wrapping was indirect (the proxy referred to the handler only, and the handler would refer to the target object).

Direct proxies solve the above issues, and for many simple use cases (i.e. those involving wrapping other objects), require considerably less code. For these reasons, our updated API was accepted as a replacement for the earlier API at the TC39 November 2011 meeting.

Direct proxies are, as of this writing, not yet prototyped in any major Javascript engine. However, it is possible to shim the new API based on the old API. This is precisely what my [DirectProxies.js](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/DirectProxies.js) script does: it monkey-patches the global Proxy object to support the new API. In addition, it also defines a global <tt>Reflect</tt> object that houses the new [reflection module](http://wiki.ecmascript.org/doku.php?id=harmony:reflect_api). This module basically defines a number of reflective functions, mirroring the handler traps of the Proxy API. Proxy handler objects can use the module to easily forward intercepted operations, but the functions are useful in their own right. Due to Javascript's powerful reflective features, most of these operations are trivial to implement in Javascript itself, but not all of them (e.g. <tt>Reflect.get</tt>, <tt>Reflect.set</tt> and <tt>Reflect.construct</tt>).

I'm currently [in the process of migrating](https://github.com/tvcutsem/harmony-reflect) my <tt>DirectProxies.js</tt> shim to github. I've renamed it to [reflect.js](https://github.com/tvcutsem/harmony-reflect/blob/master/reflect.js) since this more accurately captures the fact that this is a shim for the entire upcoming reflection module, not only proxies. Emulation of direct proxies currently works in Firefox 8 only, but the Reflect API in general should run on other browsers as well (currently tested on tracemonkey and v8). Look for more tests soon.

One last point: in the [paper](http://soft.vub.ac.be/Publications/2012/vub-soft-tr-12-03.pdf), we use membranes as an example use case for proxies. [Membranes](http://wiki.ecmascript.org/doku.php?id=harmony:proxies#an_identity-preserving_membrane) are transitive wrappers: you start out wrapping a single object, and every object that crosses the membrane (typically via function parameter-passing or return values) is transitively wrapped. Each membrane comes with a single kill-switch that can instantly nullify all references that cross the membrane (this is called "revocation"). I have been [experimenting with membranes](http://code.google.com/p/es-lab/source/browse/trunk/src/proxies/simpleMembrane.js) and the new direct proxies API and things seem to be working out so far, but membranes deserve a post all by themselves. Stay tuned.