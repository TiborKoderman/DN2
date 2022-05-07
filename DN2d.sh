#!/bin/bash

for n in "${@:2}"; do
    teza=$(grep -oh "$n [0-9]*" $1 | grep -oh "[0-9]*")

    sum=0;
    cnt=0;
    for i in $teza; do
        sum=$(($sum+$i))
        cnt=$(($cnt+1))
    done

    avg=$(($sum/$cnt))
        
    echo $n $avg;

done | sort -k1,2  -n