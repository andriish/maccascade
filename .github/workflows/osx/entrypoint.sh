#!/bin/sh -l
set -x
export TOP=$(pwd)
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  
brew install gsl
brew install gnu-sed
brew install gcc
brew install cmake
brew install zlib 
brew install autoconf 
brew install automake 
brew install libtool 
brew install pkg-config
brew install --cask basictex
eval "$(/usr/libexec/path_helper)"
export PATH=$PATH:/usr/local/bin:/usr/local//Cellar/gcc/11.1.0_1/libexec/gcc/x86_64-apple-darwin19/11.1.0/:/Library/TeX/texbin/
sudo tlmgr update --self
sudo tlmgr install sectsty collection-fontsrecommended
#####

which gfortran-11
if [ "$?" = "0" ]; then 
   export CXX=g++-11
   export CC=gcc-11
   export FC=gfortran-11
   export F77=gfortran-11
   export LD=gfortran-11
else
   export CXX=g++
   export CC=gcc
   export FC=gfortran
   export F77=gfortran
   export LD=gfortran
fi
export CXXFLAGS=-std=c++14
cp /usr/local/bin/gfortran-11 /usr/local/bin/gfortran
########
wget  https://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.1.tar.gz
tar zxvf LHAPDF-6.2.1.tar.gz
cd LHAPDF-6.2.1
./configure --prefix=/usr/local
make -j 2  install
cd ..
########
wget https://tmdlib.hepforge.org/downloads/tmdlib-2.2.01.tar.gz
tar zxfv tmdlib-2.2.01.tar.gz 
cd tmdlib-2.2.01
cp $TOP/tmdlib/matrix.h apfelxx/inc/apfel/matrix.h
./configure --with-lhapdf=/usr/local
make -j 2 
make install
cd ..
###########
wget https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz
tar zxfv HepMC-2.06.11.tar.gz
cmake -SHepMC-2.06.11 -BbuildHepMC-2.06.11 -Dmomentum=GEV -Dlength=MM
make -j 2 -C buildHepMC-2.06.11
make install -C buildHepMC-2.06.11
cd ..
#############
wget https://pythia.org/download/pythia82/pythia8243.tgz
tar zxfv pythia8243.tgz
cd pythia8243
./configure --refix=/usr/local --enable-shared
make -j 2
make install
cd ..
#################
brew install root
git clone https://gitlab.cern.ch/averbyts/cascade
cd cascade
git checkout master
autoreconf -fisv
#this will enable hepmc3 only if it is present
./configure --prefix=$(pwd)/TESTINSTALLDIR --with-hepmc2=/usr/local --with-hepmc3=/usr/local  --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-zlib=/usr/local/opt/zlib --with-gsl=/usr/local --with-pythia8=/usr/local 
make -j 2 LD=$LD
make install LD=$LD
TMDlib-getdata PB-NLO-HERAI+II-2018-set2
cp TESTINSTALLDIR/share/cascade/LHE/POWHEG-example.lhe ./
export HEPMCOUT=output.hepmc


export DYLD_PRINT_LIBRARIES=1
export DYLD_PRINT_LIBRARIES_POST_LAUNCH=1
export DYLD_PRINT_RPATHS=1
export HEPMCOUT=output.hepmc
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$(pwd)/TESTINSTALLDIR/lib
ls -lah TESTINSTALLDIR/bin/cascade
xattr TESTINSTALLDIR/bin/cascade
otool -L  TESTINSTALLDIR/bin/cascade





TESTINSTALLDIR/bin/cascade < TESTINSTALLDIR//share/cascade/LHE/steering-DY-PH.txt
head -n 40 output.hepmc*

