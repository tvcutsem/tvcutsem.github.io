---
title: Direct Proxies talk at ECOOP
layout: post
tags: javascript proxies membranes ecoop talk
permalink: directproxies-ecoop
---
Yesterday I gave a talk at the European Conference on Object-oriented Programming ([ECOOP](http://www.lirmm.fr/ecoop13/)) on our [paper](http://soft.vub.ac.be/Publications/2013/vub-soft-tr-13-03.pdf) on direct proxies in JavaScript. The slides are available [online](http://soft.vub.ac.be/~tvcutsem/invokedynamic/presentations/TrustworthyProxies.pdf). The talk is basically recounting the story of how Mark and I refactored the [original](http://wiki.ecmascript.org/doku.php?id=harmony:proxies) JavaScript Proxy API into the current [direct proxies](http://wiki.ecmascript.org/doku.php?id=harmony:direct_proxies) API because of the interaction between proxies and frozen objects. I have previously written about that interaction [on my blog]({% post_url 2012-05-07-proxies-and-frozen-objects %}). The paper further focuses on [membranes]({% post_url 2012-03-29-membranes-in-javascript %}) as a case study for proxies.