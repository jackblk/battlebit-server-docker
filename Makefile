.PHONY: run-server stop-server build-docker push-docker
.DEFAULT_GOAL := run-server

run-server:
	@docker compose up -d

stop-server:
	@docker compose down -v

accept-eula:
	@docker exec -it battlebit-server-docker sed -i 's/false/true/g' /home/steam/battlebit/eula.txt

build-docker:
	@docker build --rm -t ghcr.io/jackblk/battlebit-server-docker .

push-docker:
	@docker push ghcr.io/jackblk/battlebit-server-docker
