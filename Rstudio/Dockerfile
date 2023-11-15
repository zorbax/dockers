FROM debian:12-slim

ENV CRAN=https://packagemanager.posit.co/cran/__linux__/bookworm/latest
ENV DEFAULT_USER=rstudio
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV RSTUDIO_VERSION=2023.06.1+524
ENV R_HOME=/usr/local/lib/R
ENV R_VERSION=4.3.1
ENV S6_VERSION=v3.1.5.0
ENV TERM=xterm
ENV TZ=Etc/UTC

ADD scripts /opt/

#CMD ["R"]

RUN bash /opt/install_rstudio.sh ${R_VERSION}

EXPOSE 8787

CMD ["/init"]

