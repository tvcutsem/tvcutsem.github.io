---
title: Code Compass
layout: post
tags:
  - machine learning
  - javascript
  - npm
  - jsconf
permalink: codecompass
comments: true
---

I'm happy to share some of the work that I have been involved in at Bell Labs
over the course of last year: our [import2vec](https://arxiv.org/abs/1904.03990) model for training good machine
representations of software libraries (enabling computers to establish a mathematical degree of similarity between software libraries), and a practical tool built on top of these representations called [Code Compass](https://bell-labs.com/code-compass).

<!--more-->

Code Compass is a contextual search engine that lets you browse software packages written in different programming languages through similarity.
It's [not a standard search engine](https://www.code-compass.com/blog/intro). You do not type keywords
into a search bar. Instead, you type in names of libraries you are familiar with (or that you are actively using as part of your project), and Code Compass will list related libraries. Today the tools works for Java, JavaScript
and Python.

Recently we spoke at [jsconf.be](https://jsconf.be), the Belgian JavaScript developer conference on how Code Compass can be used to more effectively browse the Node Package Manager (NPM) registry.
You can find the slides of the talk [here]({{site.baseurl}}/assets/codecompass_jsconf2019.pdf).

For a JavaScript developer audience Code Compass is particularly relevant
as the NPM registry has grown to become the largest software repository in the world, containing [over 800.000 packages](https://www.modulecounts.com). With so many packages to choose from, and hundreds of new packages published every single day, how do you effectively find those packages most relevant to your project? Code Compass aims to help developers discover less-popular but highly relevant software packages that would be hard to find otherwise. Please give it a try!