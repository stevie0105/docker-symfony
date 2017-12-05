project-name=docker-symfony
db=mysql

network := $(shell docker network ls | grep $(project-name))

init:
ifeq ($(network),)
	@docker network create $(project-name)
endif
	@true

#################
## Application ##
#################

app-build:
	docker build -t $(project-name) .

app-build-dev:
	docker build -t $(project-name)-dev -f Dockerfile.dev .

app-run: init app-build
	docker run -d --net=$(project-name) -p 80:80 --name $(project-name) $(project-name)

app-run-dev: init app-build-dev
	docker run -d --net=$(project-name) -p 81:80 -v"`pwd`:/var/www/." --name $(project-name)-dev $(project-name)-dev

app-stop: 
	docker stop $(project-name)

app-stop-dev: 
	docker stop $(project-name)-dev

app-remove-container: app-stop
	docker rm $(project-name)

app-remove-container-dev: app-stop-dev
	docker rm $(project-name)-dev

app-remove-image: app-stop app-remove-container
	docker rmi $(project-name)

app-remove-image-dev: app-stop-dev app-remove-container-dev
	docker rmi $(project-name)-dev


##############
## Database ##
##############

db-run: init
	@read -p "Enter $(db) root password:" password; \
	docker run -d --net=$(project-name) -p 3306:3306 --name $(db) -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=$(project-name) -e MYSQL_PASSWORD=$(project-name) -e MYSQL_DATABASE=$(project-name) $(db)
	$(MAKE) parameters

db-stop:
	docker stop $(db)

db-remove-container: db-stop
	docker rm $(db)

db-remove-image: db-stop db-remove-container
	docker rmi $(db)


################
## PHPmyAdmin ##
################

myadmin-run: init
	docker run -d --net=$(project-name) -e PMA_HOST=$(db) -p 8081:80 --name myadmin phpmyadmin/phpmyadmin

myadmin-stop:
	docker stop myadmin

myadmin-remove-container: myadmin-stop
	docker rm myadmin

myadmin-remove-image: myadmin-stop myadmin-remove-container
	docker rmi myadmin

###################
## Configuration ##
###################

parameters:
	@read -p "Enter your $(db) root password again:" password; \
	printf "parameters: \n    database_host: mysql \n    database_port: 3306 \n    database_name: $(project-name) \n    database_user: $(project-name) \n    database_password: $$password \n    mailer_transport: smtp \n    mailer_host: 127.0.0.1 \n    mailer_user: null \n    mailer_password: null \n    secret: 9eb6ea75c64ffbb76244c15b8375ce74d30dfdb5" > ./app/config/parameters.yml

