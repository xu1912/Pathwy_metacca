#/bin/bash
##Create the snp_traits table by importing the "snp_traits.txt".

sqlite3 metacca.db "create table snp_traits (snp text,  allele_0 text, allele_1 text, trait1_b numeric, trait1_se numeric, trait2_b numeric, trait2_se numeric, trait3_b numeric, trait3_se numeric, trait4_b numeric, trait4_se numeric, trait5_b numeric, trait5_se numeric, trait6_b numeric, trait6_se numeric)";
echo -e '.separator " "\n.import snp_traits.txt snp_traits' | sqlite3 metacca.db
