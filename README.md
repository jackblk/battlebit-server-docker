# BattleBit Server Docker

## Caution

Hosting Battlebit on Linux is HIGHLY EXPERIMENTAL :warning:

## How to run

* Copy `.env.example` to `config` folder and rename it to `.env`
* Copy `server.conf.example` to `config` folder and rename it to `server.conf`
* Edit `.env` and `server.conf` to your liking
* (Optional) Login with 2FA, see below
* (Optional) If you use custom API from [BattleBitAPIRunner](https://github.com/BattleBit-Community-Servers/BattleBitAPIRunner), see below
* **IMPORTANT** Create data folders with the right permission: `mkdir -p data/Steam data/battlebit && chown 1000:100 -R data`
* Run `docker compose up -d` or `make` to start the server
* Run `docker compose down -v` or `make stop-server` to stop the server

### Notes

* This docker image uses `steam` user (non-root), has ID: `1000:100`. If you encounter permission issues for `data` folder,
remove the `data` folder and re-create it with the right permisison.
* Server should have 2 ports open:
  * Game port (default: 30000/udp)
  * `Query port = Game port + 1` (default: 30001/udp)
* If your server is behind NAT, you need to forward these ports to your server
* If you want to use a custom API endpoint, edit in `server.conf` accordingly

### (Optional) Login with 2FA

You only need to do this at the first time, and only when the login session is expired.

```shell
docker run --rm -it \
  --name battlebit-docker \
  -v $(pwd)/data/battlebit:/home/steam/battlebit \
  -v $(pwd)/data/Steam:/home/steam/Steam \
  --env-file ./config/.env \
  ghcr.io/jackblk/battlebit-server-docker bash login.sh
```

### Accept EULA

Run this while the container is running: `make accept-eula`

Or:

```shell
docker exec -it battlebit-server-docker sed -i 's/false/true/g' /home/steam/battlebit/eula.txt
```

### BattleBitAPIRunner

* Create data folder for BattleBitAPIRunner:

```
mkdir -p config/runner/modules config/runner/dependencies config/runner/configurations
cp appsettings.json.example config/runner/appsettings.json
chown 1000:100 -R config/runner
```

* Refer [Hosting Guide](https://github.com/BattleBit-Community-Servers/BattleBitAPIRunner/wiki/Hosting-Guide) to create folders & files accordingly:
  * `appsettings.json`
  * `modules/...`
  * `dependencies/...`
  * `configurations/...`
* Edit `ApiEndpoint=battlebit-runner:29999` in `server.conf` to use custom API endpoint
* Uncomment everything in `battlebit-runner` service in `docker-compose.yml`

## Credits

* [DasIschBims/BattleBitDocker](https://github.com/DasIschBims/BattleBitDocker)
