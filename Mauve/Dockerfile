FROM ubuntu:16.04

LABEL mantainer @zorbax

ENV DEBIAN_FRONTEND=noninteractive  

RUN apt-get update && apt-get -y install mauve-aligner wget default-jre

ARG MAUVE_URL="http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64"

RUN wget ${MAUVE_URL}/mauve_linux_snapshot_2015-02-13.tar.gz \
	&& tar -zxvf mauve_linux_snapshot_2015-02-13.tar.gz \
	&& rm mauve_linux_snapshot_2015-02-13.tar.gz \
	&& ln -s /mauve_snapshot_2015-02-13/ /mauve

RUN echo "#!/bin/bash\njava -Xmx8G -cp /mauve/Mauve.jar org.gel.mauve.contigs.ContigOrderer \$@" \
	> /usr/bin/mauveContigOrderer \
	&& chmod 755 /usr/bin/mauveContigOrderer

WORKDIR /data

ENV PATH /mauve:$PATH
ENV JAVA_CMD /usr/lib/jvm/java-8-openjdk-amd64/bin/java
