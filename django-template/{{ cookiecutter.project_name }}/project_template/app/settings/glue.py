# -*- coding: utf-8 -*-

from path import rel_project
from path import rel_static_root
from path import rel_static_url


GLUE_CONFIG = {
    'source': rel_project('app', 'static_src', 'sprites_src'),
    'output': rel_static_root('sprites'),
    'move_styles_to': rel_project('app', 'static_src', 'scss', 'sprites'),
    'less': False,
    'scss': True,
    'css_url': rel_static_url('sprites'),
    'csscomb': True,
    'crop': True,
    'margin': 5,
}
