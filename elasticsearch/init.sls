{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo
  - elasticsearch.install
  - elasticsearch.config
  - elasticsearch.service
  - elasticsearch.plugin
  - elasticsearch.index
  - elasticsearch.alias
