FROM continuumio/miniconda3:latest

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    git texlive texlive-fonts-recommended unzip vim \
    texlive-plain-generic texlive-xetex && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Install conda and Jupyter
RUN conda update -y conda
RUN conda install -c conda-forge \
    jupyterhub jupyterlab numpy matplotlib pandas seaborn r-essentials \
        scipy pingouin && conda clean -ay

RUN pip3 install powerline-shell

COPY ./jupyterhub_config.py /
COPY ./profile /etc/profile
COPY ./dircolors /etc/dircolors

# Create admin user
RUN useradd -ms /bin/bash atgenomics

# Setup application
EXPOSE 8000

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]
