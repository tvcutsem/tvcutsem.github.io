---
title: Research
layout: page
permalink: /research/
---
_There are creatures which have evolved to live in coral reefs and simply could not survive in the rough, tooth-filled wastes of the open sea. They continue to exist by lurking among the dangerous tentacles of the sea anemone or around the lips of the giant clam and other perilous crevices shunned by all sensible fish._

_A university is very much like a coral reef. It provides calm waters and food particles for delicate yet marvellously constructed organisms that could not possibly survive in the pounding surf of reality, where people ask questions like 'Is what you do of any use?' and other nonsense._

<div style="text-align:right">- Terry Pratchett, Ian Stewart & Jack Cohen, The Science of Discworld</div>

## Keywords

My area of expertise is [programming language theory](http://en.wikipedia.org/wiki/Programming_language_theory), with a particular focus on concurrent, distributed and parallel programming languages. Some keywords to capture what I have been working on in the past:

*   programming language design
*   distributed computing
*   concurrency control (actors, STM, event-driven computing)
*   multi-core and parallel computing
*   virtual machines, interpreters, compilers
*   object-oriented composition (traits)
*   mobile computing, mobile ad hoc networks
*   AmbientTalk
*   JavaScript

## Javascript

From November 2009 to April 2010 I was a Visiting Faculty member at Google in Mountain View, USA. Together with [Mark S. Miller](http://www.erights.org) I experimented with proposed extensions to the Javascript programming language (a project known as [ES-lab](http://code.google.com/p/es-lab/)). Concretely:

*   We proposed [proxies](http://wiki.ecmascript.org/doku.php?id=strawman:proxies) for inclusion in a future ECMAScript standard. This proposal is based on the reflective architecture of AmbientTalk.
*   We created an [OMeta](http://tinlizzie.org/ometa)-based [parser](http://es-lab.googlecode.com/svn/trunk/site/esparser/index.html) for the latest ECMAScript standard (edition 5). This parser is used in a meta-circular experimental [interpreter](http://code.google.com/p/es-lab/source/browse/trunk/src/eval/eval.js) and a [verifier](http://code.google.com/p/es-lab/source/browse/trunk/src/ses/verifySES.js) for [SES](http://code.google.com/p/es-lab/wiki/SecureEcmaScript), a secure subset of ECMAScript.
*   We have implemented a [traits library](http://code.google.com/p/es-lab/wiki/Traits) for Javascript, enabling the robust composition of objects via reusable traits.

## Concurrency Control

It is widely known throughout the field of computer science that developing concurrent software is notoriously difficult. I am interested in concurrency models that can make this burdensome task easier to perform for the programmer. I am particularly interested in event-driven concurrency models. **Event-driven models** seem a more natural fit for most software, which must react to various stimuli from both software and hardware sources. Moreover, event-driven systems have properties that make them less error-prone than the omnipresent shared-state concurrency model ("threads"). The advent of **multi-core processors** in particular seems to herald a new age of concurrent computing, one in which it is uncertain whether the contemporary concurrency models will remain scalable.

I am also interested in how event-driven concurrency can be combined with other abstractions already present in our software-development model, such as objects. In this light, I have been researching adaptations on Agha and Hewitt's well-known actor model. I am especially interested in how advanced concurrency control (**transactions**, **high-level synchronization**, ...) can be expressed in languages with inherent support for **event loop** concurrency such as [E](http://www.erights.org) and [AmbientTalk](http://prog.vub.ac.be/amop).

## Ambient-oriented Programming

At the [Software Languages Lab](http://soft.vub.ac.be) I am researching distributed programming languages designed for pervasive computing and mobile networks. More specifically, my colleagues and I have defined the [Ambient-oriented programming](http://soft.vub.ac.be/amop) paradigm as a superset of the distributed OOP paradigm. We have developed a concrete ambient-oriented programming language named [AmbientTalk](http://soft.vub.ac.be/amop). In **AmbientTalk**, network failures are considered the rule, rather than the exception, so programs developed in AmbientTalk are robust to failures by default. Of course, the programmer must still deal with these failures if they affect program behaviour. However, our premise is that, if the failure is only temporary (e.g. because of a network disconnection), then the program should not fail but rather continue to run without problems.

The AmbientTalk project targets so-called **mobile ad hoc networks**: computer networks comprised of mobile devices that communicate wirelessly, without any centralized servers (strictly peer-to-peer).

My PhD research was about [ambient references](http://soft.vub.ac.be/amop/research/ambientrefs).

## Programming language design & implementation

As co-designer of the AmbientTalk programming language, I remain interested in (almost) all facets of programming language design. In particular, I am interested in:

*   **software-composition techniques** such as [Traits](http://www.iam.unibe.ch/~scg/Research/Traits): how can we compose reusable building blocks into new functional program units?
*   **object models**: what is the best way to represent objects in an object-oriented language?
*   **reflection and metaprogramming**: what is a good object model to model other objects?
*   **language symbiosis (aka language interoperability)**: how can objects written different languages interact without breaking the rules enforced by their respective languages?