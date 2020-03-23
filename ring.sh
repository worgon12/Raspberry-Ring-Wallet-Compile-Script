#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;33m'
NC='\033[0m'

echo "${BLUE}******************** Raspberry Ring Wallet Auto-Install ****************************${NC}"
echo "${GREEN}******************************* by worgon12 ****************************************${NC}"
sleep 5
echo "${RED}First of all we will System Update and install the dependencies${NC}"
echo "${RED}Starting installing the dependencies, please do not close the window${NC}"
sleep 5

echo "${BLUE}System Update and dependencies install!${NC}"
sleep 5
sudo apt update -y
sudo apt-get install build-essential libtool autotools-dev automake bison pkg-config bsdmainutils libxkbcommon-dev python3 libevent-dev libglib2.0-dev libboost-system-dev libraspberrypi-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libssl1.0-dev libssl-devlibdb++-dev libboost-all-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev cmake curl g++-multilib binutils-gold -y

wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
unzip db-4.8.30.zip 
cd db-4.8.30
cd build_unix/
../dist/configure --prefix=/usr/local --enable-cxx 
make
make install
cd ..
cd ..
git clone https://github.com/litecoincash-project/ring.git
cd ring


echo "${BLUE}System Cleaning${NC}"
sleep 5
if [ "$OS" = "Windows_NT" ]; then
    ./mingw64.sh
    exit 0
fi

make clean || echo clean

rm -f config.status

echo "${BLUE}Starting${NC}"
sleep 5
sudo ./autogen.sh
echo "${GREEN}done${NC}"
sleep 5
echo "${BLUE}Configure for Pi4${NC}"
sleep 5
sudo ./configure --disable-tests --with-gui=qt5 LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
echo "${GREEN}done"
sleep 5
echo "${BLUE}Install Openssl${NC}"
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout OpenSSL_1_1_0-stable
sudo ./config
make depend
sudo make
sudo make install
cd ..
echo "${GREEN}done${NC}"
sleep 5
echo "${BLUE}Starting Compile for Pi4${NC}"
sudo make -j4
echo "${GREEN}done${NC}"
echo "${GREEN}finish${NC}"
echo "${GREEN}Start the Wallet over VNC with Ring.qt on Desktop${NC}"
sleep 10
exit 0
