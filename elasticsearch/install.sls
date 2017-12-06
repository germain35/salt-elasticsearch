{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo

elasticsearch_packages:
  pkg.installed:
    - pkgs: {{ elasticsearch.pkgs }}
    - require:
      - sls: elasticsearch.repo
