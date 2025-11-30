docker-up-dev:
	cd deployment/docker_compose && docker-compose -f docker-compose.dev.yml up

docker-down-dev:
	cd deployment/docker_compose && docker-compose -f docker-compose.dev.yml down

start-app:
	cd deployment/unix && chmod +x start.sh setup.sh && ./setup.sh && ./start.sh

start-app-windows:
	cd deployment/windows && setup.bat && start.bat