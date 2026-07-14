---
title: Research
layout: page
permalink: /research/
---

# Research

My research interests sit at the intersection of software security, distributed systems and PL/software engineering.

In recent years I have focused on decentralized distributed systems, blockchains and smart contracts, both from a language engineering perspective (designing safer languages to write smart contracts) as well as from a systems engineering perspective (building more trustless ways to interact with smart contracts).

## Ongoing Work

With my PhD student Weihong Wang I am working on [disintermediating Web3's access layer]({% post_url 2025-07-14-parp-depermissioning-web3s-serving-layer %}). We also study [privacy threats in Web3 wallets](https://arxiv.org/abs/2607.06141).

With my PhD student Glenn De Witte I am exploring authenticated data structures and specifically transparency log systems and their applications to software supply-chain security.

With my PhD student Olav Blaak I am working towards [Least-privilege WebAssembly](https://dl.acm.org/doi/full/10.1145/3801119.3801125) components and improved software supply-chain security, through a combination of program analysis and middleware tools.

With my PhD student Weihe Gao I am working on byzantine fault-tolerant stateful serverless computing.

A personal interest of mine is the design of [secure distributed object systems]({% post_url 2013-01-21-distributed-resilient-secure-ecmascript %}) as a foundation for writing capability-secure smart contracts. I explore this topic as part of an FWO Fundamental research project called CapableContracts (2026--2029), with my colleagues Dominique Devriese and Steven Keuchel.

## Past Projects

Below is a brief overview of past research projects I have worked on in past roles, with pointers on where to learn more.

### Machine Learning on Code

At Bell Labs between 2018 and 2021 I've worked on novel developer tools that "learn from code", including [code completion](https://arxiv.org/abs/2108.05198) from natural language using neural language models, [code snippet retrieval](https://arxiv.org/abs/2008.12193) via neural code search and a [package recommendation engine](https://bell-labs.com/code-compass) based on machine-learned representations of software libraries ([import2vec](https://arxiv.org/abs/1904.03990)). These tools have been used by software developers at Nokia.

Toward the end of the project, it became clear to us that large language models would enable effective AI pair programming using plain English, a vision that we called [Natural-language Guided Programming](https://arxiv.org/abs/2108.05198), published at the ACM Onward! Symposium just a few months before Github Copilot turned this vision into a fledgling reality.

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

### Secure Distributed Objects

See [this post]({% post_url 2013-01-21-distributed-resilient-secure-ecmascript %}).

### Programming Languages

Programming languages, their history, their design and their implementation are my favourite part of computer science. I enjoy reading about the genealogy of programming languages, how ideas from one language find their way into other languages, and so on. I am particularly fond of Scheme, Self, Smalltalk, Javascript, Prolog, Ruby, Clojure and Erlang. If you want to read some of my musings, see this [essay on why I do research on programming languages.]({% post_url 2011-01-23-why-programming-languages %})

I've been inspired the most by the following language designers:

  * Mark Miller, creator of E, for showing that security and modularity are two sides of the same coin.
  * Rich Hickey, creator of Clojure, for clearly articulating the differences between state and identity.
  * Doug Crockford, discoverer of JSON, for showing that less can be a lot more.
  * Dave Ungar and Randy Smith, creators of Self, for stressing the power of simplicity.
  * Alan Kay, creator of Smalltalk, for stressing uniformity.
  * Rob Pike, creator of Limbo, Plan 9 and Go, for reminding me of the power of CSP-style concurrency.
  * Joe Armstrong, creator of Erlang, for showing that actors can be damned practical for building robust software.

One of the best talks on the history of computing I came across is a talk by Doug Crockford titled [The Early Years](http://developer.yahoo.com/yui/theater/video.php?v=crockonjs-1) where he describes the major influences on Javascript. A more whimsical treatment of the history of programming languages is Guy Steele and Richard Gabriel's anniversary talk [50 in 50](http://blip.tv/file/1472720).

<div style="text-align: center; margin-left: auto; margin-right: auto;">
<img alt="lambda" src="/assets/lambda.gif"/>
<strong>Power to the lambda!</strong>
</div>

<div style="text-align:justify;font-size:0.8em; margin: 10px;">
  In its semantic structure Scheme is as closely akin to Algol 60 as to early Lisps. Algol 60, never to be an active language again, lives on in the genes of Scheme and Pascal. It would be difficult to find two languages that are the communicating coin of two more different cultures than those gathered around these two languages. Pascal is for building pyramids -- imposing, breathtaking, static structures built by armies pushing heavy blocks into place. Lisp is for building organisms -- imposing, breathtaking, dynamic structures built by squads fitting fluctuating myriads of simpler organisms into place. The organizing principles used are the same in both cases, except for one extraordinarily important difference: The discretionary exportable functionality entrusted to the individual Lisp programmer is more than an order of magnitude greater than that to be found within Pascal enterprises. Lisp programs inflate libraries with functions whose utility transcends the application that produced them. The list, Lisp's native data structure, is largely responsible for such growth of utility. The simple structure and natural applicability of lists are reflected in functions that are amazingly nonidiosyncratic. In Pascal the plethora of declarable data structures induces a specialization within functions that inhibits and penalizes casual cooperation. It is better to have 100 functions operate on one data structure than to have 10 functions operate on 10 data structures. As a result the pyramid must stand unchanged for a millennium; the organism must evolve or perish.
</div>

<div style="text-align:right">- Alan Perlis, from the foreword of the book Structure and Interpretation of Computer Programs by Abelson and Sussman.</div>