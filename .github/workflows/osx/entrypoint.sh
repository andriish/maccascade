#!/bin/sh -l
set -x
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils root hepmc pythia8 lhapdf gsl automake zlib gfortran
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
./configure  --with-hepmc=/usr/local --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-pythia8=/usr/local --with-gsl=/usr/local

