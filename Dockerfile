FROM debian:8

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -t jessie-backports install "gosu" \
    && apt-get install -y --no-install-recommends ca-certificates wget  \
                  subversion build-essential libncurses5-dev zlib1g-dev \
                  gawk git ccache gettext libssl-dev xsltproc file unzip \
                  python time\
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove\
    && rm -rf /var/lib/apt/lists/*

ADD etc/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh

# install the image builder. use tmpfile so that tar's compression
# autodetection works.
RUN mkdir -p /lede/imagebuilder && \
    wget  --progress=bar:force:noscroll "http://openwrt.tetaneutral.net/releases/18.06.1/targets/ar71xx/generic/openwrt-imagebuilder-18.06.1-ar71xx-generic.Linux-x86_64.tar.xz" -O /tmp/imagebuilder && \
      tar xf /tmp/imagebuilder --strip-components=1 -C /lede/imagebuilder &&\
      rm -f /tmp/imagebuilder


WORKDIR "/lede/imageb"
WORKDIR "/lede/imagebuilder"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
