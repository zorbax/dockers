FROM centos:latest

RUN mkdir -p /data

RUN useradd -ms /bin/bash -U -u 1000 ssb && chown ssb:ssb /data

RUN yum -y groupinstall "Development Tools" && \
       yum -y update && yum -y install wget curl git && \
       yum -y install python-setuptools && \
       easy_install pip && pip install scif ipython

RUN cd /opt && git clone --recurse-submodules https://github.com/BU-ISCIII/plasmidID.git && \
    cp plasmidID/scif_app_recipes/* . && scif install plasmidid_v1.4.2_centos7.scif

ENTRYPOINT ["sh", "/opt/docker-entrypoint.sh"]

CMD ["plasmidID.sh"]

VOLUME /data

WORKDIR /data
