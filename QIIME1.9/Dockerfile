FROM continuumio/anaconda:5.0.0

MAINTAINER Otoniel Maya <otto94@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends default-jdk \
       build-essential unzip r-base r-base-dev gfortran pkg-config libfreetype6-dev

RUN conda create -y -n qiime1.9 python=2.7 
ENV PATH /opt/conda/envs/qiime1.9/bin:$PATH
RUN /bin/bash -c "source activate qiime1.9"
RUN conda install -y numpy && \
    conda install -y -c bioconda biom-format scipy pandas && \
    conda install -y -c bioconda 'scikit-bio==0.2.3' 'cogent==1.5.3' && \
    conda install -y 'matplotlib==1.4.3'

RUN cd /opt && mkdir -p /opt/qiime/lib/python2.7/site-packages/ && \ 
    wget https://github.com/biocore/qiime/archive/1.9.1.tar.gz && \
    tar -zxvf 1.9.1.tar.gz && rm -f 1.9.1.tar.gz && \
    cd qiime-1.9.1 && python setup.py build

ENV PYTHONPATH=${PYTHONPATH}:/opt/qiime/lib/python2.7/site-packages/
RUN python setup.py install --prefix=/opt/qiime && \
    cd .. && rm -rf qiime-1.9.1

RUN mkdir -p /opt/tmp/ /work && \
    cd /opt/tmp && \
    wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.22/ncbi-blast-2.2.22+-x64-linux.tar.gz && \
    tar -xzvf ncbi-blast-2.2.22+-x64-linux.tar.gz -C /opt && \
    rm ncbi-blast-2.2.22+-x64-linux.tar.gz
    
RUN cd /opt/tmp && \
    wget -O rdp.zip "https://downloads.sourceforge.net/project/rdp-classifier/rdp-classifier/rdp_classifier_2.2.zip?r=http%3A%2F%2Fqiime.org%2Finstall%2Falternative.html&ts=1489181761&use_mirror=svwh" && \
    unzip rdp.zip -d /opt && \
    rm rdp.zip

RUN cd /opt/tmp && \
    wget -O microbio.tar.gz  "https://downloads.sourceforge.net/project/microbiomeutil/__OLD_VERSIONS/microbiomeutil_2010-04-29.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmicrobiomeutil%2Ffiles%2F__OLD_VERSIONS%2F&ts=1489182721&use_mirror=svwh" && \
    tar -xzvf microbio.tar.gz -C /opt && \
    rm microbio.tar.gz

RUN cd /opt && wget https://s3.us-east-2.amazonaws.com/datos16s/usearch61.tar.gz \
    && tar -zxvf usearch61.tar.gz && rm -f usearch61.tar.gz && chmod +x usearch61

ENV RDP_JAR_PATH="/opt/rdp_classifier_2.2/rdp_classifier-2.2.jar"

ENV PATH="/opt/ncbi-blast-2.2.22+/bin:/opt/microbiomeutil_2010-04-29/ChimeraSlayer:${PATH}"

WORKDIR /work

RUN echo "source activate qiime1.9" > ~/.bashrc
ENV PATH /opt/qiime/bin:$PATH PYTHONPATH=${PYTHONPATH}:/opt/qiime/lib/python2.7/site-packages/ 
CMD [ "/bin/bash" ]

