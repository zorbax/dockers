FROM continuumio/miniconda3

ENV PATH /opt/conda/envs/qiime2-2021.11/bin:$PATH
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg
ENV HOME /home/qiime2
ENV XDG_CONFIG_HOME /home/qiime2

RUN mkdir /home/qiime2
WORKDIR /home/qiime2

RUN conda update -q -y conda \
    && conda install -q -y wget \
    && conda install -q -yc conda-forge mamba \
    && wget https://data.qiime2.org/distro/core/qiime2-2021.11-py38-linux-conda.yml \
    && mamba env create -n qiime2-2021.11 --file qiime2-2021.11-py38-linux-conda.yml \
    && rm qiime2-2021.11-py38-linux-conda.yml
RUN /bin/bash -c "source activate qiime2-2021.11" && qiime dev refresh-cache
RUN echo "source activate qiime2-2021.11" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
