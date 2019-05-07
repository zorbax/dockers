FROM debian:stretch
MAINTAINER Otoniel Maya <otto94@gmail.com>

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    git wget sudo build-essential python-dev ca-certificates \
    bzip2 unzip locales fontconfig libmpc-dev libncurses5-dev \
    libssl-dev libzmq-dev libgsl0-dev openjdk-6-jdk libxml2 \
    libxslt1.1 libxslt1-dev ant zlib1g-dev libpng12-dev \
    libfreetype6-dev mpich2 libreadline-dev gfortran \
    libmysqlclient16 libmysqlclient-dev ghc sqlite3 \
    libsqlite3-dev libbz2-dev tcl-dev tk-dev r-base \
    r-base-dev libatlas-dev libatlas-base-dev \
    liblapack-dev swig libhdf5-serial-dev && apt-get clean

ENV PATH /opt/miniconda/bin:$PATH /opt
ENV SHELL /bin/bash
ENV NB_USER atg
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p /opt/miniconda /home/$NB_USER/{work,.local} && \
    chown atg /opt/miniconda

USER atg

RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -f -b -p /opt/miniconda && \
    rm Miniconda-latest-Linux-x86_64.sh && \
    /opt/miniconda/bin/conda install --yes conda

RUN conda install -y -q \
    numpy matplotlib=1.4.3 pandas scipy ant && \
    conda install -y -c bioconda java-jdk &&
    conda install -y -c anaconda openjdk && \
    conda install -y -c r r-base && conda clean -yt

RUN conda install -y -c bioconda qiime

RUN mkdir -p $HOME/.config/matplotlib && \
    echo "backend: agg" > /home/$NB_USER/.config/matplotlib/matplotlibrc \
    && fc-cache -fv

WORKDIR /home/$NB_USER/work

USER root

RUN cd /opt && git clone https://github.com/CNRDOGM/qiime-deploy.git && \
    git clone https://github.com/CNRDOGM/qiime-deploy-conf.git

RUN mkdir qiime && python qiime-deploy/qiime-deploy.py /opt/qiime \
      -f /opt/qiime-deploy-conf/qiime-1.9.1/qiime.conf \
      --force-remove-failed-dirs && rm -rf /opt/{qiime-deploy,qiime-deploy-conf}

RUN source $QIIME_HOME/qiime_software/$QIIME_VERSION
RUN source $QIIME_PREFIX/activate.sh

cd /opt
wget https://s3.us-east-2.amazonaws.com/datos16s/usearch61.tar.gz
tar -zxvf usearch61.tar.gz && rm -f usearch61.tar.gz
if [[ ! -x "usearch61" ]]
then
   chmod +x usearch61
fi

PATH /opt
