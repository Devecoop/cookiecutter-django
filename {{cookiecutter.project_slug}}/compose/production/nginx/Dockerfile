FROM tutum/nginx
RUN rm /etc/nginx/sites-enabled/default
ADD sites-enabled/{{ cookiecutter.project_slug }} /etc/nginx/sites-enabled/{{ cookiecutter.project_slug }}
