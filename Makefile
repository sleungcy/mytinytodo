build:
	docker build --platform=linux/amd64 . -t mytinytodo:latest

deploy:
	docker tag mytinytodo:latest docker.nginx.tc/sleungcy/mytinytodo:latest
	docker push docker.nginx.tc/sleungcy/mytinytodo:latest
