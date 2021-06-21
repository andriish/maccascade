#!/bin/sh -l
set -x
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  hepmc pythia8 lhapdf gsl autoconf automake libtool  zlib gcc
brew install autoconf automake libtool pkg-config
export PATH=$PATH:/usr/local/bin
ls /usr/bin/local
which -a gfortran
 which gfortran-11
 if [ "$?" = "0" ]; then 
   export FC=gfortran-11
 else
   export FC=gfortran
 fi
wget https://tmdlib.hepforge.org/downloads/tmdlib-2.2.01.tar.gz
tar zxfv tmdlib-2.2.01.tar.gz
ls 
cd tmdlib-2.2.01
./configure --with-lhapdf=/usr/local
make -j 2 
make install
cd ..
git clone https://gitlab.cern.ch/averbyts/cascade
cd cascade
git checkout CI
autoreconf -fisv
./configure  --with-hepmc=/usr/local --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-pythia8=/usr/local --with-zlib=/usr/local --with-gsl=/usr/local

