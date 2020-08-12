# {{cookiecutter.project_name}}

{{cookiecutter.description}}

For more details about files and settings check the official documentation: https://github.com/pydanny/cookiecutter-django

## Configure develop environment

- With local virtual env:
  - Create a python3 environment: `python3 -m venv env`
  - Enter this environment: `source env/bin/activate`
  - Install dependencies: `pip install -r requirements/vscode.txt`
  - Install pre-commit script: `pre-commit install`
- With docker environment: https://github.com/pydanny/cookiecutter-django/issues/2580

## Create new django app

- Create the `<name-of-the-app>` app with `python manage.py startapp`
- Move `<name-of-the-app>` directory to `<project_slug>` directory
- Edit `<project_slug>/<name-of-the-app>/apps.py` and
change `name = "<name-of-the-app>"` to `name = "<project_slug>.<name-of-the-app>"`
- Add `"<project_slug>.<name-of-the-app>.apps.<NameOfTheAppConfigClass>"`, on your LOCAL_APPS on `config/settings/base.py`

## Run develop environment

```bash
docker-compose -f local.yml up -d
```

This command creates 4 containers:

```bash
  Name                Command               State                       Ports
--------------------------------------------------------------------------------------------------
django     /entrypoint tail -f /dev/null    Up      0.0.0.0:8000->8000/tcp
docs       /bin/sh -c make livehtml         Up      0.0.0.0:7000->7000/tcp
node       docker-entrypoint.sh npm r ...   Up      0.0.0.0:3000->3000/tcp, 0.0.0.0:3001->3001/tcp
postgres   docker-entrypoint.sh postgres    Up      5432/tc
```

## Run commands inside django containers

```bash
docker-compose -f local.yml run --rm django python manage.py migrate
docker-compose -f local.yml run --rm django python manage.py collectstatic
docker-compose -f local.yml exec django /entrypoint python manage.py runserver 0.0.0.0:8000
```

## Run production environment

```bash
docker-compose -f production.yml up -d
```

This command creates 4 containers:

```bash
        Name                       Command               State    Ports
-------------------------------------------------------------------------
{{ cookiecutter.project_slug }}_django_1     /entrypoint /start               Up
{{ cookiecutter.project_slug }}_nginx_1      /usr/sbin/nginx                  Up      80/tcp
{{ cookiecutter.project_slug }}_postgres_1   docker-entrypoint.sh postgres    Up      5432/tcp
{{ cookiecutter.project_slug }}_redis_1      docker-entrypoint.sh redis ...   Up      6379/tcp
```

## Configure deploy by gitlab ci

- Add **deploy key** of `gitlab-ci` user to the repository
- Add variables to gitlab repository (`SSH_PORT`, `SSH_HOST`, etc.)
- Clone the repository in `/srv/deploys/`
- Check the pipeline and use manual job to update the deploy
