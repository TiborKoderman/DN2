#!/bin/bash
while true
do
    read -p "Vnesite ime procesa: " imeProcesa;
    if [[ $(pidof $imeProcesa) ]]; then
        echo "OBSTAJA"
        continue;
    fi
    echo "-"
done