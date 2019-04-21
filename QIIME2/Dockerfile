FROM continuumio/miniconda3
#Version 2019.1

ENV PATH /opt/conda/envs/qiime2-2019.1/bin:$PATH
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg
ENV HOME /home/qiime2
ENV XDG_CONFIG_HOME /home/qiime2

RUN mkdir /home/qiime2
WORKDIR /home/qiime2

RUN conda update -q -y conda
RUN conda install -q -y wget
RUN wget https://data.qiime2.org/distro/core/qiime2-2019.1-py36-linux-conda.yml
RUN conda env create -n qiime2-2019.1 --file qiime2-2019.1-py36-linux-conda.yml
RUN rm qiime2-2019.1-py36-linux-conda.yml
RUN /bin/bash -c "source activate qiime2-2019.1"
RUN qiime dev refresh-cache
RUN echo "source activate qiime2-2019.1" >> $HOME/.bashrc
RUN echo "source tab-qiime" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
