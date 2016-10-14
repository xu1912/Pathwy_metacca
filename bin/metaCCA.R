#####
##Read in XX, XY and YY files, then output r1, r2 two result.
#####

library(metaCCA)
sn=commandArgs(TRUE)[1]
fn_xx=paste(sn,"_XX.txt", sep="")
fn_xy=paste(sn,"_XY.txt", sep="")
fn_snpid=paste(sn,".snplist", sep="")
ofn_1=paste("../result/",sn,"_r1.txt", sep="")
ofn_2=paste("../result/",sn,"_r2.txt", sep="")

snplist=read.table(fn_snpid,header=F,stringsAsFactors=F);
S_XX=read.table(fn_xx,header=T,row.names=1,stringsAsFactors=F);
S_XY=read.table(fn_xy,header=F,sep="|",row.names=1,colClasses=c("character","character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"));
S_XY[,1]=as.factor(S_XY[,1])
S_XY[,2]=as.factor(S_XY[,2])
S_YY = as.matrix(read.table('../S_YY.txt',header=T,row.names=1));
colnames(S_XY)=c("allele_0","allele_1", "BMI_b", "BMI_se","FG_b", "FG_se","FI_b", "FI_se","WHR_b", "WHR_se", "HDL_b", "HDL_se","TG_b", "TG_se")
colnames(S_XX)=rownames(S_XX)=snplist$V1

idx=complete.cases(S_XX)
S_XX=S_XX[idx,idx]
S_XY=S_XY[idx,]

##single-SNP multi-trait analysis
result1 = metaCcaGp(nr_studies=1, S_XY=list(S_XY), std_info=1, S_YY=list(S_YY), N=24245)

##multi-SNP multi-trait analysis
snp_id=rownames(S_XY)
if ( length(snp_id) >1) {
        result2 = metaCcaGp(nr_studies=1, S_XY=list(S_XY), std_info=1, S_YY=list(S_YY),N=24245, analysis_type=2, SNP_id=snp_id, S_XX=list(S_XX))
}else {result2=result1}
write.table(result1, ofn_1, quote=F, sep="\t", row.names=T,col.names=T)
write.table(result2, ofn_2, quote=F, sep="\t", row.names=sn,col.names=T)

