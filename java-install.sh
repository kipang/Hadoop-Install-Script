#!/bin/bash

ssh datanode01 'echo JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-3.b14.el6_9.x86_64 >> /etc/profile'
ssh datanode01 'echo PATH=$PATH:$JAVA_HOME/bin'