#!/bin/bash
while read line;do
        g=${line}
        sed -n "/\t$g$/p" $2 > /extra/xc/metacca/gene/$g
done < $1
