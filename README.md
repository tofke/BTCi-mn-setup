# XBI-MN-setup
## Bitcoin icognito (XBI) masternode setup guide for Ubuntu Linux

Supported versions include Ubuntu <b>14.04</b> (x86_64), <b>16.04</b> (x86_64 or aarch64) and <b>18.04</b> (x86_64).

### An installation script is available to automatically set up XBI for you : 
This script will install all dependencies, create a user account (do NOT run XBI as root), and finally download the appropriate version of the Bitcoin Icognito xbi binaries for you. A configuration file will then be created in that user's folder and the daemon will be started. 

a) If you are not already connected as root, become root : 
```
sudo su -
```

b) Make sure you have "wget" installed to download the script :
```
apt install -y wget
```

c) Download the script and start it : 
```
wget https://github.com/tofke/XBI-MN-setup/raw/master/install-XBI-Ubuntu.sh && chmod -c u+x install-XBI-Ubuntu.sh && ./install-XBI-Ubuntu.sh
```

d) Follow the instructions, the script will ask you for : 
* the masternode's private key (you create it in your local wallet with "masternode genkey")
* the username you wish to create (it proposes to create a user called 'xbi' by default)
* you will be prompted to enter a password (twice) for that new user ...

Everything else is done automatically. I will add an example output if you wish to see what it looks like.

#### Note : my previous installation script guide has moved to https://github.com/tofke/old_btcimn

If you want to manually install XBI, you can find the binaries of "headless" XBI (xbid, xbi-cli and xbi-tx) here.
Beware that right clic on the links above and paste them after wget or curl does not work. This will result in downloading an html file instead of the tar.gz archives targeted behind these links (clic on them in your browser to see full path or follow instructions below). 

### Manual installation guide : 

a) Update your VPS and install required dependencies : 
```
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl wget pwgen software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get install -y libdb4.8 libdb4.8++ libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 libboost-thread1.58.0 libssl1.0.0 libminiupnpc10 libevent-2.0-5 libevent-pthreads-2.0-5 libevent-core-2.0-5 
```
#### Note : a freshly deployed server will most probably get a new Linux kernel in the updates ... you should reboot before continuing !

b) Create a user to run any software, it is not a good practice to run things as root !
```
useradd -m -s /bin/bash NewUserName
```
(replace NewUserName with what you want to see)

c) Connect as that new user and download binary for your platform :
```
cd
source /etc/lsb-release
wget https://github.com/tofke/XBI-MN-setup/raw/master/xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz
```
#### Note : do not right-clic and copy the above URL it would download an HTML file !
* use the exact same command shown here, or download manually and copy the archive to your VPS

d) Decompress the tar archive in your $HOME (will create files in ~/bin) :
```
tar zxvf xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz
```

e) create XBI folder and configuration file :
```
mkdir ~/.XBI && echo "#Bitcoin Incognito (XBI) configuration file
#first of all, let's start in the background
daemon=1
#RPC server settings
server=1
rpcallowip=127.0.0.1
rpcuser=xbiRPC$(pwgen -s 8 -1)
rpcpassword=$(pwgen -s 32 -1)
#network settings
listen=1
port=7250
externalip=VPS-IP
#masternode settings
masternode=1" > ~/.XBI/xbi.conf
```
#### Note : you need to have the 'pwgen' tool installed for the above example to work
(if you don't have it yet, type 'sudo apt install -y pwgen')

f) start the XBI daemon 
```
xbid
```
#### Note : with Ubuntu 18.04, you need to source your .profile before if you did not have a folder named "bin" in your $HOME before

g) check your local wallet to enable the masternode with appropriate masternode.conf
```
alias VPS-IP:port masterbodePrivateKey TXindex X
```

## NOTE : if you want to just upgrade manually from BTCi to XBI, follow these steps : 

1) Connect to your VPS (as the user running the wallet) and stop the masternode : 
```
btci-cli stop
```
Wait a few seconds, then check the last line in debug.log : 
```
tail -1 .BTCi/debug.log
```
--> should say " DATE hour : Shutdown: done "

(if not, wait a few more seconds : you MUST wait untill "Shutdown: done" is the last line in debug.log)

NOTE : for those confused by the second command, "tail" is for reading the last lines of a file, "-1" means "just one line", and the "DATE" & "hour" in my example should be read as the actual date and hour timestamp in the log ... if you type "tail -1 debug.log" for example, you get the last 10 lines of your log ... 

2) BACKUP your existing wallet/folder : 
```
tar zcf BTCi.tgz .BTCi
```
This command creates an archive of the whole .BTCi folder in a file named "BTCi.tgz"

3) Symlink previous folder to new name : 

(a symbolic link is like a shortcut : this command does not create a new folder but an "alias" with the new name)
```
ln -s .BTCi .XBI
```
(mind the capitals, as unix systems are case sensitive)
result is something like : 
```
btci@mn2:~$ ll .XBI
lrwxrwxrwx 1 btci btci 5 May 29 20:41 .XBI -> .BTCi/
```

4) Got to the datadir (folder containing th Bitcoin incognito blockchain and wallet files) : 
```
cd .XBI
```
(same as .BTCi, as mentionned before .XBI is a symbolic link to .BTCi)

5) Symlink config file, so you won't have to create a new one : 

(it's just a ticker name change and a bug correction also)
```
ln -s btci.conf xbi.conf
```
The result is something like : 
```
btci@mn2:~/.XBI$ ll xbi.conf 
lrwxrwxrwx 1 btci btci 9 May 29 20:39 xbi.conf -> btci.conf
```
This will permit the "xbi" tools to see your previously created configuration with "btci" tools.

6) Go back to your $HOME folder (type 'cd') and download the updated binaries : 
```
cd
source /etc/lsb-release
wget https://github.com/tofke/XBI-MN-setup/raw/master/xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz
tar zxvf xbi-ubuntu-$DISTRIB_RELEASE-$(arch).tar.gz
```
#### NOTE : $(arch) will result on your system's CPU architecture (x86-64 or aarch64)

(the tar command will decompress to $HOME/bin wich is in $PATH on Ubuntu)

#### NOTE2 : if you installed a previous version of the BTCi wallet on Ubuntu 14.04, use this link : 
```
wget https://github.com/tofke/BTCi-mn-setup/releases/download/3.0.7/xbi-ubuntu-14.04-x86_64.tar.gz
```
Also, on Ubuntu 14.04, you will have to add $HOME/bin to your $PATH manually : 
```
echo "export PATH=\$PATH:\$HOME/bin" >> ~/.bashrc
. ~/.bashrc
```
Then you can run xbid and xbid-cli commands 

7) restart your node with new binary : 
```
xbid
```
 --> should do this : 
```
btci@mn2:~$ xbid 
XBI server starting
```
8) check if it runs ... 
```
xbi-cli getinfo
```
9) Check the status of your masternode in your local GUI wallet (Windows, Mac or Linux)

10) Enjoy ...

Your Bitcoin Incognito node is up to date.

The new ticker XBI does take effect at block 50000 

(see block explorer at http://explorer.bitcoinincognito.com/)


## Feel free to consider a donation if this helped : 
XBI : B5riAb43z9i3CEVYBK9vjwN1nRF6UsJoze

*Official XBI Discord (masternode channel) : https://discord.gg/NRgMQHJ

(you can find me there as "tof" and let me know if you have any issue with this guide)

# Recommended Tools

- MobaXterm : the best SSH client (and much more) for Windows i know : https://mobaxterm.mobatek.net/download.html

