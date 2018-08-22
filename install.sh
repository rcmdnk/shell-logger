#!/usr/bin/env bash

scripts=(https://raw.github.com/rcmdnk/shell-logger/master/etc/shell-logger.sh)

if [ -z "$prefix" ];then
  prefix=/usr/local
fi
prefix=${prefix%/}

echo
echo "###############################################"
echo "Install to $prefix/etc"
echo "###############################################"
echo
sudo=""
if [ -d "$prefix/etc" ];then
  touch "$prefix/etc/.install.test" >& /dev/null
  ret=$?
  if [ $ret -ne 0 ];then
    sudo=sudo
  else
    rm -f "$prefix/etc/.install.test"
  fi
else
  mkdir -p "$prefix/etc" >& /dev/null
  ret=$?
  if [ $ret -ne 0 ];then
    sudo mkdir -p "$prefix/etc"
    sudo=sudo
  fi
fi

for s in "${scripts[@]}";do
  sname="$(basename "$s")"
  echo "Intalling ${sname}..."
  $sudo curl -fsSL -o "$prefix/etc/$sname" "$s"
done

echo "Add following line to your .bashrc/.zshrc:"
echo
echo "source $prefix/etc/shell-logger.sh"
