#¯\_(ツ)_/¯ Made by spookiestevie ( ͡° ͜ʖ ͡°), © DONT STEAL MY THUNDER ©


apt-get -y update
apt-get install -y nano
apt-get install -y automake
apt-get install -y libdb++-dev
apt-get install -y build-essential libtool autotools-dev
apt-get install -y autoconf pkg-config libssl-dev
apt-get install -y libboost-all-dev
apt-get install -y libminiupnpc-dev
apt-get install -y git
apt-get install -y software-properties-common
apt-get install -y python-software-properties
apt-get install -y g++
add-apt-repository ppa:bitcoin/bitcoin -y
apt-get -y update
apt-get install -y curl
apt-get install -y libdb4.8-dev libdb4.8++-dev -y 
cd ~ 
git clone https://github.com/chaincoin/chaincoin.git 
cd ~/chaincoin/ 
./autogen.sh 
./configure --without-gui 
make
make install 
mkdir ~/.chaincoin/ 
cd ~/.chaincoin/
touch chaincoin.conf

echo "Writing to chaincoin.conf"

IP=$(curl http://checkip.amazonaws.com/)					#gets current machine's ip from aws
PW=$(date +%s | sha256sum | base64 | head -c 32 ;)			#designs a random password
echo "" > chaincoin.conf                                    #clears chaincoin.conf
echo "rpcuser=chaincoinrpc" >> chaincoin.conf               #writes to chaincoin.conf
echo "rpcpassword="$PW >> chaincoin.conf
echo "server=1" >> chaincoin.conf
echo "listen=1" >> chaincoin.conf
echo "Starting daemon, Please allow up to 3 minutes for it to start properly."
chaincoind --daemon                                         #starts the daemon
sleep 180 													#3min wait to ensure server fully loaded othewise script fails.
PUBLICkey=$(chaincoind getaccountaddress 0)                 #saves output of command which is the pubkey
echo "Public key: "$PUBLICkey
MNPRIVkey=$(chaincoind masternode genkey)                   #saves output of command which is the mnprivkey
sleep 1
echo "Masternode private key: "$MNPRIVkey
chaincoind stop 											#stops server as we need to update the chaincoin.conf file with the key
echo "masternode=1">> chaincoin.conf
echo "masternodeaddr="$IP":11994" >> chaincoin.conf
sleep 1
read -p "Do you want a new masternode private key [y/n]? " -n 1 -r  #userinput
echo														#/n
if [[ $REPLY =~ ^[Yy]$ ]]									#if userinput is y/Y
then
    echo $MNPRIVkey                                         #print private key
    echo "masternodeprivkey="$MNPRIVkey >> chaincoin.conf   #adds priv key to conf file
else 
	echo "Hello, Please paste your masternode private key here: "
	read mnprivkey
	echo "masternodeprivkey="$mnprivkey >> chaincoin.conf   #adds user priv key to conf file
fi  		 												#完成												
chaincoind --daemon 										#starts the daemon again to enable changes to conf file and starts syncing
sleep 1
echo "Starting daemon"
sleep 1
echo
echo "=================IMPORTANT THINGS================="	#useful info
echo -e "\e[1mHave a copy of this somewhere!"
echo "rpcuser: chaincoinrpc"
echo "rpcpassword: "$PW
echo "masternodeprivkey: "$MNPRIVkey
echo "masternodepublickey: "$PUBLICkey
echo "masternode IP: "$IP":11994"
echo "=================================================="
sleep 1
echo ""
echo -e "\e[32mNow send \e[93m1000.0001 CHC \e to this address\e" $PUBLICkey
sleep 1
echo ""
echo "Here are some useful commands:"
echo -e "\e[34mchaincoind listtransactions\e"
echo -e "\e[34mchaincoind getinfo\e"
echo -e "\e[34mchaincoind masternode start \e"
echo -e "\e[34mchaincoind masternode current\e"