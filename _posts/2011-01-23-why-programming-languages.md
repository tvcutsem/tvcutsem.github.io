---
title: Why Programming Languages?
permalink: whypls
layout: post
tags:
  - programming languages
  - essay
excerpt_separator: <!--more-->
comments: true
disqus: 'invokedynamic'
---
When I present my research work on programming languages, people often ask me _"why do you need a new programming language to solve this problem? Why not just implement it as a library?"_ Or, I get asked _"why didn't you implement it as an extension to {some existing language}?"_ In this essay I will try to make explicit some of the goals and motivations behind language design.
They are formulated wholly from my own background in this area, so I might be missing some important ones I haven't thought about.

<!--more-->

In this essay, I will distinguish four primary goals that can drive the language design process:

*   Language as syntactic abstraction mechanism: to reduce repetitive "boilerplate" code that cannot be abstracted from using another language's built-in abstraction mechanisms.
*   Language as thought shaper: to induce a paradigm shift in how one should structure software (changing the "path of least resistance").
*   Language as a simplifier: to boil down an existing paradigm to just its essential parts, often to increase understanding and insight.
*   Language as law enforcer: to enforce important properties or invariants, possibly to make it easier to infer more useful properties from programs.

These particular goals are not necessarily always present and explicit in a language designer's mind when he or she starts to develop a new language. Quite the contrary, I think they're often only implicitly present, and may change as the language grows. They're also not exclusive, and different parts of a language may be driven by different goals. In what follows, I will abstract from such details of the language design process and will discuss each of these goals in separation.

### Language as syntactic abstraction mechanism

It seems to me this is the most common reason why people turn to new programming languages. Often, the goal is to provide a pleasant new lightweight syntax that lets programmers do the same things as before, but with less code. I think this at least partially explains the shift in popularity from Java to Scala. Domain-specific languages often, but not always, fall into this category.

It follows from this view that the more powerful the syntactic abstraction mechanisms of a language are, the less there is a need to escape to new languages to avoid boilerplate. Macros in the Lisp family of languages come to mind. Because macros can abstract virtually any syntactic pattern in these languages, a Lisp programmer often thinks of a domain-specific language simply as a set of macros and sees no need to escape to an external language.

Scripting languages often pursue the goal of syntactic abstraction, as they mostly embrace a very lightweight syntax (consider, for example, Python's use of indentation for grouping, or the conciseness of I/O and string manipulation in virtually all scripting languages). Yet these languages often have many other goals, such as further boosting productivity by reducing the amount of incantations required to get a program to execute. It seems to me that scripting languages are not often innovative in terms of the paradigm they embrace, but are often heavily influenced by the "thought shaper" and "simplifier" languages discussed below.

If we were to make the analogy with natural languages, using a language as a syntactic abstraction mechanism is like changing the vocabulary of a natural language, for instance inventing a new word for an existing concept. A domain-specific language in computing is like a technical jargon in other professions.

### Language as thought shaper

To quote [Alan Perlis](http://www.cs.yale.edu/quotes.html): "a language that doesn't affect the way you think about programming, is not worth knowing."

The goal of a thought shaper language is to change the way a programmer thinks about structuring his or her program. The basic building blocks provided by a programming language, as well as the ways in which they can (or cannot) be combined, will tend to lead programmers down a "path of least resistance", for some unit of resistance. For example, an imperative programming style is definitely the path of least resistance in C. It's possible to write functional C programs, but as C does not make it the path of least resistance, most C programs will not be functional.

Functional programming languages, by the way, are a good example of thought shaper languages. By taking away assignment from the programmer's basic toolbox, the language really forces programmers coming from an imperative language to change their coding habits. I'm not just thinking of purely functional languages like Haskell. Languages like ML and Clojure make functional programming the path of least resistance, yet they don't entirely abolish side-effects. Instead, by merely de-emphasizing them, a program written in these languages can be characterized as a sea of immutability with islands of mutability, as opposed to a sea of mutability with islands of immutability. This subtle shift often makes it vastly [easier to reason about](http://clojure.org/state) the program.

Erlang's concurrency model based on isolated processes communicating by messages is another example of a language design that leads to radically different program structure, when compared to mainstream multithreading models. Dijkstra's "GOTO considered harmful" and Hoare's Communicating Sequential Processes are pioneering examples of the use of language design to reshape our thoughts on programming. In a more recent effort, [Fortress](http://projectfortress.sun.com/Projects/Community) wants to steer us towards writing parallel(izable) programs by default.

Expanding the analogy with natural languages, languages as thought shapers are not about changing the vocabulary or the grammar, but primarily about changing the concepts that we talk about. Erlang inherits most of its syntax from Prolog, but Erlang's concepts (processes, messages) are vastly different from Prolog's (unification, facts and rules, backtracking). As a programing language researcher, I really am convinced that [language shapes thought](http://en.wikipedia.org/wiki/Linguistic_relativity).

### Language as a simplifier

Or how object-oriented programming in Smalltalk is qualitatively different from object-oriented programming in C++.

Sometimes the growing complexity of existing programming languages prompts language designers to design new languages that lie within the same programming paradigm, but with the explicit goal of minimising complexity and maximising consistency, regularity and uniformity (in short, [conceptual integrity](http://en.wikipedia.org/wiki/The_Mythical_Man-Month#Conceptual_integrity)).

Languages that I would classify as "simplifiers" include Scheme and Smalltalk (although Smalltalk is arguably just as much a thought shaper language). Self is a remarkable simplifier, as it was designed with the goal of simplifying Smalltalk, a language that was itself already designed with simplicity and uniformity in mind. In some sense, even Java can be thought of as a simplifier of C++, as observed by Mark S. Miller in his 2010 Emerging Languages Camp talk.

Other examples of this "less is more" school of thought are process algebras (Hoare's CSP is an early example) and formal calculi (such as Abadi and Cardelli's [object calculi](http://lucacardelli.name/TheoryOfObjects.html)). An explicit goal of these formal languages is to minimise the number of non-compositional features, minimising the number of 'exceptions' that need to be learned.

Continuing our analogy, using a language as a simplifier is like changing the grammar of a human language to be more consistent, to contain less exceptions. [Esperanto](http://en.wikipedia.org/wiki/Esperanto) is one example of an artificial human language that was designed with this goal in mind. Alas, like many simple and regular programming languages, it failed to get widespread adoption, but that's another essay.

### Language as law enforcer

To put it bluntly: no amount of library code is going to turn C into a memory-safe language. Just so, no amount of library code is going to turn Java into a thread-safe language.

Arguably one of the most important properties enforced by languages is memory safety through automated garbage collection. As noted by Dan Grossman in a [brilliant essay](http://www.cs.washington.edu/homes/djg/papers/analogy_oopsla07.pdf), thread safety via software transactional memory is another such property. One avoids whole-program "on your honor" memory allocation protocols, the other avoids whole-program "on your honor" locking protocols.

When I presented [AmbientTalk](http://ambienttalk.googlecode.com) at the Emerging Languages Camp last summer, I was asked the question "why design a new language for this?" "This" being event-based concurrent and distributed programming: AmbientTalk has a concurrency/distribution model based on communicating event loops (a form of message-passing concurrency, based on actors). My answer was a variation of the language-as-law-enforcer view described above: so that the language can enforce there be no low-level races and no deadlocks, and that all network communication is asynchronous to hide network latency and increase responsiveness, all by design. At a later point, I mentioned that AmbientTalk interoperates with Java: AmbientTalk objects can send messages to Java objects and vice versa. At that point, someone asked whether this didn't violate my dearly-held concurrency properties. I responded that, since AmbientTalk is a language, we can mediate between the AmbientTalk and the Java worlds, and will automatically wrap AmbientTalk objects in thread-safe proxies before passing them to Java objects, such that even in the case of interop between AmbientTalk and Java, Java's threads will not wreak havoc on AmbientTalk event loops. At that point, the audience had an "aha" moment. They understood the advantage of the language approach.

I chose the term "law enforcer" because I wanted to evoke a connotation with the laws of physics. We live in a universe that is governed by unbreakable laws of physics. This has disadvantages (we can't travel faster than the speed of light), but also advantages (we can predict the trajectory of a missile). In this regard, an interpreter is a tool for constructing a new universe, with its own inescapable "laws of physics" for the language it interprets. (I got this idea from [one](http://e-drexler.com/d/09/00/AgoricsPapers/agoricpapers/ce/ce4.html) of K. Eric Drexler and Mark S. Miller's [Agorics open systems papers](http://e-drexler.com/d/09/00/AgoricsPapers/agoricpapers.html)). This has disadvantages (I can't peek/poke memory in Scheme or Python), but also advantages (in Erlang, I can "predict" that a process is free of low-level data races, because it is by definition isolated from other concurrent processes)

The idea of viewing a language as a little universe with its own unbreakable laws is a very powerful one. As computer scientists, we are taught that all languages are "born equal", so to speak. Early on in our field's history, Alonzo Church and Alan Turing [have conjectured](http://en.wikipedia.org/wiki/Church-Turing_thesis) that all languages of a certain complexity can compute all computable mathematical functions. However, most of the time, we don't use programming languages to calculate pure mathematical functions, we use them to process information and interact with the physical world. And this is a key point: if a programming language has no primitive to print something to the screen, no program written in that language will ever be able to influence the user's screen. A program could build a representation of the user's screen in memory, and manipulate that representation, but it'll never be able to influence the "real" screen. It seems like a trivial example, but it illustrates the idea that a language really defines its own universe, and that a language designer has the power to control what can or cannot happen within that universe.

[Capability-secure](http://en.wikipedia.org/wiki/Capability-based_security) programming languages illustrate this idea nicely. The goal of these languages is to allow mutually suspicious programs to cooperate within possibly the same address space, by restricting the actions that these programs can perform. In these languages, the idea sketched in the previous paragraph is applied in practice. First, the ability to interact with the outside world is parcelled into many fine-grained capabilities, such as the ability to read a particular file, to listen on a particular socket connection or to interact with a particular application object. Programs are usually born with no or only a small set of such capabilities, and there are [laws](http://en.wikipedia.org/wiki/Object-capability_model) on how a program can acquire new ones. The security provided by these languages stems from the fact that a program can interact with its environment _only_ through the capabilities specifically granted to it.

A by-product of the language-as-law-enforcer view is that the enforced properties often make it easier to reason about programs written in the language, and as a result derive more interesting properties from it. Traditional type systems are law enforcers. What I find irksome about standard type systems is that they provide only very dull guarantees (especially when type casting is allowed). I would want a type system that can help me characterise whether my data is (transitively) immutable, whether it is accessed in a thread-safe way, whether a function is side-effect-free, deterministic or idempotent, whether a binary operator is commutative or associative, etc. I want a language that ensures that my case-analysis is complete, the way [Subtext](http://www.subtextual.org) does. There is a vast amount of interesting high-level, often non-local program properties that cannot be harnessed by today's (mainstream) languages. Many are fundamentally impossible to derive, but I'm sure there are still plenty of useful properties that can be better integrated into our programming languages.

Using a language as a law enforcer is perhaps a bit like creating taboos in human languages (["don't mention the war!"](http://www.youtube.com/watch?v=7xnNhzgcWTk)). By abolishing either words or concepts from a language, we make it difficult or impossible to speak about them. [Newspeak](http://en.wikipedia.org/wiki/Newspeak) (the fictitious language, not the [programming language](http://bracha.org/Site/Newspeak.html)) is one such example.

### Conclusion

Ever since the dawn of computer science, programming languages have flourished. Despite Church and Turing's insights that all programming languages are born equal, new programming languages keep on being invented. This essay has tried to provide some insight into why this is the case, by making explicit some of the goals behind the language design process. I distinguished between:

*   Languages as syntactic abstraction mechanisms: they reduce repetitive "boilerplate" code that cannot be abstracted from using another language's built-in abstraction mechanisms.
*   Languages as thought shapers: they induce a paradigm shift in how one should structure software (changing the "path of least resistance").
*   Languages as simplifiers: they boil down an existing paradigm to just its essential parts, often to increase understanding and insight.
*   Languages as law enforcers: they enforce important properties or invariants, possibly to make it easier to infer more useful properties from programs.

On a final note: while I'm not an operating systems expert, I'm sure that many (or all) of the above goals find resonance in operating systems. If we language designers would look towards the operating systems community, I'm sure we would discover there the equivalent of our programming language designs.

<small>Tom Van Cutsem. 23 Jan 2011\. Last modified 26 Jan 2011.</small>  
 [![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/80x15.png)](http://creativecommons.org/licenses/by-sa/3.0/)