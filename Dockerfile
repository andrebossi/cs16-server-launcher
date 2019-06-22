FROM debian:stretch-slim

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="dobolinux <andreluizbossi70@gmail.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="cs16-server-launcher" \
    org.label-schema.description="CS 1.6 Server Launcher" \
    org.label-schema.version=$VERSION \
    org.label-schema.url="https://github.com/dobolinux/cs16-server-launcher" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/dobolinux/cs16-server-launcher" \
    org.label-schema.vendor="dobolinux" \
    org.label-schema.schema-version="1.1"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -qqy \
    bash \
    binutils \
    curl \
    dnsutils \
    gdb \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    locales \
    net-tools \
    ssmtp \
    sudo \
    tar \
    wget && \
    sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=pt_BR.UTF-8 && \
    cp -f /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.or && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

ENV LANG="pt_BR.UTF-8" \
    CS16_DOCKER="1" \
    DIR_STEAMCMD="/opt/steamcmd" \
    DIR_ROOT="/opt/steamcmd/games/cs16"

RUN groupadd -f -g 1000 steam && \
    useradd -o --shell /bin/bash -u 1000 -g 1000 -m steam && \
    echo "steam ALL=(ALL)NOPASSWD: ALL" >> etc/sudoers && \
    mkdir -p ${DIR_STEAMCMD} ${DIR_ROOT} && \
    curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -xvz -C ${DIR_STEAMCMD} && \
    chown -R steam. ${DIR_STEAMCMD} && \
    mkdir -p /home/steam/.steam/sdk32/ && \
    ln -s ${DIR_ROOT}/libsteam.so /home/steam/.steam/sdk32/libsteam.so

COPY cs16-server-launcher.sh /usr/bin/cs16-server-launcher
COPY cs16-server-launcher.conf /etc/cs16-server-launcher/cs16-server-launcher.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh /usr/bin/cs16-server-launcher && \
    chown -R steam. /etc/cs16-server-launcher

USER steam

EXPOSE 27015/udp 27015 27020/udp 26900/udp 27005 27005/udp 27030 27030/udp
WORKDIR "${DIR_ROOT}"
VOLUME [ "${DIR_ROOT}", "${DIR_STEAMCMD}" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "cs16-server-launcher", "start" ]