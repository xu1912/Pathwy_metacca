#!/bin/bash
while read line;do
        /extra/xc/metacca/bin/metaCCA_singleGene_v2.sh ${line}
done < $1
