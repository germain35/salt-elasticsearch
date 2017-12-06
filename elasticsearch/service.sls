{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.install
  - elasticsearch.config

elasticsearch_service:
  service.running:
    - name: {{ elasticsearch.service }}
    - enable: True
    - require:
        - pkg: elasticsearch_packages
