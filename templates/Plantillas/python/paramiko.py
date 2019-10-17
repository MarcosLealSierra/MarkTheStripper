#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import path
from paramiko import AutoAddPolicy, RSAKey, SSHClient


host = input('host: ')
port = input('port: ')
user = input('user: ')
comando = input('comando: ')

ssh = SSHClient()
ssh.load_system_host_keys()
ssh.set_missing_host_key_policy(AutoAddPolicy())
ssh.connect(hostname=host, port=port, username=user)

sftp = ssh.open_sftp()
sftp.get()
sftp.close()
