# BTCi-mn-setup
Bitcoin icognito masternode setup guide for Ubuntu Linux 16.04 (x86_64 &amp; aarch64)


if you just upgraded from BTCi to XBI, try these steps : 

1 stop your VPS node : 
```
btci-cli stop
```
(wait a few seconds)
check the last line in debug.log : 
```
tail -1 .BTCi/debug.log
```
=> should say " DATE hour : Shutdown: done "

2 BACKUP your existing wallet/folder : 
```
tar zcf BTCi.tgz .BTCi
```

3 Symlink previous folder to new name : 
```
ln -s .BTCi .XBI
```
(mind the capitals, as unix systems are case sensitive)
result is something like : 
```
btci@mn2:~$ ll .XBI
lrwxrwxrwx 1 btci btci 5 May 29 20:41 .XBI -> .BTCi/
```

4 Got to datadir : 
```
cd .XBI
```
(same as .BTCi)

5 Symlink config file : 
```
ln -s btci.conf xbi.conf
```
result is something like : 
```
btci@mn2:~/.XBI$ ll xbi.conf 
lrwxrwxrwx 1 btci btci 9 May 29 20:39 xbi.conf -> btci.conf

```
6 Go back to your $HOME folder and download the updated binaries : 
```
cd
wget -q https://github.com/tofke/BTCi-mn-setup/releases/download/3.0.6/xbi-linux-$(arch).tar.gz
tar zxvf xbi-linux-$(arch).tar.gz
```
(will decompress to $HOME/bin wich is in $PATH)

7 restart your node with new binary : 
```
xbid
```
(supposing you have it in your $PATH : for example, create a folder "bin" in your $HOME)

=> should do this : 
```
btci@mn2:~$ xbid 
XBI server starting
```
8 check if it runs ... 
```
xbi-cli getinfo
```
## ... to be continued ... 
