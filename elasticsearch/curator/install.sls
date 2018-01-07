{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.curator.repo

elasticsearch_curator_package:
  pkg.installed:
    - name: {{ elasticsearch.curator_pkg }}
    {%- if elasticsearch.major_version != elasticsearch.version %}
    - version: {{ elasticsearch.version }}
    {%- endif %}
    - require:
      {%- if elasticsearch.manage_repo %}
      - sls: elasticsearch.curator.repo
      {%- endif %}
