FROM debian:bullseye
MAINTAINER Otoniel Maya otto94@gmail.com
RUN apt-get update && apt-get install -y --no-install-recommends  \
    build-essential ca-certificates git openssl \
    && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y \
    && apt-get clean

RUN mkdir /{data,Kraken2} \
    && git clone https://github.com/DerrickWood/kraken2.git \
    && cd kraken2 && ./install_kraken2.sh /Kraken2

ENV KRK_DIR /Kraken2
ENV PATH "${KRK_DIR}:${PATH}"
WORKDIR /data
CMD ["/bin/bash"]
