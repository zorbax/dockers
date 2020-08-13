FROM continuumio/anaconda:5.0.0

MAINTAINER Otoniel Maya <otto94@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends default-jdk cmake \
       build-essential unzip r-base python-qt4 r-base-dev libqt4-dev\
       pkg-config libfreetype6-dev libxml2-dev libxslt-dev python-dev

RUN conda create -y -n qiime1.9 python=2.7
ENV PATH /opt/conda/envs/qiime1.9/bin:$PATH
RUN /bin/bash -c "source activate qiime1.9"
RUN pip install cython pyside && \
    pip install setuptools numpy && \
    pip install scipy pandas && \
    conda install -y -c bioconda biom-format && \
    conda install -y -c conda-forge 'icu=56.*' && \
    pip install 'scikit-bio==0.2.3' 'cogent==1.5.3' 'matplotlib==1.4.3'

RUN mkdir -p $HOME/bin/qiime/lib/python2.7/site-packages/ && cd $HOME/bin/ \
    wget https://github.com/biocore/qiime/archive/1.9.1.tar.gz && \
    tar -zxvf 1.9.1.tar.gz && rm -f 1.9.1.tar.gz && \
    cd qiime-1.9.1 && python setup.py build

ENV PYTHONPATH=${PYTHONPATH}:$HOME/bin/qiime/lib/python2.7/site-packages/
RUN cd /opt/qiime-1.9.1 && \
    python setup.py install --prefix=$HOME/bin/qiime && \
    rm -rf /opt/qiime-1.9.1

RUN mkdir -p /opt/tmp/ /work && \
    cd /opt && wget https://datos16s.s3.us-east-2.amazonaws.com/usearch61.tar.gz \
    && tar -zxvf usearch61.tar.gz && rm -f usearch61.tar.gz && chmod +x usearch61

VOLUME /work
WORKDIR /work

RUN echo "source activate qiime1.9" > ~/.bashrc
ENV PATH /opt/qiime/bin:$PATH PYTHONPATH=${PYTHONPATH}:/opt/qiime/lib/python2.7/site-packages/
CMD [ "/bin/bash" ]
