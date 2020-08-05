#!/bin/bash

set -e
set -x

cd /srv/deploys/{{ cookiecutter.project_slug }}

git fetch --all
git pull
docker-compose -f production.yml build
docker-compose -f production.yml down
docker-compose -f production.yml up -d
docker-compose -f production.yml run --rm django python manage.py migrate --no-input
docker-compose -f production.yml run --rm django python manage.py collectstatic --no-input

cd -
