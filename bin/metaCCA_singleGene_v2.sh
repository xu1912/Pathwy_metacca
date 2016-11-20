#!/bin/bash
GENE_N=$1
echo $GENE_N
RPATH=/extra/xc/metacca
cd $RPATH
if [[ ! -f result/$GENE_N"_r1.txt" || ! -f result/$GENE_N"_r2.txt"   ]];then
        mkdir -p input
        GENE_snp=$GENE_N".snplist"
        if [[ ! -f input/$GENE_N"_XX.txt" || ! -f input/$KEGG_snp ]];then
                echo "Prepare S_XX..."
                plink2 --silent --bfile snp_in_ref_gene --extract gene/$GENE_N.out --r square --write-snplist --out input/$GENE_N
                mv input/$GENE_N".ld" input/$GENE_N"_XX.txt"
                rm -f $GENE_N.nosex
                rm -f $GENE_N.log
        fi


        if [ ! -f input/$GENE_N"_XY.txt" ];then
                cd input
                echo "Prepare S_XY..."
                sqlite3 ../metacca.db "drop table if exists snp_l_$GENE_N"
                sqlite3 ../metacca.db "create table snp_l_$GENE_N (snp_n varchar(20))"
                sqlite3 ../metacca.db ".import $GENE_snp snp_l_$GENE_N"
#               sqlite3 ../metacca.db "select b.snp, b.allele_0, b.allele_1, b.trait1_b_norm, b.trait1_se, b.trait3_b_norm, b.trait3_se, b.trait4_b_norm, b.trait4_se from snp_l_$GENE_N a, snp_traits b where a.snp_n=b.SNP" > $GENE_N"_XY.txt"
                sqlite3 ../metacca.db "select b.snp, b.allele_0, b.allele_1, b.trait1_b_norm, b.trait1_se, b.trait2_b_norm, b.trait2_se, b.trait3_b_norm, b.trait3_se, b.trait4_b_norm, b.trait4_se, b.trait5_b_norm, b.trait5_se,  b.trait7_b_norm, b.trait7_se from snp_l_$GENE_N a, snp_traits b where a.snp_n=b.SNP" > $GENE_N"_XY.txt"
                sqlite3 ../metacca.db "drop table snp_l_$GENE_N"
                cd ../
        fi

        cd input
        echo "metaCCA..."
        Rscript --no-save $RPATH/bin/metaCCA.r $GENE_N

fi
echo "DONE."
