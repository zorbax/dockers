FROM continuumio/miniconda3

ENV PATH /opt/conda/envs/kofam/bin:$PATH
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN conda update -q -y conda \
    && conda install -q -yc conda-forge mamba \
    && mamba create -n kofam -yc bioconda kofamscan
RUN echo "source activate kofam" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
