FROM   ubuntu:18.04
MAINTAINER Otoniel Maya

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /data

RUN apt-get update && apt-get -yq install gnupg2 ca-certificates wget python-pip

RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get -yq install r-base r-base-dev

RUN R -e "install.packages(c('splines', 'stats4', 'survival', \
        'mvtnorm', 'modeltools', 'coin', 'MASS'), repos='http://cran.itam.mx/')"

RUN mkdir -p /opt/bin && cd /opt/bin && \
    wget https://bitbucket.org/nsegata/lefse/get/default.zip && \
    unzip default.zip && mv nsegata-lefse* LEfSe && rm default.zip

ENV PATH="/opt/bin/LEfSe:${PATH}"

RUN pip install rpy2==2.8.6 numpy==1.16.6 matplotlib==2.1.2 argparse

VOLUME /data
WORKDIR /data

