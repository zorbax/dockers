FROM centos:centos7

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN groupadd fuse && \
    useradd --create-home --shell /bin/bash --user-group --uid 1000 --groups sudo,fuse ssb && \
    echo "ssb\nssb\n" | passwd ssb && chown ssb:ssb /data

RUN yum -y update; yum clean all && yum -y upgrade; yum clean all && \
    yum -y groupinstall "Development Tools" ; yum clean all

RUN yum -y install git wget java zlib-devel which perl-core perl-Archive-Tar perl-Digest-MD5 \
    perl-List-MoreUtils perl-Module-CoreList perl-File-Slurp perl-Test-Simple perl-Net-SSLeay perl-IO-Socket-SS ; yum clean all

RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm Bio::Perl && cpanm Bio::FeatureIO && \
              cpanm Statistics::Descriptive && cpanm LWP::Protocol::https

RUN cd /opt && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-1.x86_64.rpm && \
    rpm -Uvh ncbi-blast-2.7.1+-1.x86_64.rpm && rm -f ncbi-blast-2.7.1+-1.x86_64.rpm && \
    wget -q https://github.com/lskatz/lyve-SET/archive/v1.1.4g.tar.gz && \
    tar -zxvf v1.1.4g.tar.gz && rm -f v1.1.4g.tar.gz && cd lyve-SET-1.1.4g && \
    make install

ENV PATH=/opt/lyve-SET-1.1.4g/scripts:$PATH PERL5LIB=/opt/lyve-SET-1.1.4g/lib:$PERL5LIB

VOLUME /data

WORKDIR /data
