#!/bin/bash

###########
##generate up_pro.bed file
##Input: $1 -- SNP id list
##       $2 -- LD threshold for pruning (0, 1)

plink2 --file hapmap3 --extract $1 --keep CEU_hapmap --indep-pairwise 50 5 $2 --r2 inter-chr with-freqs --ld-window-r2 0 --out uppro
plink2 --bfile up_pro --extract up_pro.prune.in --make-bed --out up_pro_pruned
