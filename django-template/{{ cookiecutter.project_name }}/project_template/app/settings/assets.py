# -*- coding: utf-8 -*-

from secret import DEBUG
from path import rel_project
from path import STATIC_ROOT
from path import STATIC_URL


ASSETS_AUTO_BUILD = DEBUG

ASSETS_LOAD_PATH = [
    STATIC_ROOT,
    rel_project('app', 'static_src'),
    rel_project('frontend'),
]

ASSETS_URL_MAPPING = {
    ASSETS_LOAD_PATH[0]: STATIC_URL,
    ASSETS_LOAD_PATH[1]: STATIC_URL,
    ASSETS_LOAD_PATH[2]: STATIC_URL,
}

LESS_BIN = '{{ cookiecutter.snc_dr }}/node_modules/.bin/lessc'
COFFEE_BIN = '{{ cookiecutter.snc_dr }}/node_modules/.bin/coffee'
