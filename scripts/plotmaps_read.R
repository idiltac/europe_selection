## Plot maps for all the single snp analyses.
## include the read level data. 
source("~/selection_map/code/lib/readlib.R")
source("~/selection_map/code/lib/plotlib.R")

library(maps)
library(mapdata)

########################################################################
## Details
root <- "~/selection_map/snps/interesting"
pop.info <- "~/selection_map/pops/pop_info_2.txt"
out <- "~/selection_map/maps/"
subtitles <- c("Hunter-gatherer (Motala,Loschbour)", "Early neolithic (LBK,Salzmuende)",
               "Late neolithic (BB,CW)", "Bronze age (Unetice)",
               "Iron age (Roman, Italian)", "Present")

########################################################################

sample.data <- read.freq(root)
data <- read.freq(paste0(root, ".read"))
modern <- which(rownames(data$count) %in% c("CEU", "TSI", "FIN", "GBR", "IBS"))
data$count[modern,] <- sample.data$count[modern,]
data$total[modern,] <- sample.data$total[modern,]

snp.info <- read.table(paste0(root, ".readme"), as.is=TRUE)
pop.info <- read.table(pop.info, as.is=TRUE)

for(s in 1:NROW(snp.info)){
    pdf(paste0(out, snp.info[s,1], ".ac.read.pdf"), height=9, width=6)
    par(mfrow=c(3,2), oma=c(0,0,1,0), mar=c(0,0,2,0))
    for(i in 1:6){
        which.snp <- which(colnames(data[["count"]])==snp.info[s,2])
        map('world', fill = FALSE,xlim=c(-15,55),ylim=c(35,70), main=snp.info[s,1])
        inc <- pop.info[pop.info[,4]==i,1]
        cnt <- pop.info[pop.info[,4]==i,3]
        ucnt <- unique(cnt)
        
        tt <- rep(0, length(inc))
        tc <- rep(0, length(inc))

        for(k in 1:length(inc)){
            tt[k] <- sum(data[["total"]][rownames(data[["total"]])==inc[k],which.snp])
            tc[k] <- sum(data[["count"]][rownames(data[["count"]])==inc[k],which.snp])
        }

        for(j in 1:length(ucnt)){
            num.a <- sum(tc[cnt==ucnt[j]])
            num.A <- sum(tt[cnt==ucnt[j]])-num.a
            plot.ac(num.a, num.A, ucnt[j], ifelse(i==6,TRUE,FALSE))
        }
        title(subtitles[i])
    }
    title(snp.info[s,1], outer=TRUE)
    dev.off()
}
