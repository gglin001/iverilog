docker run -d -it \
  --name verilator_dev_0 \
  -v repos:/repos \
  -w /repos \
  base:latest

# #############################################################################

apt update
apt install -y bison
apt install -y flex
apt install -y gperf
micromamba install bear abseil-cpp

# autoconf
sh autoconf.sh

# ./configure --prefix=$PWD/build

# debug mode
CXXFLAGS="-DDEBUG -g" \
  CCFLAGS="-DDEBUG -g" \
  ./configure --prefix=$PWD/build

bear -- make -j16
make install

# #############################################################################

build/bin/iverilog \
  -o hello examples/hello.vl

build/bin/iverilog \
  -o hello examples/sqrt.vl

./hello
