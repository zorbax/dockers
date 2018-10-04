FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

RUN mkdir /data

RUN apt-get update && apt-get -y upgrade && apt-get install -y curl perl ca-certificates \
    build-essential zlib1g-dev apt-utils ncbi-blast+ cpanminus pkg-config \
    libgd2-xpm-dev libterm-readline-gnu-perl libfont-freetype-perl \
    && apt-get clean && apt-get -y autoremove

RUN curl -L https://git.io/fAluV -o /opt/circoletto.pl && chmod +x /opt/circoletto.pl \
    && cd /opt && curl -O http://circos.ca/distribution/circos-0.69-6.tgz && tar -zxvf circos-0.69-6.tgz \
    && cd /opt && curl -O http://circos.ca/distribution/circos-tools-0.22.tgz && tar -zxvf circos-tools-0.22.tgz

RUN cd /opt && curl -O http://circos.ca/distribution/lib/libpng-1.6.14.tar.gz \
    && tar xvfz libpng-1.6.14.tar.gz && rm libpng-1.6.14.tar.gz \
    && cd libpng-1.6.14 \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

RUN cd /opt && curl -O http://circos.ca/distribution/lib/jpegsrc.v9.tar.gz \
    && tar xvfz jpegsrc.v9.tar.gz && rm jpegsrc.v9.tar.gz \
    && cd jpeg-9 \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

RUN cd /opt && curl -O http://circos.ca/distribution/lib/freetype-2.4.0.tar.gz \
    && tar xvfz freetype-2.4.0.tar.gz && rm freetype-2.4.0.tar.gz \
    && cd freetype-2.4.0 \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

RUN cd /opt && curl -O http://circos.ca/distribution/lib/libgd-2.1.0.tar.gz \
    && tar -zxvf libgd-2.1.0.tar.gz && rm libgd-2.1.0.tar.gz \
    && cd libgd-2.1.0 && sed -i 's/IMG_FMT_I420/VPX_IMG_FMT_I420/; s/PLANE/VPX_PLANE/' src/webpimg.c \
    && ./configure --with-png=/usr/local --with-freetype=/usr/local --with-jpeg=/usr/local --prefix=/usr/local \
    && make && make install

RUN /usr/local/bin/gdlib-config --all && rm /opt/*gz

RUN cpanm Config::General Font::TTF::Font GD GD::Polyline Math::Bezier Math::Round Math::VecStat \
    Font::Freetype Params::Validate Readonly Regexp::Common SVG Set::IntSpan Statistics::Basic \
    Text::Format List::MoreUtils Math::VecStat Bio::SearchIO Clone

RUN cd /opt && rm -rf libpng-1.6.14 jpeg-9 freetype-2.4.0 libgd-2.1.0

ENV PATH=/opt:$PATH

VOLUME /data

WORKDIR /data

