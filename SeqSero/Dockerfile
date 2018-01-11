FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN groupadd fuse && \
    useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo,fuse ssb && \
    echo "ssb\nssb\n" | passwd ssb && chown ssb:ssb /data

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends build-essential git python python-pip \ 
            zlib1g-dev wget libncurses5-dev libncursesw5-dev samtools ncbi-blast+ && \
    pip install biopython && \
    cd /opt && git clone https://github.com/CNRDOGM/SeqSero.git && \
    ln -s SeqSero/SeqSero.py . && \
    cd /opt && \
    git clone https://github.com/lh3/bwa.git BWA && \
    cd BWA && make && cd .. && ln BWA/bwa .

ENV PATH=/opt:$PATH

USER ssb

VOLUME /data

WORKDIR /data
