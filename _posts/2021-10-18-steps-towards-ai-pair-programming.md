---
title: "Steps towards AI Pair Programming"
layout: post
tags:
  - machine learning
  - NLP
  - devtools
  - AI
  - Python
permalink: nlgp
comments: true
---

In the last few years, with my colleagues at Nokia Bell Labs, I've been looking into how machine learning can help improve software development, helping developers write code better and faster by leveraging the large amounts of open source code that are now available online. We've covered various use cases including [recommendation engines](https://www.code-compass.com/blog/intro/) for open source software packages and [code search engines](https://arxiv.org/abs/2008.12193) to better find runnable usage examples based on programmer intent.

One particular area that I've found quite compelling has been the area of translating natural language into code. This idea fits in a wider body of work known in academic circles as "program synthesis", and in the software development world as "AI pair programming".

<!--more-->

### The Vision: Natural language-guided Programming

My co-authors and I recently published a paper titled ["natural language-guided programming"](https://dl.acm.org/doi/abs/10.1145/3486607.3486749) at the [Onward!](https://2021.splashcon.org/track/splash-2021-Onward-papers#program) symposium. The paper (author copy [here](https://arxiv.org/abs/2108.05198)) paints a vision of a not-so-distant future in which developers will be able to interact with AI assistants through natural language to more quickly and effectively "get things done" without wasting time manually searching, copy-pasting and adapting code examples that they find online.

Natural language-guided programming (NLGP) is all about helping developers find and use library APIs faster. If you're familiar with [GitHub CoPilot](https://copilot.github.com/), you get the gist of it. (note: CoPilot was not yet publicly released when our paper was originally written and submitted.)

In the paper we report on an NLGP assistant for Python targeted specifically at helping data scientists and machine learning engineers make effective use of the [Python data stack](https://hub.packtpub.com/python-data-stack/), a complete toolbox of open source libraries for data science with a large API surface. The specific task we focused on is, given a piece of Python code acting as "context" and a short natural language "intent", to try and autocomplete the code based on the intent in a way that it naturally fits the preceding context. Think of it as a form of semantic code completion. For example, a programmer might write:

```python
import matplotlib.pyplot as plt

values = [1, 2, 3, 4]
labels = ["a", "b", "c", "d"]

# plot a bar chart
```

The last comment line is interpreted by our NLGP assistant as the user intent. Based on this context and intent, our tool might predict code such as:

```python
plt.bar(labels, values)
plt.show()
```

The paper goes into more detail on how to gather effective training data to train ML models to learn how to map natural language requests into API calls. We sourced a large body of Python code from online [Jupyter notebooks](https://jupyter.org/), the environment of choice for doing data science in Python). We observe that training on comment lines that appear naturally in code enables models to pick up on the relationship between intent and API calls. More interestingly, we also observe that models can learn this relationship from synthetically generated training data, such as code with docstrings injected as additional comment lines at the API call site. This paves the way to create NLGP assistants for areas of software development where code comments are more scarce.

Progress in NLGP or AI Pair Programming in general is hard to measure due to the lack of good standard benchmarks. To evaluate our tool, we created a dedicated benchmark for the Python data science domain consisting of 201 curated code snippets that collectively use a mix of various open source Python libraries. To support reproducibility of our work and to enable others to build on it, we've released the full benchmark data [on Zenodo](https://zenodo.org/record/5384768#.YVr3jkZBz0r) and we've released our pretrained code prediction models on [HuggingFace](https://huggingface.co/Nokia/nlgp-natural).

### The State of the Art: OpenAI Codex

Since the release of our paper, [GitHub CoPilot](https://copilot.github.com/) has taken the software development community by surprise. GitHub brought us closer to our vision of natural language-guided programming much faster than even we ourselves had anticipated. We're not quite there yet (see below), but CoPilot is unquestionably a massive leap forward in bringing this technology within reach of the programming community.

CoPilot is powered by an AI model called [Codex](https://openai.com/blog/openai-codex/), developed by OpenAI, a company that previously [garnered widespread attention](https://www.nytimes.com/2020/11/24/science/artificial-intelligence-ai-gpt3.html) with its GPT-3 AI models that can auto-generate text that is nearly indistinguishable from human-written text. Microsoft (which owns GitHub) has formed a [close partnership](https://blogs.microsoft.com/blog/2020/09/22/microsoft-teams-up-with-openai-to-exclusively-license-gpt-3-language-model/) with OpenAI, including [investing in new compute infrastructure](https://blogs.microsoft.com/ai/openai-azure-supercomputer/) to power OpenAI's exceedingly large and costly AI models.

While Codex is an impressive tour-de-force in terms of scaling up ultra-large language models trained on ultra-large code repositories and in terms of the breadth of programming languages and open source libraries that it can deal with, we are still far removed from the vision of having a trusted "AI pair programmer" with which we can engage in a true conversation about our code. If you want to get a sense of what a state of the art Codex model can do in October 2021, read my coworker Bart Theeten's post on his hands-on [experiments with Codex](https://www.code-compass.com/blog/codex/). Bart walks us through his experiences in using Codex to build the classic arcade game of Pong purely using natural language input. It's a fun read and I won't spoil the conclusions here, other than mention that it's a rollercoaster ride containing moments of both awe and disappointment.

All signs are pointing in the direction that AI Pair Programming as a technology has finally entered its period of ["awkward adolescence"](https://www.nytimes.com/2016/01/07/technology/on-display-at-ces-tech-ideas-in-their-awkward-adolescence.html?_r=0).