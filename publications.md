---
title: Publications
layout: page
permalink: /publications/
---

## Selected Publications

Below is a selection of my scientific publications. For a complete list, see:

*   My publications on [Google Scholar](http://scholar.google.com/citations?user=jtzNCwUAAAAJ&hl=en).
*   My [DBLP](https://dblp.org/pid/20/6382.html) page.
*   My [ACM Portal](http://portal.acm.org/author_page.cfm?id=81100203786) author page.
*   My [ResearchGate](https://www.researchgate.net/profile/Tom_Van_Cutsem) profile (not maintained).

<div class="table-scroll">
<table class="data-table pub-table">

<colgroup>
<col class="col-type" />
<col class="col-authors" />
<col class="col-title" />
<col class="col-venue" />
</colgroup>

<thead>
<tr>
<th>Type</th>
<th>Authors</th>
<th>Title</th>
<th>Venue</th>
</tr>
</thead>
<tbody>
{% assign prev_year = '' %}
{% for pub in site.data.pubs %}
  {% capture pub_year %}{{ pub.date }}{% endcapture %}
  {% if pub_year != prev_year %}
  <tr class="year-row"><td colspan="4"><span class="year-band">{{ pub_year }}</span></td></tr>
  {% assign prev_year = pub_year %}
  {% endif %}
  <tr>
    <td class="cell-type" markdown="span">{{pub.type}}</td>
    <td class="cell-authors">
      <ul class="author-list">
      {%- for author in pub.authors -%}
      <li>
      {%- if author == 'Tom Van Cutsem' %}<strong>{{author}}</strong>
      {%- else %}{{ author }}
      {%- endif %}
      </li>
      {% endfor %}
      </ul>
    </td>
    <td class="cell-title"><span class="work-title" markdown="span">{{pub.title}}</span>
    <span class="row-links">
    {% if pub.path %}<a class="action-link" target="_blank" href="{{site.asseturl}}/{{pub.path}}">author copy</a>{% endif %}
    {%- if pub.url %}<a class="action-link" target="_blank" href="{{pub.url}}">author copy</a>{% endif %}
    {% if pub.publisher_link %}<a class="action-link" target="_blank" href="{{ pub.publisher_link }}">publisher link</a>{% endif %}
    {%- if pub.slides_path %}<a class="action-link" target="_blank" href="{{site.asseturl}}/{{ pub.slides_path }}">talk slides</a>{% endif %}
    {% for tag in pub.tags -%}<span class="tag-chip">{{tag}}</span> {% endfor %}
    </span>
    </td>
    <td class="cell-venue" markdown="span">{{pub.venue}}</td>
  </tr>
{% endfor %}
</tbody>
</table>
</div>
