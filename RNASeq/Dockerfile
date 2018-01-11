FROM debian:stretch
MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN apt-get update && apt-get -y install build-essential curl htop unzip apache2 supervisor \
     default-jre wget git ftp nano python-dev python-pip openssl openssh-server \
     perl gcc g++ perl python automake make git libdb-dev zlib1g-dev bzip2 libncurses5-dev && apt-get clean

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm install DBD::SQLite
RUN cpanm install XML::Simple
RUN cpanm install CGI
RUN cpanm install HTML::Template
RUN cpanm install DB_File
RUN cpanm install URI::Escape

RUN apt-get update && apt-get install -y --no-install-recommends ed \
    less locales ca-certificates fonts-texgyre && rm -rf /var/lib/apt/lists/*
