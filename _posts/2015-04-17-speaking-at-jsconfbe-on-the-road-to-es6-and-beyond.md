---
title: Speaking at jsconf.be on "The Road to ES6, and Beyond"
layout: post
tags: javascript ecmascript jsconf
excerpt_separator: <!--more-->
comments: true
---
Next week I will be speaking at [jsconf.be](http://jsconf.be) in lovely Bruges, Belgium. It's the second edition of the local Belgian JavaScript community gathering and it's promising to be quite an interesting program with talks on some of the usual suspects: React, Angular, Meteor, node and some less usual suspects, like the [Cody CMS](http://www.cody-cms.org/en/), a content-management system written 100% in JS. Perhaps unsurprisingly given recent events, I will be speaking about ECMAScript 6, which is nearing completion (at the time of writing, TC39 itself has signed off on the spec, but it is pending formal approval from ECMA). This is quite a historical moment. As Allen Wirfs-Brock, the editor of the ES6 spec put in the foreword of the new spec:

<!--more-->

> Focused development of the sixth edition started in 2009, as the fifth edition was being prepared for publication. However, this was preceded by significant experimentation and language enhancement design efforts dating to the publication of the third edition in 1999. In a very real sense, the completion of the sixth edition is the culmination of a fifteen year effort.

The title of my talk at jsconf.be is "The Road to ES6, and Beyond". It'll be about three things:

*   __Part I: JavaScript’s past, and the long road to ECMAScript 6__: I'll give some background on the history of JavaScript, what "ECMAScript" is all about, who TC39 is and what they do. I'll also recount the "harmony"-era decision that led first to a general cleanup of the language (ES5 strict mode) which then paved the way for growing the language, culminating in the ES6 effort.
*   __Part II: a brief tour of ECMAScript 6__: this is the part most probably of interest to JS devs. I'll give an overview of some of the more significant new language features in ES6\. It's difficult to be exhaustive here, so I've focused mainly on the many improvements to functions, the addition of classes and modules, and new control flow abstractions like iterators, generators and promises.
*   __Part III: using ECMAScript 6 today, and what lies beyond__: this part will be on the practical issue of writing ES6 code in a time where none of the major platforms have yet fully implemented the spec. I'll discuss some ES6-to-ES5 compilers like Traceur, BabelJS and TypeScript (yes, I'm aware the latter is not technically an ES6 compiler, but it's a relevant tool in this space). I'll end with an outlook on what's on the table for ES7 (or I should say, ECMAScript 2016), focusing on some of the more mature features.

I consider it a privilege to be given the chance to talk to the JS community about these exciting new features. The timing couldn't be better.

**Update:** [slides](http://soft.vub.ac.be/~tvcutsem/invokedynamic/presentations/es6_jsconf_2015.pdf) of my talk. If you're interested in me giving this talk at your company or event, do get in touch.