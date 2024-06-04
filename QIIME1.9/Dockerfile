FROM ubuntu:16.04

LABEL author Otoniel Maya <otto94@gmail.com>

#ARG DEBIAN_FRONTEND=noninteractive

#RUN apt-get update && apt-get install -y --no-install-recommends python-pip cython
#
#RUN apt-get update && apt-get install -y --no-install-recommends build-essential unzip jarwrapper cmake \
#     default-jre openjdk-8-jdk ant git wget curl openssl openssh-server python2.7-dev libtbb-dev libtool \
#     python-pip python-dev perl gcc g++ perl python automake make libdb-dev libxml2-dev \
#     zlib1g-dev bzip2 libncurses5-dev pkg-config libbz2-dev libcurl4-openssl-dev && apt-get clean

RUN apt-get update && apt-get install -y wget bzip2 libxext6 libsm6 libxrender1 libglib2.0-0 python2.7-dev \
    python-pip python-dev default-jdk libfreetype6-dev 

RUN echo "deb http://cran.r-project.org/bin/linux/ubuntu xenial/" > /etc/apt/sources.list.d/cran.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    apt-get update && apt-get install -y r-base r-base-core r-base-dev r-cran-rcurl

RUN cd /opt && wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH
ENV DISPLAY :0
RUN conda create -n qiime1 -y python=2.7

SHELL ["conda", "run", "-n", "qiime1", "/bin/bash", "-c"]

RUN pip install numpy && \
    conda install -yc bioconda biom-format && pip install qiime

#RUN mkdir -p $HOME/bin/qiime/lib/python2.7/site-packages/ && cd $HOME/bin/ \
#    wget https://github.com/biocore/qiime/archive/1.9.1.tar.gz && \
#    tar -zxvf 1.9.1.tar.gz && rm -f 1.9.1.tar.gz && \
#    cd qiime-1.9.1 && python setup.py build
#
#ENV PYTHONPATH=${PYTHONPATH}:$HOME/bin/qiime/lib/python2.7/site-packages/
#RUN cd /opt/qiime-1.9.1 && \
#    python setup.py install --prefix=$HOME/bin/qiime && \
#    rm -rf /opt/qiime-1.9.1

RUN pip install matplotlib==1.4.3 && \
	     echo "backend: Agg" > ~/.config/matplotlib/matplotlibrc
RUN mkdir -p /data && \
    cd /opt && wget https://datos16s.s3.us-east-2.amazonaws.com/usearch61.tar.gz \
    && tar -zxvf usearch61.tar.gz && rm -f usearch61.tar.gz && chmod +x usearch61

RUN mkdir -p /opt/temp && cd "$_" && \
    wget -O rdp.zip "https://downloads.sourceforge.net/project/rdp-classifier/rdp-classifier/rdp_classifier_2.2.zip?r=http%3A%2F%2Fqiime.org%2Finstall%2Falternative.html&ts=1489181761&use_mirror=svwh" && \
    unzip rdp.zip -d /opt && \
    rm rdp.zip

ENV PATH /opt:$PATH
VOLUME /data
WORKDIR /data
ENV RDP_JAR_PATH="/opt/rdp_classifier_2.2/rdp_classifier-2.2.jar"
ENV PATH /opt/miniconda3/envs/qiime1/bin:$PATH
CMD [ "/bin/bash" ]
