---
title: 43 years of actors: a taxonomy of actor models
layout: post
tags: actors
excerpt_separator: <!--more-->
comments: true
---
As part of his PhD thesis, my former PhD student Joeri De Koster has been deeply involved in actor languages and systems. Recently Joeri took the effort of transforming one of the chapters of his PhD thesis into a stand-alone paper that surveys different eminent actor systems and places them into a coherent taxonomy. He presented this work last month at the [AGERE workshop](http://2016.splashcon.org/track/agere2016#program) at SPLASH, and to my surprise it actually got picked up by others quicky, for instance, by Tony Garnock-Jones, who wrote an [excellent blog post](https://eighty-twenty.org/2016/10/18/actors-hopl) on the history of actors, and by Phil Wadler in a [recent paper](https://arxiv.org/abs/1611.06276).

<!--more-->

The four big actor families mentioned in our paper:

  * **Classic Actors**: actors are seen as an identity tied to a single piece of state and a set of message handlers. A functional base language can act upon received messages and transform the actor's entire state and message handlers. The Akka framework follows this model.
  * **Processes**: actors are seen as isolated threads of control that may explicitly suspend execution to receive a matching message. Erlang and Scala actors follow this model.
  * **Active Objects**: actors are seen as OOP objects with their own thread of control, by contrast with "passive" objects that are shared by-copy between actors. ASP, Salsa and Orleans follow this model.
  * **Communicating Event Loops**: actors are seen as heaps of regular objects, and objects in one actor can directly reference specific objects in other actors, even though asynchronous communication between those objects is enforced. E and my own AmbientTalk language follow this model.
  
The paper is [officially published](http://dl.acm.org/citation.cfm?doid=3001886.3001890) in the ACM digital library, but here's a [direct link](http://soft.vub.ac.be/Publications/2016/vub-soft-tr-16-11.pdf) to the author's copy.