{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo
  - elasticsearch.install
  - elasticsearch.service

elasticsearch_defaults:
  file.managed:
    - name: {{ elasticsearch.defaults_file }}
    - source: salt://elasticsearch/templates/defaults.jinja
    - template: jinja
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0600
    - makedirs: True
    - require:
      - pkg: elasticsearch_package
    - watch_in:
      - service: elasticsearch_service
    - context:
        defaults: {{ elasticsearch.get('defaults', '{}') }}

{%- if elasticsearch.config %}
elasticsearch_config:
  file.serialize:
    - name: {{ elasticsearch.conf_file }}
    - dataset: {{ elasticsearch.config }}
    - formatter: yaml
    - user: root
    - group: root
    - mode: 0644
    - makedirs: True
    - require:
      - pkg: elasticsearch_package
      - file: elasticsearch_defaults
    - watch_in:
      - service: elasticsearch_service

#elasticsearch_logging:
#  file.managed:
#  - name: {{ elasticsearch.logging_file }}
#  - source: salt://elasticsearch/templates/log4j2.properties.jinja
#  - template: jinja
#  - require:
#    - pkg: elasticsearch_package

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
    - require: 
      - pkg: elasticsearch_package
    - watch_in:
      - service: elasticsearch_service
{% endif -%}

{%- if grains.get('init') == 'systemd' %}
elasticsearch_override_limit_memlock_file:
  file.managed:
  - name: {{ elasticsearch.systemd_override_conf_file }}
  - makedirs: True
  - contents: |
      [Service]
      LimitMEMLOCK=infinity
  - require:
    - pkg: elasticsearch_package
  - watch_in:
    - module: elasticsearch_systemctl_reload

elasticsearch_systemctl_reload:
  module.wait:
    - service.systemctl_reload: []
    - watch_in:
      - service: elasticsearch_service
{%- endif %}
