#! /bin/sh

cd {{ cookiecutter.prj_dr }}

./manage.py thumbnail clear_delete_all
./manage.py clear_cache
./manage.py clean_pyc -p ./
