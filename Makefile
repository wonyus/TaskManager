linux-build:
	docker compose -f ./docker-compose.yml build --no-cache
linux-deploy:
	docker compose -f .\docker-compose.yml up -d --scale worker=2

window-build:
	docker-compose -f ./docker-compose.yml build --no-cache
window-deploy:
	docker-compose -f .\docker-compose.yml up -d