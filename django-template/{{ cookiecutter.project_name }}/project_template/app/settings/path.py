# -*- coding: utf-8 -*-

import os


PROJECT_ROOT = '{{ cookiecutter.prj_dr }}'


def rel_project(*x):
    return os.path.join(PROJECT_ROOT, *x)


BASE_DIR = rel_project('app')


MEDIA_ROOT = '{{ cookiecutter.data_dr }}/media/'
MEDIA_URL = '/media/'
STATIC_ROOT = '{{ cookiecutter.data_dr }}/static/'
STATIC_URL = '/static/'
# INTERNAL_ROOT = '{{ cookiecutter.data_dr }}/internal/'
# INTERNAL_URL = '/internal/'


def rel_static_root(*x):
    return os.path.join(STATIC_ROOT, *x)


def rel_static_url(*x):
    path = os.path.join(STATIC_URL, *x)
    if not path.endswith('/'):
        path += '/'
    return path
