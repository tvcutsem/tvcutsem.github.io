---
title: Programming languages for programmable money
layout: post
tags:
  - smart contracts
  - blockchain
permalink: programmablemoney
comments: true
---
In this post I introduce the notion of programmable money and smart contracts, why they go hand-in-hand with blockchains, how smart contracts are programmed today and how they might be programmed in the future.

<!--more-->

### Programmable money

Imagine if moving money around the world were as convenient and as cheap as sending a text message to a friend living abroad. Imagine if transferring ownership of something as important as a house could be done entirely online with the same level of trust and guarantees as those provided by a notary, at a fraction of the cost. These things and many more are made possible by a combination of emerging technologies including cryptographic currencies, decentralised peer-to-peer networks and new consensus protocols based on distributed ledgers ("blockchains"). Together they form the basis for a new digital financial system sometimes called “decentralized finance” ("DeFi"). In the words of MIT’s [Digital Currency Initiative](https://dci.mit.edu/), the promise of these technologies is to "empower individuals by making it as fast and easy to move value across the world as it is to move information".

For the first time in human history, these technologies have enabled money to become “programmable” in the same way that we can today talk about programmable appliances (Internet of Things) or programmable networks (Software Defined Networking). This “programmable money” is programmed by means of so-called ["smart contracts"](https://web.archive.org/web/20011102030833/http://szabo.best.vwh.net:80/smart.contracts.html), software programs that automatically move digital assets according to arbitrary pre-specified rules[^Buterin14]. Smart contracts are used in industry to implement tokenised (cryptographic) money ([Tether](https://tether.to/), [DAI](https://makerdao.com/en/) and [many others](https://etherscan.io/tokens)), escrow services ([EscrowMyEther](http://escrowmyether.com/)), lending platforms ([Aave](https://aave.com/), [Maker](https://makerdao.com/en/), [Compound](https://compound.finance/)), decentralised autonomous organisations ([DAOs](https://en.wikipedia.org/wiki/Decentralized_autonomous_organization)), atomic swaps ([Uniswap](https://uniswap.org/)), auctions ([TokenSwap](https://tokenswap.finance/)), prediction markets ([Augur](https://augur.net/)), fundraisers ([WeiFund](http://weifund.io/)), and so forth.

### The role of Blockchain

As mentioned, smart contracts are software programs that automatically move digital assets according to arbitrary pre-specified rules. But what sets these programs apart from traditional programs running on the mainframe computers of banks and insurance companies? The answer lies in the trust model. If Alice and Bob want to exchange digital assets according to a program (a sequence of instructions) that they both agree to, there is still the question of who will execute those instructions? If Alice executes the program on her computer, Bob must trust Alice to faithfully run the exact sequence of instructions that they both agreed to. Alice and Bob do not necessarily trust each other, so this setup is not a workable solution (and of course, neither is the symmetrical setup where Bob would execute the code on his computer).

Up until just a decade ago, the only practical solution to this problem was to let the program be executed by a common, trusted third-party (e.g. a bank or payments processor that Alice and Bob both trust). Then in 2009 a pseudonymous programmer named Satoshi Nakamoto invented the idea of using a replicated ledger (now commonly known as a “blockchain”) distributed across many computers interconnected by a peer-to-peer network and used it to implement a decentralised digital payments system called Bitcoin[^Nakamoto09]. In 2013, a 19-year old prodigy named Vitalik Buterin realised that one could take this idea of a distributed ledger and use it to build not just a decentralised payments network, but a fully Turing-complete “decentralised computer”[^Buterin14]. The resulting system is called [Ethereum](https://ethereum.org/en/) and it essentially turns a network of individually untrustworthy computers into a single global virtual trustworthy computer.

How does Ethereum now solve Alice and Bob’s problem? Rather than Alice or Bob having to place their trust in a single trusted third party as before, they can now place their trust in a collective network of computers that pledge to faithfully execute the program that they both agreed to. As long as the majority of computers does not misbehave, the program will execute as intended. Whether it is better to trust a single party like a bank or a decentralised network like Ethereum depends on a lot of factors, and the key point here is not that one setup is necessarily better or worse than the other. The key point is that the rise of decentralised computers has given individuals like Alice and Bob, as well as companies and institutions around the world new options to transact with one another without having to rely on centralised trusted third parties, if they would want to do so.

While Ethereum has not yet reached mainstream economic adoption, in the last 5 years the platform has experienced significant growth in both usage (parties using it to transact) as well as in its infrastructure (parties contributing resources to scale and secure the platform). Ethereum is currently [the largest programmable decentralised computer in the world](https://cointelegraph.com/news/ethereum-flippens-stablecoins-to-become-the-most-used-blockchain) with the total value of funds "locked" into its smart contracts [estimated at over $11 Billion](https://defipulse.com/) at the time of writing this post.

### Programming smart contracts

A "decentralised computer" is essentially a replicated state machine, a concept first described by [Leslie Lamport](http://www.lamport.org/) in one of the most influential papers on distributed systems[^Lamport78]. Likewise, an individual smart contract at its core is a state machine. An illustrative example of the typical state machine logic coded up within a smart contract is that of a vending machine. A vending machine encapsulates the simple protocol that one must first insert coins into the machine (locking up assets into the contract), after which one can select a good, after which the vending machine dispenses the good and returns any change (releasing assets from the contract)[^Szabo97].

Programming directly at the abstraction level of state machines is generally considered to be cumbersome and low-level. Thus high-level programming languages were created in which to express the contract logic. On the Ethereum platform for example, contracts are typically written in high-level programming languages and then compiled into bytecode for the Ethereum Virtual Machine (EVM). The most widely used such high-level language is called [Solidity](https://github.com/ethereum/solidity). Solidity uses a Java-like syntax to describe the states and state transitions of a smart contract.

A common use case of smart contracts in Ethereum is to create new kinds of cryptographic money, also called "tokens". In recent years, standard contract interfaces have emerged that enable tokens defined by different contracts to become interoperable and interchangeable, such as [the ERC20 standard](https://eips.ethereum.org/EIPS/eip-20) These standards define operations on smart contracts that quite resemble object-oriented interfaces.

### Risks in programming smart contracts

As with any code, smart contracts may contain bugs (unintended side-effects). However, bugs in smart contracts code may have consequences far greater than bugs in typical object-oriented application code. In 2016, hackers were able to exploit [a simple programming bug](https://medium.com/@MyPaoG/explaining-the-dao-exploit-for-beginners-in-solidity-80ee84f0d470) in a smart contract program called [The DAO](https://en.wikipedia.org/wiki/The_DAO_(organization)) and [steal digital assets valued at around $50M](https://www.wired.com/2016/06/50-million-hack-just-showed-dao-human/) at the time of the attack. The DAO was a decentralised autonomous organization, an investment vehicle that raised money via [one of the largest crowdfunding campaigns in history](https://www.ft.com/content/600e137a-1ba6-11e6-b286-cddde55ca122). The DAO attack laid bare the enormous risks and responsibilities that go with programming smart contracts.

Bugs in smart contracts are particularly pernicious because such contracts embody the principle of "code as law": participants agree to abide by the code in the contract to act as the final arbiter. This makes cooperation more predictable, reducing counterparty risk. However, when disputes do arise (perhaps due to a "bug" in the code, or a condition that was not fully specified), there is no legal system to seek recourse. Transactions cannot be rolled back, making mistakes irrecoverable and final. Thus, despite the fact that smart contracts programming is like high-level application programming, it also shares strong similarities with hardware and embedded programming, where a flaw in microcode or firmware may have large repercussions once the hardware is deployed in the field. As a result, there are many [security best practices](https://consensys.github.io/smart-contract-best-practices/) that smart contract developers must now painstakingly follow.

### New directions in programming smart contracts

In order for smart contracts and decentralized finance to receive mainstream adoption, we need to make "programmable money" significantly easier and safer to program. As the DeFi economy matures and more smart contracts are developed, more flaws will inevitably come to light and the industry will see the need to move toward safer smart contracts languages and platforms.

Seven years ago, before the invention of Ethereum when smart contracts did not yet receive any kind of significant adoption, with [Mark S. Miller](https://en.wikipedia.org/wiki/Mark_S._Miller) we explored the possibility of writing smart contracting logic in a widely used, general-purpose programming language called JavaScript[^Miller13] (on which [I've written before]({% post_url 2013-01-21-distributed-resilient-secure-ecmascript %}) on this blog). That work was itself based on seminal work by Mark on exploring the use of object-capabilities to implement digital financial instruments[^Miller00].

The choice for JavaScript offers many advantages: a large user base, familiarity, flexibility, mature tooling and ease-of-use. However, its obscure semantics make it difficult to reason about code correctness, which, as we've seen, is paramount in smart contracts programming. To mitigate this, smart contract logic can be written in a secure subset of JavaScript such as [Secure ECMAScript](https://medium.com/agoric/ses-securing-javascript-in-the-real-world-4f309e6b66a6) or [Jessie](https://github.com/Agoric/Jessie). Mark's company [Agoric](https://agoric.com) is turning this approach into a viable industry-strength solution, through their development of a smart contracts framework called [Zoe](https://agoric.com/documentation/zoe/guide/).

Another promising direction towards safer smart contract programming lies in a new generation of dedicated smart contract programming languages that embrace novel type systems to statically verify desirable characteristics of smart contracts code, such as the Move programming language[^BlackShear19] built as part of Facebook’s [Libra](https://libra.org/en-us/whitepaper) digital currency initiative. Move introduces resource types built on linear logic[^Girard87] to provide better control to developers over resources such as digital tokens that should not be accidentally or maliciously copied or deleted in program code.

### Looking ahead

Whether the next generation of smart contracts will be written in a secure subset of a pre-existing language, or in an entirely fresh, dedicated programming language is hard to say. It is in fact humbling to consider how incredibly nascent the field of smart contracts programming really is. The Ethereum platform launched only in July 2015, and the majority of smart contracts written by companies are but a few years old. Similar to how Web programming has evolved significantly in the last 30 years (from hand-written HTML pages and PHP scripts and an imperative programming mindset in the early ‘90s to sophisticated JavaScript Web frameworks and a functional programming mindset today), we have strong reasons to believe that the way smart contracts are programmed is poised to radically change in the years to come.

## References

[^BlackShear19]: S. Blackshear, E. Cheng, D. L. Dill, V. Gao, B. Maurer, T. Nowacki, A. Pott, S. Qadeer, D. Russi, S. Sezer, T. Zakian and R. Zhou. [Move: A Language With Programmable Resources.](https://developers.libra.org/docs/move-paper) (2019).

[^Buterin14]: V. Buterin, [A next generation smart contract and decentralised application platform](https://ethereum.org/en/whitepaper/), White Paper, 2014.

[^Girard87]: J. Girard. "Linear logic". Journal of Theoretical Computer Science. vol 50, no. 1, pp. 1-101, 1987.

[^Lamport78]: L. Lamport. [Time, clocks, and the ordering of events in a distributed system](https://doi.org/10.1145/359545.359563). Communications of the ACM 21, 7 (July 1978), pp. 558–565.

[^Miller00]: M. S. Miller, C. Morningstar, B. Frantz. [Capability-based Financial Instruments](http://www.erights.org/elib/capability/ode/index.html). Financial Cryptography, Springer-Verlag, 2000.

[^Miller13]: M.S. Miller, T. Van Cutsem, B. Tulloh. [Distributed Electronic Rights in JavaScript](https://doi.org/10.1007/978-3-642-37036-6_1). European Symposium on Programming (ESOP) 2013. LNCS vol 7792. Springer.

[^Nakamoto09]: S. Nakamoto. [Bitcoin: A Peer-to-Peer Electronic Cash System](https://bitcoin.org/bitcoin.pdf), White Paper, 2009.

[^Szabo97]: N. Szabo, [Formalizing and Securing Relationships on Public Networks](https://doi.org/10.5210/fm.v2i9.548), First Monday, 1997.