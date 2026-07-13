# invokedynamic

The Jekyll sources for my personal website and blog.

View the version [rendered for humans](http://tvcutsem.github.io).

Based on a [Jekyll Clean](https://github.com/scotte/jekyll-clean) theme.

## Building locally

The site is served by [GitHub Pages](http://tvcutsem.github.io) — pushing to `master`
publishes automatically, so a local build is only needed for previewing changes.

Requires Ruby (managed with [`rbenv`](https://github.com/rbenv/rbenv); the version is
pinned in `.ruby-version`). Then:

```bash
bundle install                # install gems (the github-pages gem, Jekyll included)
bundle exec jekyll serve      # preview at http://localhost:4000 with live reload
bundle exec jekyll build      # build the static site to _site/
```