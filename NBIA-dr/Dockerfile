FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get upgrade -y -qq && \
    apt install -y --no-install-recommends -qq \
    wget ca-certificates default-jre xdg-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/

ARG NBIAURL="https://cbiit-download.nci.nih.gov/nbia/releases/ForTCIA/"
RUN mkdir -p /usr/share/desktop-directories /data \
    && wget ${NBIAURL}/NBIADataRetriever_4.4.1/nbia-data-retriever-4.4.1.deb \
    && apt install ./nbia-data-retriever-4.4.1.deb \
    && rm /nbia-data-retriever*deb

ENV PATH $PATH:/opt/nbia-data-retriever

# VOLUME /data
