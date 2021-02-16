FROM continuumio/miniconda3:latest

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
RUN echo '\n\
function _update_ps1() {\n\
    PS1=$(powerline-shell $?)\n\
    }\n\
if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]\n\
then \n\
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"\n\
fi\n\
' >>  /etc/profile

COPY jupyterhub_config.py /

# Create admin user
RUN useradd -ms /bin/bash atgenomics

# Setup application
EXPOSE 8000 

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]
