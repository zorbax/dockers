FROM debian:12-slim

ARG SPADES_VER="3.15.5"

LABEL software="SPAdes"
LABEL software.version="${SPADES_VER}"
LABEL maintainer="@zorbax"

RUN apt-get update -qq \
	&& apt-get upgrade -qq -y \
	&& apt-get install --no-install-recommends -y python3 python3-distutils \
		wget pigz ca-certificates \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10

ARG SPADES_URL="http://cab.spbu.ru/files/release${SPADES_VER}/SPAdes-${SPADES_VER}-Linux.tar.gz"
RUN wget --no-check-certificate ${SPADES_URL} \
    && tar -xzf SPAdes-${SPADES_VER}-Linux.tar.gz \
    && rm -r SPAdes-${SPADES_VER}-Linux.tar.gz \
    && mkdir /data

ENV LC_ALL=C.UTF-8
ENV PATH="${PATH}:/SPAdes-${SPADES_VER}-Linux/bin"

WORKDIR /data

