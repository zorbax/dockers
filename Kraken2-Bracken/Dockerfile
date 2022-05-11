FROM debian:11-slim

MAINTAINER @zorbax

ENV DEBIAN_FRONTEND noninteractive

ARG BRACKEN_VERSION=2.6.2

RUN apt-get update && apt install -y --no-install-recommends \
    build-essential ca-certificates git openssl wget \
    && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y \
    && apt-get clean

RUN mkdir -p /data /opt/Kraken2 \
    && git clone https://github.com/DerrickWood/kraken2.git \
    && cd kraken2 && ./install_kraken2.sh /opt/Kraken2 && rm -rf /kraken2

RUN wget https://github.com/jenniferlu717/Bracken/archive/refs/tags/v${BRACKEN_VERSION}.tar.gz \
    && tar -zxvf v${BRACKEN_VERSION}.tar.gz && rm v${BRACKEN_VERSION}.tar.gz \
    && cd Bracken-${BRACKEN_VERSION} && bash install_bracken.sh \
    && cd /opt && mv /Bracken-${BRACKEN_VERSION} .

ENV BKN_DIR /opt/Bracken-${BRACKEN_VERSION}
ENV KRK_DIR /opt/Kraken2
ENV PATH "${KRK_DIR}:${BKN_DIR}:${PATH}"
WORKDIR /data
CMD ["/bin/bash"]
