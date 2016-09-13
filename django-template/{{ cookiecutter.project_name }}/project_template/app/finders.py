# -*- coding: utf-8 -*-

from django.core.files.storage import FileSystemStorage
from django.contrib.staticfiles.finders import BaseStorageFinder

from app.settings.path import rel_project


class BicycleFinder(BaseStorageFinder):
    storage = FileSystemStorage(rel_project('bicycle', 'static_src'))


class AppFinder(BaseStorageFinder):
    storage = FileSystemStorage(rel_project('app', 'static_src'))


class FrontendFinder(BaseStorageFinder):
    storage = FileSystemStorage(rel_project('frontend'))
