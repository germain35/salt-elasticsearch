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
      {%- if elasticsearch.manage_repo %}
      - sls: elasticsearch.repo
      {%- endif %}
      - pkg: elasticsearch_jdk_package
