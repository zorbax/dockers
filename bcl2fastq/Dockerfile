FROM rockylinux:8.5

MAINTAINER @zorbax

# download rpm file from:
# https://emea.support.illumina.com/downloads/bcl2fastq-conversion-software-v2-20.html

COPY bcl2fastq2-v2-20-0-linux-x86-64.zip /tmp

RUN dnf -y install unzip && \
    cd /tmp && unzip bcl2fastq2-v2-20-0-linux-x86-64.zip && \
    dnf -y --nogpgcheck localinstall /tmp/bcl2fastq2-*.rpm && rm -rf /tmp/{*.rpm,*zip}

