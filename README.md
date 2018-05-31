# BTCi-mn-setup
Bitcoin icognito masternode setup guide for Ubuntu Linux 16.04 (x86_64 &amp; aarch64)

Complete setup guide to be written ... 

## NOTE : if you just upgraded from BTCi to XBI, follow these steps : 

1) Connect to your VPS (as the user running the wallet) and stop the masternode : 
```
btci-cli stop
```
(wait a few seconds)
check the last line in debug.log : 
```
tail -1 .BTCi/debug.log
```
--> should say " DATE hour : Shutdown: done "

(if not, wait a few more seconds : you MUST wait untill "Shutdown: done" is the last line in debug.log)

2) BACKUP your existing wallet/folder : 
```
tar zcf BTCi.tgz .BTCi
```
This command creates an archive of the whole .BTCi folder in a file named "BTCi.tgz)

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
wget -q https://github.com/tofke/BTCi-mn-setup/releases/download/3.0.6/xbi-linux-$(arch).tar.gz
tar zxvf xbi-linux-$(arch).tar.gz
```
### NOTE : $(arch) will result on your system's CPU architecture (x86-64 or aarch64)

(the tar command will decompress to $HOME/bin wich is in $PATH on Ubuntu)

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
The new ticker XBI does take effect at block 50000 (see block explorer at http://explorer.bitcoinincognito.com/)


