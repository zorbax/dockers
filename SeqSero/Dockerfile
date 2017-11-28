FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir -p /home/bin && echo 'export PATH=/home/bin:$PATH' >> $HOME/.bashrc && source $HOME/.bashrc
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y git python python-pip zlib1g-dev wget libncurses5-dev libncursesw5-dev && \
    pip install biopython && \
    cd /home/bin && git clone https://github.com/denglab/SeqSero.git && \
    ln -s SeqSero/SeqSero.py . && \
    cd /home/bin && \
    git clone https://github.com/lh3/bwa.git BWA && \
    cd BWA && make && cd .. && ln BWA/bwa . && \
    wget 'https://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2'  && \
    tar jxvf samtools-0.1.19.tar.bz2 && rm samtools-0.1.19.tar.bz2 && \
    cd samtools-0.1.19; make && \
    cd .. && ln -s samtools-0.1.19/samtools . 
