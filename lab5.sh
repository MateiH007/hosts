#!/bin/bash

cat /etc/hosts | while read ip domain rest
do
    if [ -z "$ip" ] || [ "$ip" = "#" ] || [ "$domain" = "localhost" ]
    then
        continue
    fi

    rezultat=$(nslookup "$domain" 8.8.8.8)
    adrese=$(echo "$rezultat" | grep "Address:")
    a_doua=$(echo "$adrese" | head -n 2 | tail -n 1)
    real_ip=$(echo "$a_doua" | cut -d ' ' -f 2)

    if [ -n "$real_ip" ] && [ "$ip" != "$real_ip" ]
    then
        echo "Bogus IP for $domain in /etc/hosts!"
    fi
done
