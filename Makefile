project-name=docker-symfony
db=mysql

#################
## Application ##
#################

app-build:
	docker build -t $(project-name) .

app-build-dev:
	docker build -t $(project-name)-dev -f Dockerfile.dev .

app-run: app-build
	docker run -d -p 80:80 --name $(projct-name) $(project-name)

app-run-dev: app-build-dev
	docker run -d -p 81:80 -v"`pwd`:/var/www/." --name $(project-name)-dev $(project-name)-dev

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

db-run:
	@read -p "Enter $(db) root password:" password; \
	docker run -d -p 3306:3306 --name $(db) -e MYSQL_ROOT_PASSWORD=password $(db)

db-stop:
	docker stop $(db)

db-remove-container: db-stop
	docker rm $(db)

db-remove-image: db-stop db-remove-container
	docker rmi $(db)
