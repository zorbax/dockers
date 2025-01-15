FROM debian:12-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
    && apt-get upgrade -qq \
    && apt-get install --no-install-recommends -qq \
    wget unzip ca-certificates cpanminus libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

ENV PATH="${PATH}:/root/bin"

RUN tlmgr install enumitem ragged2e fancyhdr xifthen ifmtarg setspace \
    fontawesome5 sourcesanspro tcolorbox pgf environ parskip roboto \
    bookmark biblatex biber tikzfill

VOLUME /data

USER zorbax