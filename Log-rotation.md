# A daily rotation example of debug.log 
Many options are possible for log rotation. 

It mostly depends on how you installed the software. 

I suggest the creation of a userspace logrotate.conf like in the following example.

### 1. If you installed xbid as a regular user (for example "xbi" following my guide) 
Create a text file named "logrotate.conf" (nano or vi as you like) in ~/.XBI/ : 
```
echo "# logrotate.conf : userspace logrotation example
# add this command to crontab : (replace $USER by the username)
# m h * * * cd /home/$USER/.XBI && /usr/sbin/logrotate -f logrotate.conf -s logrotate.state
/home/xbi/.XBI/debug.log {
  rotate 30
  copytruncate
  compress
  missingok
  notifempty
}" > ~/.XBI/logrotate.conf
```
Then add this line to your crontab (type "crontab -e" and choose your favorite editor) : 
```
0 0 * * * cd /home/$USER/.XBI && /usr/sbin/logrotate -f logrotate.conf -s logrotate.state
```

### 2. If you installed as root, you might as well just add a configuration file in "/etc/logrotate.d/" : 
```
echo "# XBI logrotation example
# rotate daily, keep 30 logs
/root/.XBI/debug.log {
  daily
  rotate 30
  copytruncate
  compress
  missingok
  notifempty
}" > /etc/logrotate.d/xbi
```
In this example, you don't need to create a schedule, as log rotation tasks put in this directory are automatically scheduled following the configuration (note the word "daily" here could be something else, like weekly or monthly).

NOTE : in the first example (user xbi), you have no "daily" directive ... this is because you call the logrotate command with a cron schedule

