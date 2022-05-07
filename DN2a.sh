#!/bin/bash

p=''

# while getopts ":p" opt; do
#     case $opt in
#         p)
#             p='1';
#             ;;
#     esac
# done

for n in ${*}; do
    if [ "$n" == "-p" ]; then
        p='1';
    fi
done

for n in ${*}; do
    if [[ "$n" = -* ]]; then
        continue;
    fi
    ukaz="$n $(du -sb $(readlink /proc/$n/exe))"

    if [ "$p" == '1' ]; then
        echo $ukaz
    else
        echo $ukaz | cut -d' ' -f1,2
    fi
done¸