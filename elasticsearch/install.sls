{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo

elasticsearch_jdk_package:
  pkg.installed:
    - name: {{ elasticsearch.jdk_pkg }}

elasticsearch_package:
  pkg.installed:
    - name: {{ elasticsearch.pkg }}
    {%- if elasticsearch.major_version != elasticsearch.version %}
    - version: {{ elasticsearch.version }}
    {%- endif %}
    - require:
      - sls: elasticsearch.repo
      - pkg: elasticsearch_jdk_package
