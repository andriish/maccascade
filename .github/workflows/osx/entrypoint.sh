#!/bin/sh -l
set -x
export TOP=$(pwd)
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  
brew install hepmc 
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
sudo tlmgr install sectsty

which -a gfortran
 find /usr/local/ -name f951
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
ls 
cd tmdlib-2.2.01
#rm -f configure.ac
#cp $TOP/tmdlib/configure.ac ./
#autoupdate
#autoreconf -fisv
./configure --with-lhapdf=/usr/local
make -j 2 
make install
cd ..
git clone https://gitlab.cern.ch/averbyts/cascade
cd cascade
git checkout CI
gsed  -i "s/AC_FC_WRAPPERS//g" configure.ac
gsed  -i "s/AC_F77_WRAPPERS//g" configure.ac
ls /usr/local/lib*/libpyth*
autoreconf -fisv
./configure  --with-hepmc=/usr/local --with-tmdlib=/usr/local --with-lhapdf=/usr/local --with-zlib=/usr/local --with-gsl=/usr/local
#--with-pythia8=/usr/local 
