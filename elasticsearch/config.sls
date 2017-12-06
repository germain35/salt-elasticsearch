{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo
  - elasticsearch.install
  - elasticsearch.service

elasticsearch_sysconfig:
  file.managed:
    - name: {{ elasticsearch.sysconfig_file }}
    - source: salt://elasticsearch/templates/sysconfig.jinja
    - template: jinja
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0600
    - makedirs: True
    - require:
      - pkg: elasticsearch_packages
    - watch_in:
      - service: elasticsearch_service
    - context:
        sysconfig: {{ elasticsearch.get('sysconfig', '{}') }}

{%- if elasticsearch.config %}
elasticsearch_config:
  file.serialize:
    - name: {{ elasticsearch.config_file }}
    - dataset: {{ elasticsearch.config }}
    - formatter: yaml
    - user: root
    - group: root
    - mode: 0644
    - makedirs: True
    - require:
      - pkg: elasticsearch_packages
      - file: elasticsearch_sysconfig
    - watch_in:
      - service: elasticsearch_service

  {%- if elasticsearch.config.get('path.data', None) %}
{{elasticsearch.config.get('path.data')}}:
  file.directory:
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0700
    - makedirs: True
    - require_in:
      - service: elasticsearch_service
  {%- endif %}

  {%- if elasticsearch.config.get('path.logs', None) %}
{{elasticsearch.config.get('path.logs')}}:
  file.directory:
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0700
    - makedirs: True
    - require_in:
      - service: elasticsearch_service
  {%- endif %}
{%- endif %}

{%- if elasticsearch.jvm_opts is defined %}
elasticsearch_jvm_opts:
  file.managed:
    - name: {{ elasticsearch.jvm_opts_file }}
    - mode: 0750
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - makedirs: True
    - contents: {{ elasticsearch.jvm_opts }}
    - watch_in:
      - service: elasticsearch_service
{% endif -%}
