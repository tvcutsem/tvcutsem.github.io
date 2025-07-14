---
title: "PARP: depermissioning Web3's serving layer"
layout: post
tags:
  - blockchain
comments: true
---

Over the last few months my PhD student [Weihong Wang](https://www.linkedin.com/in/weihongw/) and me have been studying issues with Web3's "serving layer" -- the infrastructure that makes data stored on a blockchain accessible to the application layer (aka decentralized apps or "dapps"). One of our key findings is that access to major "permissionless" blockchain networks today is, counter-intuitively, quite "permissioned": because of both technical and economical factors, access is mediated by centralized gatekeepers. In response, we have designed a new RPC (Remote Procedure Call) protocol to interact with permissionless blockchains that attempts to keep the access "depermissioned", yet without compromising on data integrity or accountability issues that plague the naive use of anonymous public RPC endpoints.

Our paper on this new RPC protocol recently got accepted at the IEEE International Conference on Distributed Computing Systems ([ICDCS 2025](https://icdcs2025.icdcs.org/)). Weihong will present the work in Glasgow next week. Here's a link to the [preprint copy](https://arxiv.org/abs/2506.03940) of the paper. Read on below for a high-level introduction to the work.

<!--more-->

## What does RPC have to do with Blockchain?

Blockchain networks can be thought of as highly reliable storage and processing infrastructure for tamper-resistant data. So-called "decentralized applications" (*dapps*) are apps that store (part of) their back-end state on the blockchain. The dapp itself may be a mobile or a web app, but in order for it to function properly, it must somehow fetch data (or send updates to data) to the chain. This is done using a straightforward RPC protocol (for instance, [Ethereum's JSON-RPC API](https://ethereum.org/en/developers/docs/apis/json-rpc/)).

<center>
  <img src="/assets/parp_figures/web3_rpc.png" alt="Web3 RPC" width="100%">
</center>

For instance, a dapp that wants to display the account balance of a user with Web3 wallet address `0xD2...` can make a simple JSON-RPC request to invoke the `eth_getbalance` method on a so-called "full node". In blockchain parlance a "full node" is a peer in the blockchain p2p network that holds a copy of the complete blockchain state. A full node may or may not actively help validate new transactions (i.e. be a "validator") -- for the purposes of serving state it does not really matter.

Note that the reason for the front-end/back-end split is that running a full node is expensive - in terms of memory or disk storage, network bandwidth and compute cost. As one data point, storing the state of the Ethereum blockchain as of July 2025 [requires about 1.34GB of storage](https://ycharts.com/indicators/ethereum_chain_full_sync_data_size) and the rate of growth is as high as 20% per year. As a result, it is unreasonable for the client app to sync all of this data itself, and so it must rely on a "serving layer" -- separate infrastructure (servers) willing to serve blockchain data to clients.

## What is the issue with today's serving layer?

Theoretically any full node synced-up with the blockchain can serve any clients. In practice, however, there are several issues to consider: how can clients discover full nodes? How do clients establish the trustworthiness of full node(s) they connect to? What is the economic *incentive* (i.e. financial reward) for full nodes to serve clients correctly, reliably and at scale? Who ultimately pays for the storage, bandwidth and compute costs to serve 1000s of clients?

The combination of these technical and economic factors has led to the emergence of so-called "node-as-a-service" (NaaS) providers or "node providers" for short. If you are working in Web3, you have likely heard of the largest node providers: Infura, Alchemy, Ankr, Quicknode, etc.

These are companies that offer established, Web2-friendly ways to connect to the blockchain, usually by exposing straigthforward REST APIs to clients. These APIs are metered and (in excess of "free tier" usage), can be billed much in the same way that most cloud services are billed today.

Node providers invest in quality cloud infrastructure, resulting in reliable (high uptimes), fast (low latency) service. Their business model makes it so that they have a repututation to uphold, so they are disincentivized to act maliciously against their own customers by e.g. sending invalid response data or censoring requests (even though technically speaking they can easily do so).

Today's picture of Web3's serving layer thus looks somewhat like this:

<center>
  <img src="/assets/parp_figures/web3_serving_layer.png" alt="Web3 serving layer" width="100%">
</center>

What is the problem with this picture?

Let's consider three desirable properties we want from a Web3 serving layer:

  * It should ideally be as *permissionless* as the blockchain network whose data it serves. For fully permissionless blockchains like Ethereum, clients should not need to seek permission from a central party to access the network.

  * Both RPC clients and servers should be *accountable* for their behavior. Servers should ideally serve clients honestly (serve the correct data, and serve it promptly -- which includes no censorship!) Conversely we also want clients to be well-behaved, using server resources sparingly.

  * Servers should be *incentivized* to serve dapp clients quickly and honestly. Financial incentives are, in fact, the key property that makes transaction validation work in fully permissionless networks like Ethereum (validators earn rewards via Proof-of-Stake). We note, however, that there is no equivalent to the Proof-of-Stake reward for serving data requests (as opposed to validating new transactions).
  
In an access layer intermediated by node providers, access to the blockchain is relatively accountable and incentivized, but definitely not permissionless. To get served by node providers one needs to sign up to receive an API key. This not only makes all traffic served via the API key identifable (i.e. not pseudonymous), it also makes all traffic from this source trivially linkable. As for accountability: while a node provider may censor or alter blockchain data, the risk of reputational damage seems to be an effective deterrent to misbehaviour. Since access is metered and pay-as-you-go, node providers are financially incentivized to serve clients reliably, and at scale.

Is there really no alternative to using a node provider if you are highly privacy-conscious? Well, yes, there do exist many anonymous public RPC endpoints that will relay your RPC requests without pre-registration (see [Chainlist](https://chainlist.org/chain/1) for a list of public endpoints for Ethereum). A dapp can connect without permission to one or more of these anonymous public endpoints to relay its RPC requests (access is *permissionless*). However, if one of these RPC endpoints misbehaves, there is very little clients can do to hold them accountable. Conversely, the lack of any client authentication or metering makes it hard for RPC endpoints to keep clients accountable, and leaves them with little financial incentives to relay requests (except perhaps for relaying state-updating transactions, which can be mined for [MEV](https://ethereum.org/en/developers/docs/mev/)).

We call this apparent dilemma between node providers and public RPC endpoints the "access dilemma" of Web3's serving layer:

<center>
  <img src="/assets/parp_figures/access_dilemma.png" alt="Web3 access dilemma" width="100%">
</center>

So how do we overcome this dilemma?

## PARP: a Permissionless, Accountable RPC Protocol

We introduce PARP, a **P**ermissionless **A**ccountable **R**PC **P**rotocol for Web3's serving layer. The key idea is to extend the standard JSON-RPC protocol employed by blockchains like Ethereum with additional features in order to make the request-response interaction permissionless, accountable and incentivized.

How do we do this? The basic idea is straightforward: we start from the setup of a public RPC endpoint (which is permissionless), but add two features:

  * We add a _fraud proof protocol_ to make the RPC endpoint *accountable* for its responses. Before a server can become a PARP server, it must first deposit tokens in an on-chain contract. These tokens are at risk if the server is ever caught misbehaving. The design is reminiscent of L2 optimistic rollups like Arbitrum.

  * We employ _payment channels_ to allow clients to include micro-payments in their RPC requests, offering financial *incentives* to servers for serving clients. Before a client can issue PARP requests, it must first deposit tokens in an on-chain contract. The design is reminiscent of L2 payment networks such as Lightning Network.

<center>
  <img src="/assets/parp_figures/parp_rpc.png" alt="PARP RPC example" width="100%">
</center>

The figure above lays out the basic idea: a pseudonymous client (identified by only their Web3 address) connects to a pseudonymous server (identified by only their IP address). The client issues RPC requests, but now includes small micro-payments (tokens). These tokens could be the network-native token (e.g. ETH in Ethereum), a stablecoin, or a utility token specific to a Web3 dapp or protocol. The server responds with both the RPC response as well as a validity proof. The client can verify the proof to ensure integrity of the data, and can hold the server accountable by posting an invalid proof to an on-chain arbitrage contract. This achieves our three goals: permissionless, accountable, incentivized:

<center>
  <img src="/assets/parp_figures/access_dilemma_solved.png" alt="The access dilemma solved" width="100%">
</center>

The details of how all of this works are explained [in the paper](https://arxiv.org/abs/2506.03940), but it's worth saying a few words about the accountability aspect.

To understand the full picture of PARP, one must look at both the on-chain and off-chain interactions (see Figure below). PARP leverages three modular on-chain smart contracts to 1. manage the clients' payment channels (*channels management module*), 2. to hold PARP server node deposits (*full nodes deposit module*), and 3. to arbitrage in the case of alleged fraud (*fraud detection module*).

<center>
  <img src="/assets/parp_figures/parp_rpc_details.png" alt="The PARP RPC protocol" width="100%">
</center>

When a PARP client connects to a PARP server, there is an initial handshake to set up the necessary protocol state, including opening a payment channel. After that, all standard RPC request/response interaction (including sending accompanying micro-payments) happens completely off-chain. When the PARP connection closes, the PARP server can close the payment channel to collect the payout.

To detect invalid responses (fraudulent servers), clients rely on so-called merkle proofs. These are cryptographic proofs that let the server prove with high probability that their response is valid with respect to the up-to-date blockchain. To verify the proofs, clients must gain access to a small amount of blockchain meta-data (mostly: recent block headers including merkle roots). For networks like Ethereum, this meta-data is served by a subset of validators called the [sync committee](https://eth2book.info/capella/part3/config/preset/#sync-committee) and its output is assumed to be cheaply and widely available (all verifiable, so-called "light client" designs build on this assumption. See e.g. [Helios](https://a16zcrypto.com/posts/article/building-helios-ethereum-light-client/) for a concrete example).

If a client receives an invalid proof from a server, it can cause the server to lose (some or all of) its staked funds by posting the invalid proof to the fraud detection smart contract. Of course, now we find ourselves in a somewhat circular situation: the client's only connection to the blockchain is via a server which it has detected to be fraudulent. Obviously, that server is not going to relay any client request to penalize the server to the blockchain. How then can the client relay its fraud proof? The simple solution is that the client needs to open up a new PARP connection to a third-party PARP node (labelled "Honest full node" in the Figure below) to relay the fraud proof on-chain:

<center>
  <img src="/assets/parp_figures/parp_fraud_detection.png" alt="Fraud detection in PARP" width="100%">
</center>

The on-chain fraud detection contract receives the information necessary to verify that the proof is indeed an invalid proof of an otherwise valid PARP request-response interaction (this is possible because a PARP response must be signed by the server, and must also contain a cryptographic hash of the corresponding client request).

If the fraud management contract establishes that the fraud proof is legitimate, it has the authority to ask the full node deposit contract to redistribute the rogue PARP server's deposit. To make the protocol incentive-compatible, we propose to redistribute a portion of the rogue PARP server's funds to both the victim client (as an incentive to do the work to actually verify and post the fraud proofs) and the third-party "honest" PARP server (as an incentive to relay fraud proofs from victim clients, helping the network identify and punish fraudulent PARP servers).

The end-to-end fraud proof protocol is quite complex (and has relatively high on-chain gas costs) and so one may question the feasibility or scalability of PARP. However, keep in mind that this entire protocol exists simply as a *deterrent* against misbehavior, and no rational PARP server will generate an invalid proof in its response, so the fraud protocol will likely never run! This is similar to why optimistic rollups like Arbitrum work so well in practice (L2 rollups rarely get contested because the rollup creator knows they can get caught and be punished, creating a strong incentive for honest behavior).

## Open source implementation and next steps

In addition to a detailed description of the PARP protocol, our paper also describes a prototype implementation of the protocol, which we have [open-sourced on Github](https://github.com/podiumdesu/parp-dev). We chose Ethereum and its Geth (Go-ethereum) full node implementation as a baseline and developed a fork of Geth that can act as a PARP full node (~1800 lines of Go). We also developed a PARP client that wraps around the standard Ethereum JSON-RPC API (~1500 lines of Go). Finally, we developed the three EVM-compatible smart contracts for the on-chain modules (~1600 lines of Solidity).

The paper contains initial measurements of the overhead of PARP in terms of RPC message size, response latency, increased CPU and memory usage of serving PARP requests, and finally the on-chain costs of interacting with the three on-chain contracts. The take-away is that the overheads appear reasonable, yet at the same time it is clear more engineering work is needed to bring the overhead down to a minimal, acceptable level.

In addition to the engineering work to minimize overhead and cost, there are some remaining open issues we intend to address in future work: PARP doesn't fully address client privacy (clients remain pseudonymous and client requests remain easily linkable) and reliability (a PARP RPC session is served by a single RPC server). In addition, we do not yet have strong guidelines to set the exact thresholds for all the crypto-economic incentives (rewards and penalties) used as part of both the micro-payments and the fraud proof protocol.

We invite you to [read the paper](https://arxiv.org/abs/2506.03940), [study the source code](https://github.com/podiumdesu/parp-dev) and to reach out to [Weihong](https://www.linkedin.com/in/weihongw/) or myself with any questions, comments or suggestions for improving the protocol. Ultimately, we hope that ideas like PARP will inspire others to further evolve and strengthen Web3's serving layer.