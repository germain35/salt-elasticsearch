{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.service

{%- for index, params in elasticsearch.get('index', {}).iteritems() %}
  {%- if params.get('present', True) %}
elasticsearch_index_{{index}}:
  elasticsearch.index_present:
    - name: {{ index }}
    - index: {{ params.index }}
    {%- if params.definition is defined and params.definition is mapping %}
    - definition: {{ params.definition }}
    {%- endif %}
  {%- else %}
elasticsearch_index_{{index}}_absent:
  elasticsearch.index_absent:
    - name: {{index}}
  {%- endif %}
{%- endfor %}