FROM centos:centos7

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN yum -y update; yum clean all && yum -y upgrade; yum clean all && \
    yum -y groupinstall "Development Tools" ; yum clean all

RUN yum -y install git wget java zlib-devel which perl-core perl-Archive-Tar perl-Digest-MD5 \
    perl-List-MoreUtils perl-Module-CoreList perl-File-Slurp perl-Test-Simple ; yum clean all

RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm Bio::Perl && cpanm Bio::FeatureIO && \
                  cpanm Statistics::Descriptive && cpanm LWP::Protocol::https

RUN cd /opt && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-1.x86_64.rpm && \
    rpm -Uvh ncbi-blast-2.7.1+-1.x86_64.rpm && rm -f ncbi-blast-2.7.1+-1.x86_64.rpm && \
    wget -q https://github.com/lskatz/lyve-SET/archive/v2.0.1.tar.gz && \
    tar -zxvf v2.0.1.tar.gz && rm -f v2.0.1.tar.gz && cd cd lyve-SET-2.0.1 && \
    make install

ENV PATH=/opt/lyve-SET-2.0.1/scripts:$PATH PERL5LIB=/opt/lyve-SET-2.0.1/lib:$PERL5LIB

VOLUME /data

WORKDIR /data
