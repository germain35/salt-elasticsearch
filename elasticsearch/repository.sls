{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.service

{%- for repository, params in elasticsearch.get('repository', {}).iteritems() %}
  {%- if params.get('enabled', True) %}
elasticsearch_repository_{{repository}}:
  module.run:
    - elasticsearch.repository_create
      - name: {{ repository }}
      - body: {{ params|json }}
  {%- else %}
elasticsearch_repository_{{repository}}_absent:
  module.run:
    - elasticsearch.repository_delete
      - name: {{ repository }}
  {%- endif %}
{%- endfor %}