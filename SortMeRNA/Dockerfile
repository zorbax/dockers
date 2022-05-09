FROM debian:11-slim

ARG SORTMERNA=4.3.4

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -qq && apt upgrade -y -qq && \
        apt install -y --no-install-recommends -qq \
        wget unzip ca-certificates

RUN mkdir -p /data /opt/SortMeRNA && \
        wget https://github.com/biocore/sortmerna/releases/download/v${SORTMERNA}/sortmerna-${SORTMERNA}-Linux.sh && \
        bash sortmerna-${SORTMERNA}-Linux.sh --prefix=/opt/SortMeRNA --exclude-subdir --skip-license && \
        rm -rf /sortmerna-${SORTMERNA}-Linux.sh

RUN echo 'alias ll="ls -ltrh"' >> ~/.bashrc
ENV PATH $PATH:/opt/SortMeRNA/bin
VOLUME /data
