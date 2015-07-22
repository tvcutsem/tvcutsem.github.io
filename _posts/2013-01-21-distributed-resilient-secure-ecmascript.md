---
title: Distributed Resilient Secure ECMAScript (Dr. SES)
layout: post
tags:
  - javascript
  - SES
  - promises
  - Q
  - Dr. SES
  - smart contracts
permalink: drses
---
This post is about a project I've been working on together with Mark Miller (with the help of many others) which we call "Dr. SES", for Distributed Resilient Secure ECMAScript". Dr. SES is a JavaScript extension aimed at secure, distributed computing.

Dr. SES extends JavaScript with three features:

*   **SES**: Dr. SES builds upon [SES](http://code.google.com/p/google-caja/wiki/SES), the capability-secure subset of JavaScript. SES enables the safe execution of mobile code.
*   **Q**: To engage in distributed computing, we need abstractions to send messages to remote objects, and the Promise abstraction to more easily manage asynchronous computations. Mark has previously [proposed some extensions to ECMAScript](http://wiki.ecmascript.org/doku.php?id=strawman:concurrency) to achieve precisely this. Luckily we do not have to wait for these extensions to land. Except for some syntactic sugar, we can get most of the functionality today via Kris Kowal's [Q library](https://github.com/kriskowal/q).
*   **Ken**: [Ken](http://ai.eecs.umich.edu/~tpkelly/Ken/) is a middleware that provides a persistent heap and reliable messaging between such persistent heaps. By integrating Ken with an existing JavaScript engine, we can achieve a JavaScript platform that persists across failures. One of my students is currently working on integrating Ken with the v8 engine, leading to an engine we call [v8-ken](https://github.com/supergillis/v8-ken).

Mark recently got invited as a speaker at [ESOP 2013](http://www.ccs.neu.edu/esop2013/), and was given the opportunity to publish a paper to go along with the talk. The paper is probably the first written exposition of Dr. SES to date. It got published only recently, here's a [link to the pre-published version](http://soft.vub.ac.be/Publications/2013/vub-soft-tr-13-01.pdf). The subject of the paper is not really about Dr. SES, but rather about what type of applications we can achieve on top of a platform such as Dr. SES. Nevertheless, Section 2 provides a good background on what Dr. SES ought to become. The paper is really a progress report, as Dr. SES is still very much a work in progress. Quoting the abstract of the paper:

> Contracts enable mutually suspicious parties to cooperate safely through the exchange of rights. Smart contracts are programs whose behavior enforces the terms of the contract. This paper shows how such contracts can be specified elegantly and executed safely, given an appropriate distributed, secure, persistent, and ubiquitous computational fabric. JavaScript provides the ubiquity but must be significantly extended to deal with the other aspects. The first part of this paper is a progress report on our efforts to turn JavaScript into this fabric. To demonstrate the suitability of this design, we describe an escrow exchange contract implemented in 42 lines of JavaScript code.

The paper is based on two earlier talks of Mark:

*   Bringing Object-orientation to Security Programming ([video](http://www.youtube.com/watch?v=oBqeDYETXME), [slides](http://soft.vub.ac.be/events/mobicrant_talks/talk2_OO_security.pdf)), which provides a good introduction to object-capabilities and the Purse example in particular.
*   Two-phase commit among strangers ([slides](https://es-lab.googlecode.com/files/friam.pdf), [audio](https://docs.google.com/file/d/0Bw0VXJKBgYPMU1gzQ3hkY0Vrbmc/edit)), which provides a general overview of Dr. SES (with a particular focus on Q) and of the escrow exchange contract, which is discussed in detail in the paper.

The source code discussed in the paper is [available](http://code.google.com/p/es-lab/source/browse/trunk/src/ses/contract/).