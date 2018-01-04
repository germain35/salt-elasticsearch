{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.service
  - elasticsearch.index

{%- for alias, params in elasticsearch.get('alias', {}).iteritems() %}
  {%- if params.get('present', True) %}
elasticsearch_alias_{{alias}}:
  elasticsearch.alias_present:
    - name: {{ alias }}
    - index: {{ params.index }}
    {%- if params.definition is defined and params.definition is mapping %}
    - definition: {{ params.definition }}
    {%- endif %}
  {%- else %}
elasticsearch_alias_{{alias}}_absent:
  elasticsearch.alias_absent:
    - name: {{ alias }}
    - index: {{ params.index }}
  {%- endif %}
{%- endfor %}