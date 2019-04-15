expect -c '
spawn /opt/fuse.6.2.1-084/bin/client -r 60
expect "root>"
send "container-list\r"
expect "root>"
send "stop-all\r"
expect "root>"
send "exit\r"
interact
'
