#!/bin/bash
ping 192.168.122.127 -c 1 && expect -c '
spawn ssh root@192.168.122.127 -p 22 -o ConnectionAttempts=60
expect {
  -re ".*es.*o.*" {
    exp_send "yes\r"
    exp_continue
  }
  -re ".*sword.*" {
    exp_send "root\r"
  }
}
	expect "#"
send "/root/stop.sh\r"
expect "#"
send "exit\r"
'
virsh -c lxc:/// destroy fuse-paul-1 && expect -c '
set timeout -1
set host fuse-paul-1
set DATE [exec date +%F]   
spawn borg create -v --list /home/borgbackup::$DATE-$host /home/containers/fuse-paul-1/
    expect "Enter passphrase for key /home/borgbackup:"
send "sys1\r"
    expect "opr-asoup3-cki"
'

expect -c'
spawn borg prune -v --list --keep-daily=7 --keep-weekly=2 /home/borgbackup 
	expect "Enter passphrase for key /home/borgbackup:"
send "sys1\r"
    expect "opr-asoup3-cki"
'

virsh -c lxc:/// start fuse-paul-1 && 
expect -c '
spawn ping 192.168.122.127
expect ".*ttl.*" 
send "\003\r"
expect "#"
'
expect -c 'spawn ssh root@fuse-paul-1 -p 22 -o ConnectionAttempts=60
expect {
  -re ".*es.*o.*" {
    exp_send "yes\r"
    exp_continue
  }
  -re ".*sword.*" {
    exp_send "root\r"
  }
}
expect "#"
send "/root/start.sh\r"
expect "#"
send "exit\r"
interact
'

