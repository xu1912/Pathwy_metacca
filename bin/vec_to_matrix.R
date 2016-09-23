#######
##Convert plink output -- the xx.ld file to matrix showing SNP-SNP correlation.
#######

sn=commandArgs(TRUE)[1]
fn=paste("../ld/",sn,".ld",sep="")
o_xxn=paste(sn,"_XX.txt", sep="")
o_idn=paste(sn,"_snpid.txt", sep="")

d=read.table(fn, header=T, stringsAsFactors=F)

vec_to_matrix=function(dt){
        snp_id=unique(c(dt[,1],dt[,2]))
        snp_ll=length(snp_id)
        dm=matrix(1,nrow=snp_ll, ncol=snp_ll)

        ####make a index
        s_idx=list()
        for (i in 1:snp_ll){
                s_idx[[i]]=unique(c(which(dt[,2]==snp_id[i]),which(dt[,1]==snp_id[i])))
        }

        for (i in 1:(snp_ll-1)){
                for (j in (i+1):snp_ll){

                        s_scope=unique(c(s_idx[[i]], s_idx[[j]]))
                        dt_s=dt[s_scope,]

                        f_idx=subset(dt_s, (dt_s[,1]==snp_id[i] & dt_s[,2]==snp_id[j]) | (dt_s[,1]==snp_id[j] & dt_s[,2]==snp_id[i]) )
                        if (length(f_idx[,1])>0){
                                dm[i,j]=f_idx[1,3]
                                dm[j,i]=f_idx[1,3]
                        }else{
                                dm[i,j]=0
                                dm[j,i]=0
                        }

                }
        }

        rownames(dm)=snp_id
        colnames(dm)=snp_id
        return(dm)
}

dt=d[,c(3,6,7)]
res=vec_to_matrix(dt)

write.table(res, o_xxn,quote=F,row.names=T,col.names=T)
write.table(rownames(res), o_idn,quote=F,row.names=F,col.names=F)
