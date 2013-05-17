multi-ssh
=========

Execute binaries or shell scripts on multiple servers over ssh,
implemented in bash only.

groups
======

You can define servers in different files in folder 'groups'. A group can be defined using '-g' when starting multi-ssh.sh
For example customer1, customer2 or squeezy, rehl6.

Use `-g all` to run the command or script on all servers.

possible options
================

```
  -n|--dry-run                don't run any command, only show them
  -s|--silent                 don't show servernames
  -c|--cron                   show servername only on remote output
  -i|--stdin                  use stdin, even if CMD is not empty
```

usage examples
==============

Run command `uptime` on all servers.
```
multi-ssh.sh -g all uptime
```
example output:
```
WARNING: esp-admin@cluster01.sv.company.com:2426 not reachable.
WARNING: esp-admin@svservice05-2.sv.company.com:2271 not reachable.
### esp-admin@svservice05-4.sv.company.com:2275 ###
 02:59:54 up 50 days, 12:21,  0 users,  load average: 0.00, 0.00, 0.00
WARNING: esp-admin@svservice06-2.sv.company.com:2276 not reachable.
### esp-admin@company1-8.ext.company.com:2288 ###
 02:59:59 up 776 days, 19:13,  0 users,  load average: 0.25, 0.07, 0.02
### esp-admin@svservice05-3.sv.company.com:2272 ###
 03:00:01 up 50 days, 13:43,  1 user,  load average: 1.07, 0.64, 0.51
```

Pipe and execute a script with /bin/bash on multiple servers.
```
cat myfancyscript.sh |multi-ssh.sh -g all --stdin /bin/bash
```

Pipe and execute a script as root adding a parameter.
```
cat ~/bin/check_timezone-and-datetime.sh |multi-ssh.sh -g customer1 --silent --stdin "sudo /bin/bash -s " 0.debian.pool.ntp.org
```

multi-scp.sh
============

Copy a file to multiple servers.
