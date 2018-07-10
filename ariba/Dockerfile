FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN groupadd fuse && \
    useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo,fuse ssb && \
    echo "ssb\nssb\n" | passwd ssb && chown ssb:ssb /data

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential cd-hit curl \
    git libbz2-dev liblzma-dev mummer python python3-dev python3-setuptools \
    python3-pip python3-tk python3-matplotlib unzip wget zlib1g-dev

RUN cd /opt && \
    wget -q http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.2.9/bowtie2-2.2.9-linux-x86_64.zip && \
    unzip bowtie2-2.2.9-linux-x86_64.zip && rm bowtie2-2.2.9-linux-x86_64.zip

# Need MPLBACKEND="agg" to make matplotlib work without X11, otherwise get the error:
#     _tkinter.TclError: no display name and no $DISPLAY environment variable

ENV ARIBA_BOWTIE2=/opt/bowtie2-2.2.9/bowtie2 ARIBA_CDHIT=cdhit-est MPLBACKEND="agg"

RUN cd /opt && wget https://github.com/sanger-pathogens/ariba/archive/v2.12.1.tar.gz && \
    tar -zxvf v2.12.1.tar.gz && cd ariba-* && python3 setup.py install

USER ssb

VOLUME /data

CMD ["/bin/bash"]

WORKDIR /data
