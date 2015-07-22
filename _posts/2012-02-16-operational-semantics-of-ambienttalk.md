---
title: Operational Semantics of AmbientTalk
layout: post
tags:
  - AmbientTalk
  - formal semantics
  - event loop concurrency
permalink: atsemantics
---
Together with PhD students [Christophe Scholliers](http://soft.vub.ac.be/~cfscholl/) and [Dries Harnie](http://soft.vub.ac.be/~dharnie/), I recently completed an operational semantics of our [AmbientTalk](http://ambienttalk.googlecode.com) programming language. We believe this is the first formal account of an actor language based on communicating event loops. The paper is currently available as a [techreport](http://soft.vub.ac.be/Publications/2012/vub-soft-tr-12-04.pdf). From the abstract:

> We present an operational semantics of a key subset of the AmbientTalk programming language, AT-Lite. The subset focuses on its support for asynchronous, event-driven programming. AmbientTalk is a concurrent and distributed language that implements the so-called communicating event loops model.

Christophe has written an executable version of the operational semantics in [PLT Redex](http://redex.plt-scheme.org/). You can read all about that [here](http://soft.vub.ac.be/~cfscholl/index.php?page=at_semantics).

The operational semantics builds on that of a similar model, [JCobox](https://softech.cs.uni-kl.de/Homepage/JCoBox), but significantly adapts it to more accurately reflect the semantics of AmbientTalk's futures, which are based on [E](http://www.erights.org)'s promises and are entirely non-blocking. And unlike JCoBox, AmbientTalk does not support cooperative multitasking within an actor, only purely sequential, run-to-completion execution of incoming messages, much like a Javascript per-frame event loop.