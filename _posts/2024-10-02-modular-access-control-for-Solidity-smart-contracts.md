---
title: "Remember AOP? Modular access control for Solidity smart contracts"
layout: post
tags:
  - security
  - blockchain
  - smart contracts
comments: true
---

If you have ever looked at how Ethereum smart contracts are developed in the Solidity programming language, you will know that one of the most critical aspects of the
code are the so-called "access control checks": short conditional tests that check whether the call to the contract is "legit": was it made by a party with sufficient rights?
(e.g. the owner or creator of the contract) Is the contract in the right state to handle the request? Were all the necessary actions executed earlier? And so on.

In our recent paper ["Safe design and evolution of smart contracts using dynamic condition response graphs to model generic role-based behaviors"](https://onlinelibrary.wiley.com/doi/10.1002/smr.2730) (which got published last week
in the Journal of "Software: Evolution and Process"), we develop a method to express such access control logic not as conditional tests scattered throughout the contract code,
but rather as a separately specified set of constraints.

<!--more-->

Our method is based on so-called Dynamic Condition Response Graphs (DCR Graphs for short).
A DCR Graph is a declarative notation for describing a process. Using a DCR Graph one can very concisely model the permitted ordering of operations by
describing only the constraints between the operations (as opposed to imperatively specifying the sequence of 'legal' orderings, as is commonly done in
other process languages such as BPMN).

For instance, in a DAO contract managing a pool of shared funds, we can indicate that an account can only withdraw funds if the contract was first initialized,
the operator address was first properly configured, and the account has obtained the appropriate "User" role.

We created an extension of the Solidity programming language that allows the contract author to declare all such access control constraints at the top of their source file.
Our "DCR-Solidity" compiler then takes such an extended Solidity file and generates a regular Solidity source file where the constraints are compiled into
imperative checks in-lined in the relevant methods of the contract.

If you are old enough to remember what "Aspect-oriented Programming" or AOP was, then this will sound familiar. Essentially, the access control logic
is an "aspect" that we have separated out from the regular business logic of the contract, and our "DCR-Solidity" compiler is an "aspect-weaver" that
integrates the aspect back into the code. (AOP was briefly popular as a programming paradigm in the early '00s but never really hit the mainstream -
nevertheless the ideas behind AOP are useful to improve modularity of software).

All of the above 
is primarily the work of Yibin Xu, a PhD student at the University of Copenhagen in Denmark working under the supervision of Profs. Tijs Slaats, Boris Düdder
and Thomas Troels Hildebrandt.
Yibin did some of the work as part of a 6-month research visit in my group at DistriNet KU Leuven in 2023. Thomas and Tijs have been deeply involved in the creation
and further development of DCR Graphs, and have applied
them successfully to various other domains, most notably [the simplification of complex administrative business processes](https://documentation.dcr.design/).

Our paper is available in open access through the Journal's [website](https://onlinelibrary.wiley.com/doi/10.1002/smr.2730).
