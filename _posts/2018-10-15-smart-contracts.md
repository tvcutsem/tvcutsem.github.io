---
title: Programming Secure Smart Contracts
layout: post
tags:
  - javascript
  - SES
  - Dr. SES
  - smart contracts
  - blockchain
permalink: smartcontracts
comments: true
---
Five years ago, I [wrote on this blog about a distributed computing platform called Dr. SES]({% post_url 2013-01-21-distributed-resilient-secure-ecmacript %}) (distributed resilient secure ECMAScript). The goal of Dr. SES was
to build a secure distributed computing platform harnessing the power of
[object-capabilities](https://en.wikipedia.org/wiki/Object-capability_model) to build [smart contracts](https://en.wikipedia.org/wiki/Smart_contract). 

The visionary behind this project is Mark S. Miller. Back in 2013 I helped Mark put his ideas [on paper](https://ai.google/research/pubs/pub40673).

Five years later, the rise of Bitcoin and in its wake other cryptocurrencies and blockchain technology, has all of a sudden turned smart contracts from an idealistic vision into a tangible economic reality. Blockchain platforms such as Ethereum now boast turing-complete programming languages to implement smart contracts such as the one explored in our paper. Unfortunately, the world has [already learned the hard way](https://medium.com/swlh/the-story-of-the-dao-its-history-and-consequences-71e6a8a551ee) that today's languages to implement smart contracts are extremely fragile.

Mark has recently decided to devote his full attention to realizing the vision laid out in our paper. He is now chief scientist at a startup called [Agoric](https://agoric.com/) that aims to build a new
distributed computing fabric to express safer, more expressive and more accessible smart contracts,
all using JavaScript as the foundational language. Many of the key abstractions introduced in the 2013 Dr. SES paper can still be found in the new smart contracts platform that Agoric is putting together.

If you are interested in latest developments on this work, I strongly
recommend watching Mark's [Programming Secure Smart Contracts](https://www.youtube.com/watch?v=Em7tHO6fXPQ) talk which he gave at SF Crypto Developers conference in October 2018. The one-hour talk offers a precise, detailed description of the entire distributed computing fabric, explaining the different layers of abstraction that allow us to build flexible electronic rights out of raw bits and bytes:

<center>
  <img src="/assets/SES_layers.png" alt="Distributed Computing layers of abstraction" width="80%">
</center>