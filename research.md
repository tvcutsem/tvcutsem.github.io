---
title: Research
layout: page
permalink: /research/
---

# Research

My broad research area involves programming languages, distributed systems and software engineering. In short, my goal is to help developers write code better (the software engineering view), and to write better code (the programming languages view).

Below is a brief overview of concrete research projects I have worked on, with pointers where to learn more.

### Machine Learning on Code

At Bell Labs between 2018 and 2021 I've worked on novel developer tools that "learn from code", including [code completion](https://arxiv.org/abs/2108.05198) from natural language using neural language models, [code snippet retrieval](https://arxiv.org/abs/2008.12193) via neural code search and a [package recommendation engine](https://bell-labs.com/code-compass) based on machine-learned representations of software libraries ([import2vec](https://arxiv.org/abs/1904.03990)). These tools have been used by software developers at Nokia.

### Distributed Stream Processing

At Bell Labs between 2015 and 2017 I co-architected a distributed stream processing platform called [World Wide Streams](https://worldwidestreams.io) which is now in use inside Nokia. My main contribution was in the platform's dataflow specification language [XStream]({{site.asseturl}}/XStream_ifip17.pdf) and its compiler. Dataflows written in XStream are compiled into query plans and seamlessly deployed across a wide-area compute infrastructure (across device, edge and core Cloud).

### Reflection and Metaprogramming

I was the main designer of the ECMAScript 2015 [Proxy API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) and [Reflect API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect), with Mark S. Miller. They are now available in all major browsers.

I maintain a self-hosted [implementation of Proxies and the ECMAScript Reflect API in JavaScript](https://github.com/tvcutsem/harmony-reflect) (mostly useful to use as a shim in older pre-ES6 environments). Over a 100 packages on NPM depend on it.

My work on JavaScript Proxies was partly inspired by earlier work on [Mirages](http://soft.vub.ac.be/Publications/2007/vub-prog-tr-07-16.pdf) in the AmbientTalk programming language, work that won us the DLS 2017 [most notable paper award](https://dynamic-languages-symposium.org/media/dls2017mnp2007.pdf).

### Ambient-oriented Programming

When I started my PhD in the early 2000s, smartphones as we know them today did not exist. There was no iPhone, no Android. There were awkward precursors to smartphones running on Windows CE, Symbian or J2ME. Developing applications for phones was a real pain, and mobile connectivity was expensive, slow and scarce (2G networks). Social networks barely existed. And yet, we understood the power of connected apps on phones. We just had to figure out a better way to program these apps.

It was in that context that me and colleagues at the VUB Software Languages Lab defined [Ambient-oriented programming](http://soft.vub.ac.be/amop), a new programming paradigm geared towards writing peer-to-peer applications running on mobile "ad hoc" networks. A defining feature of the paradigm was that network failures are treated as a normal mode of operation.

We designed the first "ambient-oriented" programming language which we called AmbientTalk. It was a dynamic scripting language, implemented on top of the JVM (not unlike e.g. Rhino, the JVM JavaScript engine), and when Android became widespread by 2010 we primarily ran AmbientTalk on Dalvik.

AmbientTalk was featured in [MIT Technology Review](https://www.technologyreview.com/s/419956/new-languages-and-why-we-need-them/), in the Belgian Techzine [Datanews](http://soft.vub.ac.be/~tvcutsem/talks/presentations/datanews_feb2011.pdf) (article in Dutch), and software developed with AmbientTalk won prizes at DroidCon, such as a [collaborative drawing editor](https://www.youtube.com/watch?v=k0HYqRCxtHc) and a [peer-to-peer poker game](https://www.youtube.com/watch?v=HtYfGa0i2E0).

Over the many years as a PhD and Post-doc student at the Vrije Universiteit Brussel, I [co-authored multiple papers on AmbientTalk](http://soft.vub.ac.be/amop/research/atpapers) and its features. Probably the best overview paper is [this one from 2007](http://soft.vub.ac.be/Publications/2007/vub-prog-tr-07-17.pdf).

My PhD thesis ultimately focused on a very specific feature of AmbientTalk called [ambient references](http://soft.vub.ac.be/amop/research/ambientrefs): object pointers designed for mobile networks.

### Concurrent and Parallel Computing

I worked on a variety of concurrency control abstractions for programming languages, with a primary focus on a particular concurrency control paradigm called the [Actor Model](https://en.wikipedia.org/wiki/Actor_model). See for instance our taxonomy paper ["43 years of actors"](http://soft.vub.ac.be/Publications/2016/vub-soft-tr-16-11.pdf).

I have also worked on Event Loop concurrency (widely deployed in JavaScript/nodejs), Futures/Promises and Reactive Programming (see our [ACM Computing Surveys paper](http://soft.vub.ac.be/Publications/2012/vub-soft-tr-12-13.pdf) on the subject).

With Philipp Haller from the Scala team at EPFL, I designed [a library for Joins in Scala](http://lampwww.epfl.ch/~phaller/joins/index.html). I later contributed a chapter on MapReduce in Scala in Haller's book [Actors in Scala](https://www.amazon.com/Actors-Scala-Philipp-Haller/dp/0981531652).

I also studied parallel computing models, with papers on [Java Fork/Join](http://soft.vub.ac.be/Publications/2014/vub-soft-tr-14-08.pdf) and an [ACM Computing Surveys paper](https://dl.acm.org/citation.cfm?id=2716320) on Partitioned Global Address Space (PGAS) models.

### Software composition with traits

I did research on new ways to compose objects in object-oriented programs, taking a lot of inspiration from the original research work on [Traits](http://www.iam.unibe.ch/~scg/Research/Traits).

Our AmbientTalk language supports [traits with state and visibility control](https://soft.vub.ac.be/Publications/2009/vub-prog-tr-09-04.pdf) by exploiting lexical nesting.

Later I designed a JavaScript library called [Traits.js](https://github.com/traitsjs/traits.js). To learn more about it, see this [blog post](https://howtonode.org/traitsjs) on HowToNode.

### Distributed Secure Computing

See [this post]({% post_url 2013-01-21-distributed-resilient-secure-ecmascript %}).

### Miscellaneous projects

A variety of software projects can be found on my [GitHub page](https://github.com/tvcutsem).