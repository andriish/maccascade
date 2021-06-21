#!/bin/sh -l
set -x
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  hepmc pythia8  gsl 
brew install --cask gfortran
brew install gcc
brew install lhapdf
brew install zlib 
brew install autoconf 
brew install automake 
brew install libtool 
brew install pkg-config
export PATH=$PATH:/usr/local/bin
ls /usr/local/bin
which -a gfortran
 which gfortran-11
 if [ "$?" = "0" ]; then 
   export FC=gfortran-11
 else
   export FC=gfortran
 fi
cp /usr/local/bin/gfortran-11 /usr/local/bin/gfortran
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

