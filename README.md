# BattleBit Server Docker

## Caution

Hosting Battlebit on Linux is HIGHLY EXPERIMENTAL :warning:

## How to run

* Copy `.env.example` to `config` folder and rename it to `.env`
* Copy `server.conf.example` to `config` folder and rename it to `server.conf`
* Edit `.env` and `server.conf` to your liking
* (Optional) Login with 2FA, see below
* Run `docker compose up -d` or `make` to start the server
* Run `docker compose down -v` or `make stop-server` to stop the server

### Notes

* Server should have 2 ports open:
  * Game port (default: 30000/udp)
  * `Query port = Game port + 1` (default: 30001/udp)
* If your server is behind NAT, you need to forward these ports to your server
* If you want to use a custom API endpoint, edit in `server.conf` accordingly

### (Optional) Login with 2FA

You only need to do this at the first time, and only when the login session is expired.

```shell
docker run --rm -it \
    -v $(pwd)/data/battlebit:/home/steam/battlebit \
    -v $(pwd)/data/Steam:/root/Steam \
    --env-file ./config/.env \
    ghcr.io/jackblk/battlebit-server-docker bash login.sh
```
