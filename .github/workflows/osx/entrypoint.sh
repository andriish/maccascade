#!/bin/sh -l
set -x
brew tap davidchall/hep
brew install wget coreutils root hepmc pythia8 lhapdf gsl automake
git clone https://gitlab.cern.ch/averbyts/cascade
cd cascade
git checkout CI
autoreconf -fisv
./configure  --with-hepmc=/usr/local --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-pythia8=/usr/local --with-gsl=/usr/local

