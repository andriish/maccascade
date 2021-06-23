#!/bin/sh -l
set -x
export TOP=$(pwd)
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  
brew install hepmc 
brew install hepmc3 
brew install gsl
brew install gnu-sed
brew install gcc
brew install --build-from-source lhapdf
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

which gfortran-11
if [ "$?" = "0" ]; then 
   export FC=gfortran-11
   export F77=gfortran-11
else
   export FC=gfortran
   export F77=gfortran
fi
export CXXFLAGS=-std=c++14
cp /usr/local/bin/gfortran-11 /usr/local/bin/gfortran

wget https://tmdlib.hepforge.org/downloads/tmdlib-2.2.01.tar.gz
tar zxfv tmdlib-2.2.01.tar.gz 
cd tmdlib-2.2.01
./configure --with-lhapdf=/usr/local
make -j 2 
make install
cd ..
brew install root
git clone https://gitlab.cern.ch/averbyts/cascade
cd cascade
git checkout hepmc3
gsed  -i "s/AC_FC_WRAPPERS//g" configure.ac
gsed  -i "s/AC_F77_WRAPPERS//g" configure.ac
autoreconf -fisv
./configure --prefix=$(pwd)/TESTINSTALLDIR --with-hepmc=/usr/local --with-hepmc=/usr/local  --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-zlib=/usr/local/opt/zlib --with-gsl=/usr/local
#--with-pythia8=/usr/local 
make -j 2
make install
TMDlib-getdata PB-NLO-HERAI+II-2018-set2
cp TESTINSTALLDIR/share/cascade/LHE/POWHEG-example.lhe ./
TESTINSTALLDIR/bin/cascade < TESTINSTALLDIR//share/cascade/LHE/steering-DY-PH-hepmc23.txt
head -n 40 output.hepmc*

