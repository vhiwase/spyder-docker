#!/bin/sh
python3.10 -m spyder_kernels.console &
ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"