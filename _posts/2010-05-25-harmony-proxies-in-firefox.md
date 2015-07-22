---
title: Harmony Proxies in Firefox
layout: post
tags:
  - javascript
  - ecmascript harmony
  - proxies
---
Andreas Gal from Mozilla is implementing the Proxy API that I developed at Google in collaboration with Mark S. Miller. This API enables the creation of dynamic proxies that can intercept a variety of operations applied to Javascript objects. Proxies are currently available in the [Firefox 3.7a pre-release](http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/) and are scheduled to be included in the next Ecmascript standard. I am in the process of writing up a small [tutorial]({% post_url 2011-11-25-harmony-proxies-tutorial %}) to introduce this new feature. A [draft specification](http://wiki.ecmascript.org/doku.php?id=harmony:proxies) of the feature for inclusion into ECMAScript harmony is available, and a [Google Tech Talk](http://www.youtube.com/watch?v=A1R8KGKkDjU) that explains the rationale of our design. Javascript proxies were in part inspired by my earlier work on [mirages in AmbientTalk](http://soft.vub.ac.be/amop/at/tutorial/reflection#mirages).