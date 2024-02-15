docker run -d -it \
  --name verilator_dev_0 \
  -v repos:/repos \
  -w /repos \
  base:latest

# #############################################################################

cat >>~/.bashrc <<-EOF
export PATH=\$PATH:\${EXT_PATH}
export PYTHONPATH=\$PYTHONPATH:\${EXT_PYTHONPATH}
EOF

apt update
apt install -y bison
apt install -y flex
apt install -y gperf
micromamba install bear abseil-cpp

# autoconf
sh autoconf.sh

# ./configure --prefix=$PWD/build

# debug mode with clang
CC=clang \
  CXX=clang++ \
  CXXFLAGS="-DDEBUG -g -O0" \
  CCFLAGS="-DDEBUG -g -O0" \
  ./configure --prefix=$PWD/build

bear -- make -j16
make install

# #############################################################################

iverilog \
  -o hello examples/hello.vl

iverilog \
  -o hello examples/sqrt.vl

vvp hello
