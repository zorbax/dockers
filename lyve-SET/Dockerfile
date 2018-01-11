FROM centos:centos7

MAINTAINER Otoniel Maya <otto94@gmail.com>


RUN yum -y update; yum clean all
RUN yum -y upgrade; yum clean all
RUN yum -y groupinstall "Development Tools" ; yum clean all
RUN yum -y install git wget zlib-devel which perl-Archive-Tar perl-Digest-MD5 \
    perl-List-MoreUtils perl-Module-CoreList perl-File-Slurp perl-Test-Simple ; yum clean all
RUN cd /opt && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-1.x86_64.rpm && \
    rpm -Uvh ncbi-blast-2.7.1+-1.x86_64.rpm && rm -f ncbi-blast-2.7.1+-1.x86_64.rpm && \
    wget https://github.com/lskatz/lyve-SET/archive/v1.1.4g.tar.gz && \
    tar -zxvf v1.1.4g.tar.gz && rm -f v1.1.4g.tar.gz && cd lyve-SET-1.1.4g && \
    make install

ENV PATH=/opt/lyve-SET-1.1.4g/scripts PERL5LIB=/opt/lyve-SET-1.1.4g/lib
