FROM debian:11-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -qq && apt upgrade -y -qq && \
        apt install -y --no-install-recommends -qq \
        wget unzip ca-certificates cpanminus libfontconfig

RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

ENV PATH="/root/.TinyTeX/bin/x86_64-linux:${PATH}"

RUN tlmgr install enumitem ragged2e fancyhdr xifthen ifmtarg setspace \
        fontawesome5 sourcesanspro tcolorbox pgf environ parskip roboto \
        bookmark biblatex biber tikzfill

RUN echo 'alias ll="ls -ltrh"' >> ~/.bashrc
VOLUME /data
