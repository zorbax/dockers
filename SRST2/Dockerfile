FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN groupadd fuse && \
    useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo,fuse ssb && \
    echo "ssb\nssb\n" | passwd ssb && chown ssb:ssb /data

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends git python python-pip build-essential wget unzip \
    zlib1g-dev libncurses5-dev && pip install scipy setuptools

RUN cd /opt && wget -q 'https://downloads.sourceforge.net/project/samtools/samtools/0.1.18/samtools-0.1.18.tar.bz2' && \
    tar jxvf samtools-0.1.18.tar.bz2 && rm samtools-0.1.18.tar.bz2 && cd samtools-0.1.18 && make && \
    cp samtools /opt

RUN wget -q 'https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip' && \
    unzip bowtie2-2.1.0-linux-x86_64.zip && rm bowtie2-2.1.0-linux-x86_64.zip && \
    cp bowtie2-2.1.0/bowtie2* /opt

RUN git clone https://github.com/katholt/srst2 && pip install srst2/

ENV PATH=/opt:$PATH

USER ssb

VOLUME /data

WORKDIR /data


