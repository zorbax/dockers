FROM debian:stretch

MAINTAINER Otoniel Maya <otto94@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /data

apt-get install openjdk-8-jre-headless git wget 

cd /opt && wget -q 'https://downloads.sourceforge.net/project/samtools/samtools/0.1.18/samtools-0.1.18.tar.bz2' && \
    tar jxvf samtools-0.1.18.tar.bz2 && rm samtools-0.1.18.tar.bz2 && cd samtools-0.1.18 && make && \
    cp samtools /opt








cd $HOME/bin
wget wget https://github.com/jts/sga/archive/v0.10.15.tar.gz
tar -xzvf v0.10.15.tar.gz && rm v0.10.15.tar.gz
mkdir $HOME/bin/SGE
cd sga-0.10.15/src && ./autogen.sh
./configure --with-bamtools=$HOME/bin/Bamtools --with-jemalloc --with-sparsehash --prefix=$HOME/bin/SGE
make && make install
cd && rm -rf $HOME/bin/sga-0.10.15
echo 'export PATH=$HOME/bin/SGE/bin:$PATH' >> $HOME/.bashrc


cd $HOME/bin
mkdir -p $HOME/bin/IDBA
git clone https://github.com/loneknightpy/idba.git
cd idba && ./build.sh
shopt -s extglob
cp bin/idba!(*o) $HOME/bin/IDBA
shopt -u extglob
cd && rm -rf $HOME/bin/idba

cd $HOME/bin
git clone https://github.com/loneknightpy/idba.git
cd idba/src/
sed -i '102s/.*/    static const uint32_t kMaxShortSequence = 512;/' sequence/short_sequence.h
sed -i '408s/.*/    if (median < 0 || median != median || sd != sd || sd > 10*median)/' release/idba_ud.cpp
sed -i '410s/.*/        cout << "invalid insert distance. median " << median << " sd " << sd << endl;/' release/idba_ud.cpp
sed -i '553s/.*/    if (median < 0 || median != median || sd != sd || sd > 10*median)/' release/idba_ud.cpp
sed -i '555s/.*/        cout << "invalid insert distance. median " << median << " sd " << sd << endl;/' release/idba_ud.cpp
sed -i '200s/.*/    static const uint32_t kNumUint64 = 16;/' basic/kmer.h
cd ..
./build.sh
cp bin/idba $HOME/bin/IDBA/idba500
cp bin/idba_hybrid $HOME/bin/IDBA/idba_hybrid500
cp bin/idba_tran $HOME/bin/IDBA/idba_tran500
cp bin/idba_tran_test $HOME/bin/IDBA/idba_tran_test500
cp bin/idba_ud $HOME/bin/IDBA/idba_ud500
cd && rm -rf $HOME/bin/idba
echo 'export PATH=$HOME/bin/IDBA:$PATH' >> $HOME/.bashrc


cd $HOME/bin
#wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz
wget https://s3-us-west-1.amazonaws.com/data-unix/SPAdes-3.11.1.tar.gz
tar -zxvf SPAdes-3.11.1.tar.gz && rm SPAdes-3.11.1.tar.gz
cd SPAdes-3.11.1 && ./spades_compile.sh
echo 'export PATH=$HOME/bin/SPAdes-3.11.1/bin:$PATH' >> $HOME/.bashrc
source $HOME/.bashrc
