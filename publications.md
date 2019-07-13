---
title: Publications
layout: page
permalink: /publications/
---

## Selected Publications

Below is a selection of my academic publications. For a complete list, see:

*   My publications on [Google Scholar](http://scholar.google.com/citations?user=jtzNCwUAAAAJ&hl=en).
*   My [ACM Portal](http://portal.acm.org/author_page.cfm?id=81100203786) author page.
*   My [DBLP](http://www.informatik.uni-trier.de/~ley/db/indices/a-tree/c/Cutsem:Tom_Van.html) page.
*   [My ResearchGate profile](https://www.researchgate.net/profile/Tom_Van_Cutsem)

<table class="table table-hover">

<colgroup>
<col width="6%" />
<col width="8%" />
<col width="18%" />
<col width="55%" />
<col width="13%" />
</colgroup>

<thead>
<tr class="header">
<th>Date</th>
<th>Type</th>
<th>Authors</th>
<th>Title</th>
<th>Venue</th>
</tr>
</thead>
<tbody>
{% for pub in site.data.pubs %}
  <tr>
    <td markdown="span">{{pub.date}}</td>
    <td markdown="span">{{pub.type}}</td>
    <td>
      <ul class="list-unstyled">      
      {%- for author in pub.authors -%}
      <li>      
      {%- if author == 'Tom Van Cutsem' %}<strong>{{author}}</strong>
      {%- else %}{{ author }}
      {%- endif %}
      </li>
      {% endfor %}
      </ul>
    </td>
    <td markdown="span">{{pub.title}}<br>
    {% if pub.path %}<a class="btn btn-info btn-xs" target="_blank" href="{{site.asseturl}}/{{pub.path}}">author copy</a>{% endif %}
    {%- if pub.url %}<a class="btn btn-info btn-xs" target="_blank" href="{{pub.url}}">author copy</a>{% endif %}
    {% if pub.publisher_link %}<a class="btn btn-warning btn-xs" target="_blank" href="{{ pub.publisher_link }}">publisher link</a>{% endif %}
    {%- if pub.slides_path %}<a class="btn btn-warning btn-xs" target="_blank" href="{{site.asseturl}}/{{ pub.slides_path }}">talk slides</a>{% endif %}
    {% for tag in pub.tags -%}<span class="btn btn-default btn-xs disabled">{{tag}}</span> {% endfor %}
    </td>
    <td markdown="span">{{pub.venue}}</td>
  </tr>
{% endfor %}
</tbody>
</table>
