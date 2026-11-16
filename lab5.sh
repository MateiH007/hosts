
#!/bin/bash
verifica_ip() {
    local domain="$1"
    local ip="$2"
    local dns="$3"

    rezultat=$(nslookup "$domain" "$dns" 2>/dev/null)

    adrese=$(echo "$rezultat" | grep "Address:")

    a_doua=$(echo "$adrese" | head -n 2 | tail -n 1)

    real_ip=$(echo "$a_doua" | awk '{print $2}')

    if [ -n "$real_ip" ] && [ "$ip" = "$real_ip" ]
    then
        return 0
    else
        echo "Bogus IP for $domain in /etc/hosts!"
        return 1
    fi
}

cat /etc/hosts | while read -r ip domain rest
do
    if [ -z "$ip" ] || [ "$ip" = "#" ] || [ "$domain" = "localhost" ]
    then
        continue
    fi

    verifica_ip "$domain" "$ip" "8.8.8.8"

done 
