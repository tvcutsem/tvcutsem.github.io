---
title: JavaScript at Google Research
layout: post
tags: javascript ecmascript traits proxies ometa parser
---
I am currently a Visiting Faculty member at Google in Mountain View, USA. Together with [Mark Miller](http://www.erights.org) I am experimenting with [proposed extensions to the Javascript programming language](http://code.google.com/p/es-lab). Concretely:

*   We proposed [proxies](http://wiki.ecmascript.org/doku.php?id=strawman:proxies) for inclusion in a future ECMAScript standard. This proposal is based on the reflective architecture of AmbientTalk.
*   We created an [OMeta](http://tinlizzie.org/ometa)-based [parser](http://es-lab.googlecode.com/svn/trunk/site/esparser/index.html) for the latest ECMAScript standard (edition 5). This parser is used in a meta-circular experimental [interpreter](http://code.google.com/p/es-lab/source/browse/trunk/src/eval/eval.js) and a [verifier](http://code.google.com/p/es-lab/source/browse/trunk/src/ses/verifySES.js) for [SES](http://code.google.com/p/es-lab/wiki/SecureEcmaScript), a secure subset of ECMAScript.
*   We have implemented a [traits library](http://code.google.com/p/es-lab/wiki/Traits) for Javascript, enabling the robust composition of objects via reusable traits.