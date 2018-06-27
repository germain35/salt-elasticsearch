{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.install
  - elasticsearch.config
  - elasticsearch.service

{%- for name, repo in elasticsearch.get('plugins', {}).items() %}
elasticsearch_plugin_{{ name }}:
  cmd.run:
    - name: {{ elasticsearch.home_dir | path_join(elasticsearch.plugin_bin) }} install -b {{ repo }}
    - require:
      - pkg: elasticsearch_package
    - unless: test -x {{ elasticsearch.home_dir | path_join('plugins', name) }}
    - watch_in:
      - service: elasticsearch_service 
{%- endfor %}