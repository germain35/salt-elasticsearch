{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

{%- set osfamily   = salt['grains.get']('os_family') %}
{%- set os         = salt['grains.get']('os') %}
{%- set osrelease  = salt['grains.get']('osrelease') %}
{%- set oscodename = salt['grains.get']('oscodename') %}

{%- if elasticsearch.manage_repo %}
  {%- if osfamily == 'Debian' %}
elasticsearch_apts_pkg:
  pkg.installed:
    - name: apt-transport-https
    - require_in:
      - pkgrepo: elasticsearch_repo
  {%- endif %}
  
  {%- if 'repo' in elasticsearch and elasticsearch.repo is mapping %}
elasticsearch_repo:
  pkgrepo.managed:
    {%- for k, v in elasticsearch.repo.items() %}
    - {{k}}: {{v}}
    {%- endfor %}
  {%- endif %}
{%- endif %}

