{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.curator.repo

elasticsearch_curator_package:
  pkg.installed:
    - name: {{ elasticsearch.curator_pkg }}
    {%- if elasticsearch.curator_major_version != elasticsearch.curator.version %}
    - version: {{ elasticsearch.curator.version }}
    {%- endif %}
    {%- if elasticsearch.manage_repo %}
    - require:
      - sls: elasticsearch.curator.repo
    {%- endif %}
