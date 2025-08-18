#!/bin/sh
os=$(hostnamectl |grep '^Operating System')
archi=$(hostnamectl |grep '[[:blank:]]*Architecture')
echo $os
echo $archi
