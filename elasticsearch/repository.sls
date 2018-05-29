{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.service

{%- for repository, params in elasticsearch.get('repository', {}).iteritems() %}

elasticsearch_repository_{{repository}}_dir:
  file.directory:
    - name: {{ params.settings.location }}
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - makedirs: True
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

elasticsearch_repository_{{repository}}:
  module.run:
    - elasticsearch.repository_create:
      - name: {{ repository }}
      - body: {{ params|json }}

{%- endfor %}