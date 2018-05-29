{%- from "elasticsearch/map.jinja" import elasticsearch with context %}

include:
  - elasticsearch.repo

{%- if elasticsearch.python.get('version', False) %}

  {%- set string_version = elasticsearch.python.version|string %}
  {%- set major_version  = string_version.split('.')[0]|int %}

elasticsearch_python_packages:
  pkg.installed:
    - pkgs: 
      - python{{major_version}}-pip
      - python{{major_version}}-setuptools
    - reload_modules: true

elasticsearch_pip_package:
  pip.installed:
    - name: {{ elasticsearch.pip_pkg }}
    - bin_env: {{ elasticsearch.python.pip.bin_env }}
    {%- if elasticsearch.python.pip.get('no_index', False) %}
    - no_index: True
    {%- endif %}
    {%- if elasticsearch.python.pip.get('index_url', False) %}
    - index_url: {{ elasticsearch.python.pip.index_url }}
      {%- if elasticsearch.python.pip.get('trusted_host', False) %}
    - trusted_host: {{ elasticsearch.python.pip.trusted_host }}
      {%- endif %}
    {%- endif %}
    {%- if elasticsearch.python.pip.get('find_links', False) %}
    - find_links: {{ elasticsearch.python.pip.find_links }}
    {%- endif %}
    - require:
      - pkg: elasticsearch_python_packages
  
  {%- else %}

elasticsearch_python_packages:
  pkg.installed:
    - pkgs: 
      - python-pip
      - python-setuptools
    - reload_modules: true

elasticsearch_pip_package:
  pip.installed:
    - name: {{ elasticsearch.pip_pkg }}
    {%- if elasticsearch.python.pip.get('no_index', False) %}
    - no_index: True
    {%- endif %}
    {%- if elasticsearch.python.pip.get('index_url', False) %}
    - index_url: {{ elasticsearch.python.pip.index_url }}
      {%- if elasticsearch.python.pip.get('trusted_host', False) %}
    - trusted_host: {{ elasticsearch.python.pip.trusted_host }}
      {%- endif %}
    {%- endif %}
    {%- if elasticsearch.python.pip.get('find_links', False) %}
    - find_links: {{ elasticsearch.python.pip.find_links }}
    {%- endif %}
    - require:
      - pkg: elasticsearch_python_packages

{%- endif %}

elasticsearch_jdk_package:
  pkg.installed:
    - name: {{ elasticsearch.jdk_pkg }}

elasticsearch_package:
  pkg.installed:
    - name: {{ elasticsearch.pkg }}
    {%- if elasticsearch.major_version != elasticsearch.version %}
    - version: {{ elasticsearch.version }}
    {%- endif %}
    - require:
      {%- if elasticsearch.manage_repo %}
      - sls: elasticsearch.repo
      {%- endif %}
      - pkg: elasticsearch_jdk_package
