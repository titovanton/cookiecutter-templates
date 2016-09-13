# -*- coding: utf-8 -*-
'''
U must add it to .gitignore file
and set Unix file change mode and owner
'''

DEBUG = True
SECRET_KEY = '{% raw %}{{ secret_key }}{% endraw %}'

# DOMAIN
DOMAIN_NAME = '{{ cookiecutter.project_name }}.ru'
TRANSPORT = 'http'
URL = '%s://%s' % (TRANSPORT, DOMAIN_NAME)

# ALLOWED_HOSTS
ALLOWED_HOSTS = [DOMAIN_NAME, ]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ cookiecutter.db_usr }}',
        'USER': '{{ cookiecutter.db_usr }}',
        'PASSWORD': '{{ cookiecutter.db_pwd }}',
        'HOST': 'localhost',
        'PORT': '',
    }
}

REDIS_CONNECTION = {
    'host': 'localhost',
    'port': 6379,
    'db': 1,
}

# django-redis
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': 'redis://%s:%d/%d' % (
            REDIS_CONNECTION['host'],
            REDIS_CONNECTION['port'],
            REDIS_CONNECTION['db'],
        ),
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}

# django-rq
RQ_QUEUES = {
    'default': {
        'USE_REDIS_CACHE': 'default',
    },
}

# one year
CACHE_TIMEOUT = 60 * 60 * 24 * 30 * 12

# cache key prefix
KEY_PREFIX = 'cache:{{ cookiecutter.project_name }}:'

# EMAIL
EMAIL_HOST = 'localhost'
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
DEFAULT_FROM_EMAIL = u'{{ cookiecutter.project_name }} <no-reply@{{ cookiecutter.project_name }}>'
EMAIL_USE_TLS = False
EMAIL_PORT = 25
