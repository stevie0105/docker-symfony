docker-symfony
==============

symfony + mysql development with docker containers

# Usage
- open Makefile and change the project name to your project name 
- run 'make app-dev-run' on your console and your application is available at localhost:81 with your work directory mounted for development
- run 'make app-run' on your console for a productive ready container thats connected to port 80
- run 'make db-run' to start the mysql container
- you will be asked for the db root password you want to set
- then you will be asked for this password again to set it in your symfony parameters.yml
