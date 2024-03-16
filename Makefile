linux-build:
	docker compose -f ./docker-compose.yml build --no-cache
linux-deploy:
	docker compose -f .\docker-compose.yml up -d

window-build:
	docker-compose -f ./docker-compose.yml build --no-cache
window-deploy:
	docker-compose -f .\docker-compose.yml up -d