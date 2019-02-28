FROM ubuntu:16.04
MAINTAINER otto94@gmail.com

RUN apt update && \
	apt-get install -y build-essential wget unzip && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get install -y mailutils

RUN mkdir /data
WORKDIR /data

RUN cd /usr/ && \
	wget 
http://vm-lux.embl.de/~kultima/share/MOCAT/v2.0/MOCAT2-lite.zip && \
	unzip MOCAT2-lite.zip && \
	rm MOCAT2-lite.zip && \
	cd /usr/MOCAT && \
	echo yes | perl setup.MOCAT.pl && \
	rm -r /usr/MOCAT/data && \
	mkdir /usr/MOCAT/data && \
	sed -i "s/EMAIL=''/EMAIL='\$EMAIL'/" 
/usr/MOCAT/src/runMOCAT.sh
runMOCAT.sh

ENV PATH="${PATH}:/usr/MOCAT/src"
