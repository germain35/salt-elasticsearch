{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.curator.repo
  - elasticsearch.curator.install
  - elasticsearch.curator.config