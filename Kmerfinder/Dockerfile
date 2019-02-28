FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq; \
    apt-get install -y -qq git \
    apt-utils \
    wget \
    python3-pip \
    libz-dev \
    ; \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND Teletype

RUN git clone --branch 1.0.1 --depth 1 https://bitbucket.org/genomicepidemiology/kma.git; \
    cd kma && make; \
    mv kma* /bin/

COPY ./kmerfinder.py /usr/src/kmerfinder.py

RUN chmod 755 /usr/src/kmerfinder.py

ENV PATH $PATH:/usr/src

WORKDIR /workdir

ENTRYPOINT ["/usr/src/kmerfinder.py"]
