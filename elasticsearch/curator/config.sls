{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.curator.install


elasticsearch_curator_config:
  file.managed:
  - name: {{ elasticsearch.curator.conf_file }}
  - source: salt://elasticsearch/templates/curator.yml.jinja
  - user: {{ elasticsearch.user }}
  - group: {{ elasticsearch.group }}
  - mode: 640
  - template: jinja
  - require:
    - pkg: elasticsearch_curator_package

elasticsearch_curator_action_config:
  file.managed:
  - name: {{ elasticsearch.curator.action_conf_file }}
  - source: salt://elasticsearch/templates/curator_actions.yml.jinja
  - user: {{ elasticsearch.user }}
  - group: {{ elasticsearch.group }}
  - mode: 640
  - template: jinja
  - require:
    - file: elasticsearch_curator_config

elasticsearch_curator_cron:
  cron.present:
    - name: "curator --config {{ elasticsearch.curator.conf_file }} {{ elasticsearch.curator.action_conf_file }} >/dev/null"
    - user: {{ elasticsearch.user }}
    - minute: {{ elasticsearch.curator.cron.minute }}
    - hour: {{ elasticsearch.curator.cron.hour }}

elasticsearch_curator_cron_path:
  cron.env_present:
    - name: PATH
    - user: {{ elasticsearch.user }}
    - value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    - require_in:
      - cron: elasticsearch_curator_cron

{%- if elasticsearch.curator.config.logging.logfile is defined %}
elasticsearch_curator_log:
  file.managed:
  - name: {{ elasticsearch.curator.config.logging.logfile }}
  - user: {{ elasticsearch.user }}
  - group: {{ elasticsearch.group }}
  - mode: 640
  - makedirs: True
{%- endif %}
