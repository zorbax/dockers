FROM centos:7

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN yum -y install wget unzip && \
    cd /tmp && \
    wget -q --no-check-certificate \
    https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-linux-x86-64.zip && \
    unzip *.zip && \
    yum -y --nogpgcheck localinstall /tmp/bcl2fastq2-*.rpm && \
    yum -y remove wget unzip && \
    rm -rf /tmp/{*.rpm,*zip}


