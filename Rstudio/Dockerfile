FROM ubuntu:focal

ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ENV DEFAULT_USER=rstudio
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV RSTUDIO_VERSION=2022.07.1+554
ENV R_HOME=/usr/local/lib/R
ENV R_VERSION=4.2.1
ENV S6_VERSION=v2.1.0.2
ENV TERM=xterm
ENV TZ=Etc/UTC

ADD scripts /opt/

#CMD ["R"]

RUN bash /opt/install_rstudio.sh ${R_VERSION}

EXPOSE 8787

CMD ["/init"]

