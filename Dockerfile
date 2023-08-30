FROM debian:bookworm-slim

ARG UNAME=steam
ARG UID=1000
ARG GID=100

RUN useradd -l -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    wget \
    ca-certificates \
    libstdc++6 \
    lib32stdc++6 \
    libtinfo5 \
    software-properties-common \
    wine winbind xvfb screen \
    && rm -rf /var/lib/apt/lists/*

# Install wine stuff
# hadolint ignore=DL3008
RUN dpkg --add-architecture i386 \
    && echo "deb http://deb.debian.org/debian bookworm contrib" > /etc/apt/sources.list.d/contrib.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    wine32 winetricks \
    && rm -rf /var/lib/apt/lists/*

# Use rootless user
USER $UID:$GID

# Prebuild Wine config
ENV WINEARCH=win64
RUN WINEDEBUG=-all winetricks sound=disabled

# Create directories for SteamCMD and BattleBit, force install dir, update SteamCMD
WORKDIR /home/steam
RUN mkdir -p /home/steam/steamcmd
WORKDIR /home/steam/steamcmd
RUN mkdir -p /home/steam/battlebit \
    && wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && /home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/steam/battlebit +quit

# Copy the run script into the container
WORKDIR /home/steam
COPY --chown=$UID:$GID src/run.sh src/login.sh ./

# Command to start the run script
CMD ["bash", "./run.sh"]
