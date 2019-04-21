FROM debian:stretch
MAINTAINER Otoniel Maya <otto94@gmail.com>

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    git wget sudo build-essential python-dev ca-certificates \
    r-base bzip2 unzip locales && apt-get clean

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

RUN wget https://git.io/fjOOL -O dependencies.R && \
    Rscript dependencies.R && rm dependencies.R

#RUN wget --quiet 
#https://github.com/krallin/tini/releases/download/v0.18.0/tini && 
#\
#    mv tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER atg
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p /opt/conda && chown atg /opt/conda

USER atg

mkdir -p /home/$NB_USER/{work,.local}

RUN cd /tmp && mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda-latest-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --yes conda

RUN conda install --yes --quiet \
    numpy matplotlib=1.4.3 pandas scipy ant && \
    conda install -c bioconda java-jdk && \
    conda install -c r r-base && conda clean -yt

RUN pip install --upgrade pip && pip install qiime

RUN mkdir -p $HOME/.config/matplotlib && \
    echo "backend: agg" > /home/$NB_USER/.config/matplotlib/matplotlibrc \
    && fc-cache -fv

WORKDIR /home/$NB_USER/work

# Use qiime-deploy to install all other dependencies
RUN cd && git clone https://github.com/qiime/qiime-deploy.git && \
    git clone https://github.com/qiime/qiime-deploy-conf.git

RUN cd ~/qiime-deploy && python qiime-deploy.py /opt/qiime_deps/ -f \
~/qiime-deploy-conf/qiime-1.9.1/qiime.conf \
--force-remove-failed-dirs

# create and set user for container
cd /opt
wget https://s3.us-east-2.amazonaws.com/datos16s/usearch61.tar.gz
tar -zxvf usearch61.tar.gz && rm -f usearch61.tar.gz
if [[ ! -x "usearch61" ]]
then
   chmod +x usearch61
fi

