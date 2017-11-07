FROM ubuntu:latest

MAINTAINER M3philis <m3philis@m3philis.de>
ENV DST_PATH=/steam
ENV DST_CONFIG_DIR=dst_config
ENV CLUSTER=Chaos
ENV SHARD=Master

RUN dpkg --add-architecture i386 \
    && apt update -y \
		&& apt-get dist-upgrade -y \
		&& apt-get install -y wget libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386

RUN mkdir -p /steam/{bin,dst,dst_config}

WORKDIR /steam/bin

RUN wget http://media.steampowered.com/client/steamcmd_linux.tar.gz \
		&& tar xvzf steamcmd_linux.tar.gz

RUN /steam/bin/steamcmd.sh +login anonymous +quit \
		&& /steam/bin/steamcmd.sh +force_install_dir "/steam/dst" +login anonymous +app_update 343050 validate +quit

COPY ./configs/$CLUSTER/$SHARD /steam/dst_config

WORKDIR /steam/dst/bin

CMD [ './dontstarve_dedicated_server_nullrenderer -persistent_storage_root $DST_PATH -conf_dir $DST_CONFIG_DIR -cluster $CLUSTER -shard $SHARD' ]


