#!/bin/sh
# This file had been modified by clusterednetworks.com
# 2024-03-21
# Copyright (C) 2024  <info@clusterednetworks.com>
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#  
# This script fetches a Dynamic DNS A Record and Updates UFW by opening up      #
# port 22 allowing access to servers from address that may change due to DHCP   #
# Please use at your own risk                                                   #

check_if_rule_exists() {
  local proto=$1
  local port=$2
  local ip=$3
  UFWRULENUM=$(sudo ufw status numbered | grep $ip | grep " $port[ /]" | awk -F'ALLOW IN' '{gsub(/^\[| /, ""); gsub(/\].*/, ""); print $1}');
  if [ $UFWRULENUM ]; then
    echo "$UFWRULENUM"
  else
    echo 0
  fi
}

add_rule() {
  echo "ADD RULE:  Proto: >$1<, Port: >$2<, IP: >$3<"
  local proto=$1
  local port=$2
  local ip=$3
  echo "proto: $proto, port: $port, ip: $ip"
  exists=$(check_if_rule_exists $proto $port $ip)
  # UFWRULEIP=$(sudo ufw status numbered | grep $ip | grep $port | awk -F 'ALLOW IN' '{gsub(/^[ \t]+/, "", $2); gsub(/[ \t]+$/, "", $2); print $2 }');
  UFWRULEIP=$ip
  echo "BEFORE ADD: IP: >$ip<"
  # if [ $UFWRULENUM ]; then
  if [ "$exists" != 0 ]; then
    echo "THE UFW RULE #: $exists, for the IP: $UFWRULEIP, ALREADY EXISTS! NOTHING TO DO..."
  else
    echo "ADDING NEW RULE FOR THE IP: $ip"
    sudo ufw allow proto ${proto} from ${ip} to any port ${port}
  fi
}


delete_rule() {
  echo "DELETE RULE:  Proto: >$1<, Port: >$2<, IP: >$3<"
  local proto=$1
  local port=$2
  local ip=$3
  echo "proto: $proto, port: $port, ip: $ip"
  exists=$(check_if_rule_exists $proto $port $ip)
  # UFWRULEIP=$(sudo ufw status numbered | grep $ip | grep $port | awk -F 'ALLOW IN' '{gsub(/^[ \t]+/, "", $2); gsub(/[ \t]+$/, "", $2); print $2 }');
  UFWRULEIP=$ip
  echo "BEFORE DELETE: NUM: >$UFWRULENUM<, IP: >$UFWRULEIP<"
  # if [ $UFWRULENUM ]; then
  if [ "$exists" != 0 ]; then
    echo "DELETING THE UFW RULE #: $UFWRULENUM, FOR THE IP: $UFWRULEIP"
    sudo ufw delete allow proto ${proto} from ${ip} to any port ${port}
  else
    echo "NO RULE FOUND FOR IP: $ip! NOTHING TO DO..."
  fi
}


if [ "$1" ] && [ "$2" ] && [ "$3" ]; then
  # MIP=$(nslookup "$1" | awk '/Address: /{print $2 }');
  MIP=$(nslookup "$1" | grep -Po '[^\t]\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b' | awk '{print $1}');
  echo "THE IP IS: $MIP"
  if [ ! $MIP ]; then
    echo "No ip retrieved. Exiting script..."
    exit
  fi
  # FILE="/home/user/SCRIPTS/IPCHECK/$1".txt
  FILE="$1".txt
  port="$2"
  proto="$3"
  ip=''
  if [ -f $FILE ]; then
    while read -r line
    do
        ip=$line
        echo "Ip read from file - $ip"
    done < "$FILE"
    echo "IP:~~~>$ip<~~~|MIP:~~~>$MIP<~~~"
    exists=$(check_if_rule_exists tcp $port $ip)
    if [ "$ip" = "$MIP" ] && [ "$exists" != 0 ]; then
      echo "|IPs are the same. Terminating script...|"
      exit
    else
      delete_rule $proto $port $ip
    fi
  else
    echo "File '$FILE' does not exist"
  fi
    # nslookup "$1" | awk '/Address: /{print $2 }' > "/home/user/SCRIPTS/IPCHECK/$1".txt
    nslookup "$1" | grep -Po '[^\t]\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b' | awk '{print $1}' > $FILE
    if [ -n $MIP ]; then
      add_rule $proto $port $MIP
    fi
else
    echo "No domain name given..."
fi
