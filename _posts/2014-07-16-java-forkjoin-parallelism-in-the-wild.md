---
title: Java Fork/Join Parallelism in the Wild
layout: post
tags:
  - java
  - fork/join
  - parallel programming
---
My student [Mattias De Wael](http://soft.vub.ac.be/~madewael/), with guidance from [Stefan Marr](http://soft.vub.ac.be/~smarr/) and myself, recently published a study on how the [Java Fork/Join](http://docs.oracle.com/javase/tutorial/essential/concurrency/forkjoin.html) framework is being used in practice by developers. From the abstract:

> The Fork/Join framework [...] is part of the standard Java platform since version 7\. Fork/Join is a high-level parallel programming model advocated to make parallelizing recursive divide-and-conquer algorithms particularly easy. While, in theory, Fork/Join is a simple and effective technique to expose parallelism in applications, it has not been investigated before whether and how the technique is applied in practice. We therefore performed an empirical study on a corpus of 120 open source Java projects that use the framework for roughly 362 different tasks. On the one hand, we confirm the frequent use of four best-practice patterns (from Doug Lea's book) -- Sequential Cutoff, Linked Subtasks, Leaf Tasks, and avoiding unnecessary forking -- in actual projects. On the other hand, we also discovered three recurring anti-patterns that potentially limit parallel performance: sub-optimal use of Java collections when splitting tasks into subtasks as well as when merging the results of subtasks, and finally the inappropriate sharing of resources between tasks.

To me, the most interesting outcome was the observation that the Fork/Join API could benefit from the Java Collections API being extended with collections that can be efficiently split and merged. Often, developers choose suboptimal data structures, or suboptimal methods on existing data structures to do recursive splits/merges. Although perhaps that isn't even necessary, as it turns out [Java 8 Streams](http://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html) effectively cover typical use cases of Fork/Join such as parallel maps and reduces, without the developer having to manually split and merge the collection anymore. The paper has been accepted at [PPPJ 2014](http://www.pppj2014.uck.pk.edu.pl/). The original submission can be accessed [here](http://soft.vub.ac.be/Publications/2014/vub-soft-tr-14-08.pdf).