---
title: Talks
layout: page
permalink: /talks/
---

## Talks

I regularly speak at developer conferences, academic conferences, meetups and universities. Below is a list of my keynotes, conference talks, seminars and lectures, with link to slides (and recordings where available).

<table class="table table-hover">

<colgroup>
<col width="8%" />
<col width="8%" />
<col width="60%" />
<col width="15%" />
<col width="9%" />
</colgroup>

<thead>
<tr class="header">
<th>Date</th>
<th>Type</th>
<th>Title</th>
<th>Venue</th>
<th>Place</th>
</tr>
</thead>
<tbody>
{% for year in site.data.talks %}
<tr class="info">
  <td markdown="span">**{{year.year}}**</td>
  <td markdown="span"></td>
  <td markdown="span"></td>
  <td markdown="span"></td>
  <td markdown="span"></td>
</tr>
{% for talk in year.talks %}
  <tr>
    <td markdown="span">{{talk.date}}</td>
    <td markdown="span">{{talk.type}}</td>
    <td markdown="span">{{talk.title}}<br>
    {% if talk.slides_path %}<a class="btn btn-info btn-xs" target="_blank" href="{{site.asseturl}}/{{talk.slides_path}}">slides</a>
    {% endif %}
    {% if talk.video_url %}<a class="btn btn-warning btn-xs" target="_blank" href="{{ talk.video_url }}">video recording</a>
    {% endif %}
    {%- for tag in talk.tags -%}<span class="btn btn-default btn-xs disabled">{{tag}}</span> {% endfor %}
    </td>
    <td markdown="span">{{talk.venue}}</td>
    <td markdown="span">{{talk.place}}<br><span title="{{talk.country}}" class="flag-icon flag-icon-{{talk.country | downcase}} flag-icon-squared"></span></td>
  </tr>
{% endfor %}
{% endfor %}
</tbody>
</table>

## 2011

*   [Adventures in Clojure, Navigating the STM sea and exploring Worlds]({{site.asseturl}}/adventures-in-clojure.pdf), research talk at Software Languages Lab, Brussels, October 2011
*   [Communicating Event Loops]({{site.asseturl}}/WGLD_CommEventLoops.pdf), presentation given at the first [Working Group on Language Design](http://program-transformation.org/WGLD/) meeting (joint work with Mark S. Miller), Mountain View, USA, June 2011
*   [MapReduce in Erlang]({{site.asseturl}}/ErlangMapReduce.pdf), presentation given at the 7th Ghent Functional Programming Group meeting, April 26, 2011, Ghent, Belgium
*   [Software Transactional Memory in Clojure]({{site.asseturl}}/STM-in-Clojure.pdf) (also available on [SlideShare](http://www.slideshare.net/tvcutsem/stm-inclojure)) and accompanying [source code](https://github.com/tvcutsem/stm-in-clojure).

## 2010

*   [Proxies: design principles for robust object-oriented intercession APIs]({{site.asseturl}}/dls2010proxies.pdf) - presentation at the [Dynamic Languages Symposium](http://www.dynamic-languages-symposium.org/dls-10), SPLASH 2010, October 18th, Reno, Nevada, USA
*   [A language-oriented approach to teaching concurrency]({{site.asseturl}}/ccp2010.pdf) - presentation at the [Workshop on Curricula on Concurrency and Parallelism](http://www.cs.pomona.edu/~kim/CCP2010.html), SPLASH 2010, October 17th 2010, Reno, Nevada, USA
*   [Interview with Microsoft Channel 9](http://channel9.msdn.com/posts/Charles/Scenes-from-Emerging-Languages-Camp-2010-Standing-Roundtable-Discussion/) after the [Emerging Languages Camp](http://emerginglangs.com/) at the O'Reilly Open Source Conference (OSCON), July 2010, Portland, Oregon, USA
*   [Invited Talk]({{site.asseturl}}/AmbientTalk.pdf) on [AmbientTalk](http://www.oscon.com/oscon2010/public/schedule/detail/15488) at the [Emerging Languages Camp](http://emerginglangs.com/), co-located with O'Reilly Open Source Conference (OSCON), July 2010, Portland, Oregon, USA
*   [Changes to ECMAScript Part 2, Harmony Highlights: Proxies and Traits]({{site.asseturl}}/harmony_highlights_techtalk.pdf) - a Google tech talk about the work I did as visiting faculty at Google in Mountain View, USA, April 2010.
<iframe width="560" height="315" src="https://www.youtube.com/embed/A1R8KGKkDjU" frameborder="0" allowfullscreen=""></iframe>
*   [Communicating Event Loops in Javascript](http://ssjs.pbworks.com/Communicating-Event-Loops) - a lighting talk given at a Server-Side Javascript Developer Meetup in San Francisco, USA, January 2010\. Thanks to Kris Kowal for uploading a video of the talk.
<iframe src="https://player.vimeo.com/video/9149445" width="500" height="281" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

[Communicating Event Loops](https://vimeo.com/9149445) from [Kris Kowal](https://vimeo.com/user2924382) on [Vimeo](https://vimeo.com).

## 2009

*   [Event-based concurrency control]({{site.asseturl}}/T37_nobackground.pdf) - tutorial given at the [OOPSLA 2009 conference](http://www.oopsla.org/oopsla2009/program/tutorials/158-event-based-concurrency-control) in Orlando, Florida, October 2009.
*   [Ambient-oriented Programming and AmbientTalk]({{site.asseturl}}/AmOP_Tokyo.pdf) - presentation given at the National Institute of Informatics, [GRACE Seminar](http://www.grace-center.jp/en/event/node/37), October 15th 2009, Tokyo, Japan
*   [Adding State and Visibility Control to Traits using Lexical Nesting]({{site.asseturl}}/Traits-ECOOP09.pdf) - presentation given at the 23rd European Conference on Object-Oriented Programming (ECOOP09), July 9th 2009, Genova, Italy

## 2008

*   [Ambient References: Object Designation in Mobile Ad Hoc Networks]({{site.asseturl}}/phd_talk_tom_van_cutsem.pdf) - presentation of my (private) PhD dissertation, April 30th 2008, Brussels, Belgium

## 2007

*   [AmbientTalk/2: Object-oriented Event-driven Programming in Mobile Ad hoc Networks]({{site.asseturl}}/AmbientTalk2-SCCC.pdf) - presentation at the [XXVI International Conference of the Chilean Computer Science Society](http://www.sccc.cl/sccc2007), November 8th 2007, Iquique, Chile and at the [Departamento de Ciencias de la Computacion (DCC)](http://www.dcc.uchile.cl), November 12th, Santiago, Chile
*   [Linguistic Symbiosis Between Actors and Threads]({{site.asseturl}}/LinguisticSymbiosis.pdf) - presentation at the [International Conference on Dynamic Languages](http://www.esug.org/conferences/15thinternationalsmalltalkjointconference2007/internationalconferenceondynamiclanguages), co-located with ESUG, August 27th 2007, Lugano, Switzerland
*   [AmbientTalk: Object-oriented Event-driven Programming in Mobile Ad hoc Networks]({{site.asseturl}}/AmbientTalk2-EPFL.pdf) - presentation at the [Programming Methods Laboratory (LAMP)](http://lamp.epfl.ch), July 25th 2007, EPFL, Lausanne, Switzerland
*   [Object-oriented Coordination in Mobile Ad hoc Networks]({{site.asseturl}}/COORDINATION07.pdf.zip) - paper presentation at the [9th International Conference on Coordination Models and Languages](http://www.cs.purdue.edu/homes/jv/events/COORD07), June 8th 2007, Paphos, Cyprus
*   [Event-driven Architectures]({{site.asseturl}}/eda.pdf) - presentation about event-driven programming and architecture.

## 2006

*   [Ambient References]({{site.asseturl}}/ambientrefs[DLS06].pdf) - paper presentation at the [Dynamic Languages Symposium](http://www.dcl.hpi.uni-potsdam.de/dls2006/openconf.php) at [OOPSLA 2006](http://www.oopsla.org), October 22, 2006, Portland, Oregon, USA
*   [Ambient-Oriented Programming]({{site.asseturl}}/amop-seps-2006.pdf) - Invited Talk at the First workshop on [Software Engineering for Pervasive Services](http://sam.iai.uni-bonn.de/seps2006/) (SEPS), in conjunction with ICPS 2006, Lyon, France, June 2006

## 2005

*   Ambient-Oriented Programming - Lab for Software Composition and Decomposition, ULB, Brussels, Belgium, December 2005
*   Abstractions for Context-aware Object References, presentation at the [Building Software for Pervasive Computing workshop](http://www.ics.uci.edu/~lopes/bspc05/) at OOPSLA05, October 2005, San Diego, California, USA
*   A Meta-architecture for Ambient-aware Objects, presentation at the first Workshop on [Object Technology for Ambient Intelligence](http://roots.iai.uni-bonn.de/OT4AmI) at ECOOP05, July 2005, Glasgow, Scotland

## 2004

*   [The Io Programming Language - PROG 26 November 2004]({{site.asseturl}}/IO-tvcutsem-26-11-04.pdf)
*   [Strong Mobility: CoDAMoS Deliverable - KULeuven 14 October 2004]({{site.asseturl}}/CoDAMoS-Mobility-14-10-04.pdf)
