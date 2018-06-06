#!/bin/bash
# install-XBI-Ubuntu.sh : a script to install Bitcoin Incognito (XBI)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
XBIuser=xbi
tmpdir=$(mktemp -d)
now=$(date +%Y%m%d_%Hh%M)
MyLog=$tmpdir/install-XBI_$now.log

echo "
*****************************************
*                 	            	*
*      Bitcoin Incognito (XBI)		*
*      masternode setup by tof          *
*                             		*
*****************************************

This installation script will download XBI 3.0.7 
binaries for your version of Ubuntu with all the 
required dependencies for your system.

--> Supported versions are : 
Ubuntu 14.04 (X86_64 CPUs only)
Ubuntu 16.04 (X86_64 and ARM64)
Ubuntu 18.04 (X86_64 CPUs only)

"|tee $MyLog
chmod -c a+rx $tmpdir >> $MyLog

echo -ne "Before we get started, some tests will be performed to 
try to guess your version of Ubuntu ... some informations will 
then be asked by the script that ${GREEN}you will have to answer${NC}.

The installation has to be run as ${RED}root${NC} or a priviledged user
(a user who can run the 'sudo' command, in which case the
password of that user will be asked if neccesary)

Also, i strongely recommend to run any software with a
${GREEN}dedicated user${NC} account. To do so, this script will propose
you to create a user whom you can choose the name.
The default proposition is to create a user 'xbi'.
(if it is good for your just type enter to accept)
"|tee -a $MyLog

# check Ubuntu version
if [ -f /etc/lsb-release ]; 
    then . /etc/lsb-release
    else echo "${RED}Error${NC} : /etc/lsb-release NOT found ..."
fi
# get IPv4 address
IP=$(curl -s4 icanhazip.com)
echo " IP : $IP" >> $MyLog
# ask for masternode privatekey
echo -ne "Please paste ${GREEN}your masternode private key${NC} : 
"|tee -a $MyLog
read KEY
echo "Masternode Private Key : $KEY" >> $MyLog
# installing dependencies
echo -e "Installing all required dependencies ... ${RED}please wait !!!${NC}
(a full detailed log of this installation is written to :
$MyLog)"|tee -a $MyLog
sudo apt-get update -y >> $MyLog
sudo apt-get upgrade -y >> $MyLog
sudo apt-get install curl wget pwgen -y >> $MyLog
#dev tools NOT needed if you don't compile
#sudo apt-get install wget nano unrar unzip -y
#sudo apt-get install libboost-all-dev libevent-dev software-properties-common -y
sudo apt-get install software-properties-common -y >> $MyLog
sudo add-apt-repository ppa:bitcoin/bitcoin -y >> $MyLog
sudo apt-get update >> $MyLog
#sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libdb4.8 libdb4.8++ -y >> $MyLog
sudo apt-get install libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 \
libboost-thread1.58.0 libssl1.0.0 libminiupnpc10 libevent-2.0-5 libevent-pthreads-2.0-5 \
libevent-core-2.0-5 -y >> $MyLog
cd $tmpdir
pwd >> $MyLog
# downloading XXBI 3.0.7 from github
echo "Downloading XBI for you version ($DISTRIB_RELEASE) and CPU architecture ($(arch))"|tee -a $MyLog
wget -q --show-progress https://github.com/tofke/XBI-MN-setup/raw/master/xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz|tee -a $MyLog
# creating a dedicated user for XBI
echo "Now we will create a new user account to run XBI daemon.
You can just hit \"ENTER\" to use the proposed \"xbi\".
You will also need to set a password for that user !"|tee -a $MyLog
echo -ne "Please choose a username to run XBI [${GREEN}xbi${NC}] : "|tee -a $MyLog
read NEWuser
if [ -z $NEWuser ]
  then NEWuser=$XBIuser
  else XBIuser=$NEWuser
fi
echo -e "Creating a dedicated user to run XBI : "|tee -a $MyLog
sudo useradd -m -s /bin/bash $XBIuser && echo -e "${GREEN}${XBIuser}${NC}"|tee -a $MyLog
echo "Now choose a password for this new user !
(beware that it can NOT be an empty password ... 
also don't worry if you see nothing when you type)"|tee -a $MyLog
sudo passwd $XBIuser
# connect as new user and start xbid
echo -e "Becoming user $XBIuser to copy and run XBI binaries : "|tee -a $MyLog
sudo su - $XBIuser <<EOF
. /etc/lsb-release
tar zxvf $tmpdir/xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz 
. .profile
echo -e "
Creating the XBI configuration file (in user's home) 
"
mkdir ~/.XBI
echo "#Bitcoin Incognito (XBI) configuration file
#first of all, let's start in the background
daemon=1
#RPC server settings
server=1
rpcallowip=127.0.0.1
rpcuser=$(pwgen -s 16 -1)
rpcpassword=$(pwgen -s 32 -1)
#network settings
listen=1
port=7250
externalip=$IP
#masternode settings
masternode=1
#masternodeaddr=$IP:7250
masternodeprivkey=$KEY" > ~/.XBI/xbi.conf
ls -l ~/.XBI/xbi.conf 
cat ~/.XBI/xbi.conf 
echo -e "
Now ${GREEN}starting the daemon${NC}"
xbid
(crontab -l;echo "@reboot /home/$XBIuser/bin/xbid")|crontab -
echo -e "
To have xbid started after a reboot, this line was added to your crontab : 
@reboot /home/$XBIuser/bin/xbid
(run 'crontab -e' and choose your favorite editor to change this)
"
EOF
# trick to log user session as EOF stuff does not allow | tee ...
echo "
sudo su - $XBIuser <<EOF
. /etc/lsb-release
tar zxvf $tmpdir/xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz
. .profile
echo -e \"
Creating the XBI configuration file (in user's home)
\"
mkdir ~/.XBI
echo \"#Bitcoin Incognito (XBI) configuration file
#first of all, let's start in the background
daemon=1
#RPC server settings
server=1
rpcallowip=127.0.0.1
rpcuser=$(pwgen -s 16 -1)
rpcpassword=$(pwgen -s 32 -1)
#network settings
listen=1
port=7250
externalip=$IP
#masternode settings
masternode=1
#masternodeaddr=$IP:7250
masternodeprivkey=$KEY\" > ~/.XBI/xbi.conf
ls -l ~/.XBI/xbi.conf
cat ~/.XBI/xbi.conf
echo -e \"
Now ${GREEN}starting the daemon${NC}\"
xbid
(crontab -l;echo \"@reboot /home/$XBIuser/bin/xbid\")|crontab -
echo -e \"
To have xbid started after a reboot, this line was added to your crontab :
@reboot /home/$XBIuser/bin/xbid
(run 'crontab -e' and choose your favorite editor to change this)
\"
EOF
" >> $MyLog
# installation finished
echo "
A full log of this setup can be found in $MyLog
The XBI daemon is started with the user $XBIuser ... 
To connect as that user, type 'sudo su - $XBIuser'

Don't forget to update your local wallet's masternode.conf file as this :
\"alias $IP:7250 $KEY CollateralSendTxid X\"

--> \"alias\" is the name you want to give to your new masternode
--> \"$IP:7250\" are the VPS IP address and XBI default port
--> \"CollateralSendTxid\" is the output of \"masternode outputs\"
--> \"X\" is the index of this transaction id

Then you can manage your masternode from your local wallet.
The files created in $tmpdir can be deleted if you want ... 

Bye, have fun with XBI, and thank you for using my script

 - tof -

" | tee -a $MyLog

