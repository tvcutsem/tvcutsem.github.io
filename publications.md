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

{% assign prev_year = "" %}
{% for pub in site.data.pubs %}
{%- capture pub_year %}{{ pub.date }}{% endcapture -%}
{%- if pub_year != prev_year -%}
{%- unless forloop.first %}
</ul>
{% endunless %}
<h2 class="ref-year" id="pub-{{ pub_year }}">{{ pub_year }}</h2>
<ul class="ref-list">
{%- endif %}
<li class="ref-item">
  <div class="ref-meta">
    <span>{{ pub.type }}</span>
  </div>
  <div class="ref-body">
    <span class="ref-title" markdown="span">{{ pub.title }}</span>
    <span class="ref-authors">
      {%- for author in pub.authors -%}
        {%- if author == 'Tom Van Cutsem' -%}<strong>{{ author }}</strong>{%- else -%}{{ author }}{%- endif -%}
        {%- unless forloop.last %}, {% endunless -%}
      {%- endfor -%}
    </span>
    <span class="ref-venue" markdown="span">{{ pub.venue }}</span>
    <div class="ref-actions">
      {% if pub.path %}<a class="ref-link" target="_blank" href="{{ site.asseturl }}/{{ pub.path }}">author copy</a>{% endif %}
      {%- if pub.url %}<a class="ref-link" target="_blank" href="{{ pub.url }}">author copy</a>{% endif %}
      {% if pub.publisher_link %}<a class="ref-link" target="_blank" href="{{ pub.publisher_link }}">publisher link</a>{% endif %}
      {%- if pub.slides_path %}<a class="ref-link" target="_blank" href="{{ site.asseturl }}/{{ pub.slides_path }}">talk slides</a>{% endif %}
    </div>
    {% if pub.tags %}<div class="ref-tags">{{ pub.tags | join: " &middot; " }}</div>{% endif %}
  </div>
</li>
{%- assign prev_year = pub_year -%}
{%- if forloop.last %}
</ul>
{% endif -%}
{% endfor %}
