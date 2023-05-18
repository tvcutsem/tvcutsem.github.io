---
title: "Security & Privacy of Contemporary Distributed Systems"
layout: post
tags:
  - security
  - blockchain
  - teaching
permalink: spcdss
comments: true
---

This past semester I had the pleasure of running a seminar course in KU Leuven's brand new Advanced [Master of Cybersecurity](https://www.kuleuven.be/programmes/master-cybersecurity). The course is called "Security & Privacy of Contemporary Distributed Software Systems". That's a mouthful, but at least it's quite descriptive.

For this inaugural year I decided to focus the course on security & privacy aspects of blockchain and distributed ledger technology. As far as "contemporary distributed systems" go, it's hard to miss the [rapid expansion](https://a16zcrypto.com/posts/article/state-of-crypto-report-2023/) of this class of systems - the core technology underpinning "Web3".

<!--more-->

I kicked off the course with a three-part series of introductory lectures covering the basic principles of blockchain networks and consensus algorithms. This was followed by a guest lecture on Zero Knowledge Proofs.

After the lectures, it was time for the students to step up and contribute to the seminar. I gave them a list ([see below](#paper-reading-list)) of widely cited or otherwise impactful academic papers in the area of security & privacy and distributed systems. They each had to choose a paper to present to the group. Additionally every student had to read three additional papers assigned to other students and then challenge the presenter by submitting questions about the paper ahead of time. This allowed presenters to provide meaningful answers during and after their talks.

### The lectures

The three-part introductory lectures started with a discussion of "centralized" versus "decentralized" systems, for which I heavily borrowed from Ethereum co-founder Vitalik Buterin's [excellent blog on the subject](https://medium.com/@VitalikButerin/the-meaning-of-decentralization-a0c92b76a274). We reviewed basic cryptographic building blocks (public-key crypto, collision-resistant hash functions and merkle trees) and then dove into the design of Bitcoin as the first and still primary example of a blockchain system. We covered the role of the blockchain as an immutable append-only replicated ledger of payment transactions, Bitcoin's "UTXO" model of accounting and its Proof-of-Work consensus algorithm. We also covered widely acknowledged challenges with Bitcoin's approach: limited scalability at the base layer, privacy implications and the negative externalities of Proof-of-Work.

Part two focused on Ethereum and how it generalized blockchain systems from secure payment ledgers to [trustworthy computers](https://a16zcrypto.com/posts/article/computers-that-make-commitments/) that can record arbitrary information and enforce arbitrary rules through "smart contracts". We briefly dip our toes into Solidity, but only really scratch the surface. We briefly look under the hood at Ethereum's account model and gas fees and end with a brief description of Proof-of-Stake consensus.

Part three starts with a brief description of "permissioned" blockchain networks, highlighting two prominent systems: Hyperledger Fabric and Hyperledger Sawtooth. We compare and contrast these with "public" blockchain networks like Ethereum. After this interlude it is time for students to dive deeper into the most critical element of any blockchain system, namely its consensus algorithm. We review the academic origins of Byzantine failures, note the difference between crash fault-tolerant (e.g. RAFT and Paxos) and byzantine fault-tolerant algorithms. Finally, we dive deeper into Practical Byzantine Fault Tolerance (PBFT), a seminal BFT algorithm that is used as [the core consensus algorithm in Hyperledger Sawtooth](https://www.hyperledger.org/blog/2019/02/13/introduction-to-sawtooth-pbft) and that formed the basis for modern Proof-of-Stake consensus algorithms like Tendermint (the predecessor of [CometBFT](https://docs.cometbft.com/) - the consensus algorithm underlying blockchains in the Cosmos ecosystem).

We concluded the lecture series with a guest lecture by two speakers from industry: [Lode Hoste](https://www.bell-labs.com/about/researcher-profiles/lodehoste/) and [Janwillem Swalens](https://www.bell-labs.com/about/researcher-profiles/janwillemswalens/), both researchers at Nokia Bell Labs, came to talk to us about Zero Knowledge Proofs and their applications to trustworthy stream processing. Zero Knowledge Proofs are a mathematical technique that allows one party (the prover) to convince (with very high probability) another party (the verifier) that they correctly computed an agreed-upon function. The function may even compute on "secret" data that the prover is not willing to reveal, other than that the secret adheres to certain properties (for instance, one can prove possession of the pre-image `x` such that `H(x) == y` for some pre-agreed hash function `H` and publicly known hash `y`) without having to reveal `x`. Research on Zero Knowledge Proof systems is [exploding](https://nakamoto.com/cambrian-explosion-of-crypto-proofs/) along with the rise of blockchains, because it is [the key enabler for both the privacy and scalability problems of blockchain systems](https://vitalik.ca/general/2021/01/26/snarks.html).

### The seminars

After the lecture series we scheduled a three-week break during which the students had time to prepare their presentation on their selected paper. I grouped the papers by topic and then set up a series of paper seminars in the second half of the semester. During each seminar two students each presented a top academic paper on security & privacy or distributed computing topics related to blockchain systems.

The first seminar was focused on security vulnerabilities related to programming **smart contracts**. We reviewed an early ["systematization of knowledge" (SoK) paper](https://eprint.iacr.org/2016/1007.pdf) on the most widely known (and damaging) vulnerabilities in early smart contract programs on Ethereum, and then followed it up with [a CCS paper on Oyente](https://eprint.iacr.org/2016/633.pdf), a static analysis tool that is able to detect some of these vulnerabilities. The Oyente paper also suggests an alternative execution semantics for Ethereum to prevent transaction front-running.

The second seminar focused on **attacks on blockchain systems**, in particular those related to the financial incentives given to "miners" which are the critical parties that help keep a blockchain secure. We kicked off the seminar with the influential ["selfish mining" paper](https://dl.acm.org/doi/10.1145/3212998) that exposed a potential weakness in Bitcoin's Proof-of-Work algorithm, showing that there exists a strategy of mining blocks that is potentially more profitable than the default strategy used by Bitcoin mining clients at the time. We then shifted focus to incentive-related attacks on Ethereum, covering the more recent work on ["Flash Boys 2.0"](https://ieeexplore.ieee.org/document/9152675). This S&P2020 paper provides an in-depth study of all kinds of frontrunning attacks in Ethereum's "DeFi" (decentralized finance) ecosystem and was the first to call out the dangers of ["Maximal Extractable Value"](https://ethereum.org/en/developers/docs/mev/) (MEV).

In the third seminar we shifted focus to **privacy issues** of blockchains: in payment networks such as Bitcoin, all transactions are public and linked to prior transactions, making it easy to trace most or all financial transactions linked to a particular account. We reviewed two closely seminal papers that introduced anonymous payments secured by blockchain: [Zerocoin](https://sites.cs.ucsb.edu/~rich/class/cs293b-cloud/papers/zerocoin.pdf) (published at IEEE S&P 2013) and its direct successor [Zerocash](https://ieeexplore.ieee.org/document/6956581) (IEEE S&P 2014). Zerocoin used a clever combination of cryptographic commitments and zero knowlege proofs to break the link between "minting" and "spending" zerocoins. Unfortunately the protocol suffered from scalability and usability issues: the ZKP system used generated large proofs, too large to store on the blockchain, and the system supported only fixed denominations of coins and did not directly support transfering zerocoins to third-parties. All of these drawbacks were addressed in Zerocash, the cryptosystem that would ultimately form the basis for [Zcash](https://z.cash/) - a practical and widely used "privacycoin".

The fourth and final seminar focused on **blockchains as software platforms** that can support all kinds of new use cases including non-financial uses of distributed ledgers. We reviewed [Blockstack](https://www.usenix.org/system/files/conference/atc16/atc16_paper-ali.pdf), a decentralized naming and PKI infrastructure. This USENIX ATC 2016 paper is a great experience report about how the team first tried to build such an infrastructure on top of a fork of Bitcoin (called Namecoin), hit several security and scalability roadblocks and then decided to build a "virtual blockchain" on top of Bitcoin. Blockstack is the predecessor to the current [Stacks](https://www.stacks.co/) blockchain ecosystem (enabling smart contracts secured by Bitcoin), and its approach to building a decentralized PKI infrastructure is the basis for the current [Bitcoin Name System](https://docs.stacks.co/docs/stacks-academy/bns). We concluded the seminar with the SRDS paper on [Tendermint](https://www.inf.usi.ch/pedone/Paper/2021/srds2021a.pdf), the consensus algorithm originally developed for the [Cosmos "internet of blockchains"](https://cosmos.network/). Tendermint, along with Ethereum's Casper, was [one of the first](https://blog.cosmos.network/consensus-compare-casper-vs-tendermint-6df154ad56ae) Proof-of-Stake consensus algorithms for blockchain. It solved the "nothing at stake" problem present in early PoS algorithms by introducing the notion of "slashing" a validator's stake if they are caught cheating (e.g. attesting to two different blocks at the same block height). Tendermint is also notable for its ["ABCI"](https://docs.tendermint.com/v0.33/introduction/what-is-tendermint.html#intro-to-abci) (Application Blockchain Interface), which provides a clean separation between the consensus engine (which only deals with ordering transactions) and the application-specific transaction processing logic (which can be coded up in any programming language and communicates with the consensus engine using RPC).

### Reflections

One benefit of teaching in an Advanced Master programme at university is that students tend to be very self-motivated. As a result the students generally did a good job in presenting their papers and in challenging others with relevant questions. While some papers were more challenging to cover than others, all of the papers are well-written and offer a unique perspective on blockchain technology, nicely complementing the basics covered during the initial lectures.

I want to end with acknowledging my co-lecturers Dr. [Davy Preuveneers](https://distrinet.cs.kuleuven.be/people/DavyPreuveneers) and Prof. [Wouter Joosen](https://distrinet.cs.kuleuven.be/people/WouterJoosen) who provided me with ample guidance on how to run such a seminar course successfully, and Davy in particular for feedback on the lectures, seminars and evaluation.

If you want to know more about KU Leuven's Master of Cybersecurity programme, I encourage you to check out the [full course programme](https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_56224748.htm#bl=all).

### Paper reading list

For reference, here's the full list of papers that we covered during the seminars:

  * [Smart Contracts SoK](https://eprint.iacr.org/2016/1007.pdf): A survey of attacks on ethereum smart contracts (POST 2017)
  * [Oyente](https://eprint.iacr.org/2016/633.pdf): Making Smart Contracts Smarter (CCS 2016)
  * [Selfish Mining](https://dl.acm.org/doi/10.1145/3212998): Majority is not enough: Bitcoin mining is vulnerable (FC 2014 / CACM 2018)
  * [Flash boys 2.0](https://ieeexplore.ieee.org/document/9152675): Frontrunning in decentralized exchanges, miner extractable value, and consensus instability (IEEE S&P 2020)
  * [Zerocoin](https://sites.cs.ucsb.edu/~rich/class/cs293b-cloud/papers/zerocoin.pdf): Anonymous distributed e-cash from bitcoin (IEEE S&P 2013)
  * [Zerocash](https://ieeexplore.ieee.org/document/6956581): Decentralized anonymous payments from bitcoin (IEEE S&P 2014)
  * [Blockstack](https://www.usenix.org/system/files/conference/atc16/atc16_paper-ali.pdf): A global naming and storage system secured by blockchains (USENIX ATC 2016)
  * [Tendermint](https://www.inf.usi.ch/pedone/Paper/2021/srds2021a.pdf): The design, architecture and performance of the Tendermint Blockchain Network (SRDS 2021)

If know of recent papers that you think would also be a good fit feel free to leave a suggestion in the comments!
