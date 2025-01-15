FROM debian:12-slim

LABEL maintainer="@zorbax"

RUN mkdir /data

ENV DEBIAN_FRONTEND noninteractive \
    BOWTIE2_VERSION 2.3.1 \
    SPADES_VERSION 3.13.1

RUN groupadd fuse && \
    useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo,fuse ssb && \
    echo "ssb\nssb\n" | passwd ssb && chown ssb:ssb /data

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential cd-hit curl \
    git libbz2-dev liblzma-dev mummer python3-dev python3-setuptools \
    python3-pip python3-tk python3-matplotlib unzip wget zlib1g-dev

RUN cd /opt && \
    wget -q http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && \
    unzip bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip && rm bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip

# Need MPLBACKEND="agg" to make matplotlib work without X11, otherwise get the error:
#     _tkinter.TclError: no display name and no $DISPLAY environment variable

ENV ARIBA_BOWTIE2=/opt/bowtie2-${BOWTIE2_VERSION}/bowtie2 ARIBA_CDHIT=cdhit-est MPLBACKEND="agg"

RUN cd /opt && wget https://github.com/sanger-pathogens/ariba/archive/v2.12.1.tar.gz && \
    tar -zxvf v2.12.1.tar.gz && cd ariba-* && python3 setup.py install

RUN cd /opt && \
    wget -q https://github.com/ablab/spades/releases/download/v${SPADES_VERSION}/SPAdes-${SPADES_VERSION}-Linux.tar.gz && \
    tar xf SPAdes-${SPADES_VERSION}-Linux.tar.gz && \
    rm SPAdes-${SPADES_VERSION}-Linux.tar.gz && \
    mv SPAdes-${SPADES_VERSION}-Linux SPAdes

ENV PATH /opt/SPAdes/bin:$PATH
USER ssb

VOLUME /data

CMD ["/bin/bash"]

WORKDIR /data
