FROM continuumio/miniconda3:4.10.3p1

ENV HOME /home/lefse2
RUN mkdir /home/lefse2
WORKDIR /home/lefse2

RUN cd /opt && git clone https://github.com/zorbax/lefse.git 
RUN cd /opt/lefse && conda update -q -y conda
RUN conda install -q -yc conda-forge mamba
RUN mamba install -yc conda-forge numpy matplotlib rpy2 \
        r-survival r-mvtnorm r-modeltools r-coin r-mass
ENV PATH /opt/lefse:$PATH

VOLUME ["/data"]
WORKDIR /data
