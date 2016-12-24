getwd()
install.packages("xtable")
# download the BioC installation routines
source("http://bioconductor.org/biocLite.R")
# install the core packages
 biocLite()
# install the GEO libraries
biocLite("GEOquery")
 library(GEOquery)
getGEOSuppFiles("GSE20986")
untar("GSE20986/GSE20986_RAW.tar", exdir="dataxs")
cels <- list.files("dataxs/", pattern = "[gz]")
sapply(paste("dataxs", cels, sep="/"), gunzip)
cels
library(simpleaffy)
celfiles<-read.affy(covdesc="phenodata.txt", path="datas")
celfiles
celfiles.gcrma<-gcrma(celfiles)
celfiles.gcrma
# load colour libraries
library(RColorBrewer)
# set colour palette
cols <- brewer.pal(8, "Set1")
# plot a boxplot of unnormalised intensity values
boxplot(celfiles, col=cols)
# plot a boxplot of normalised intensity values, affyPLM required to interrogate celfiles.gcrma
library(affyPLM)
boxplot(celfiles.gcrma, col=cols)
# the boxplots are somewhat skewed by the normalisation algorithm
# and it is often more informative to look at density plots
# Plot a density vs log intensity histogram for the unnormalised data
hist(celfiles, col=cols)
#Plot a density vs log intensity histogram for the normalised data
hist(celfiles.gcrma, col=cols)
# Perform probe-level metric calculations on the CEL files:
celfiles.qc <- fitPLM(celfiles)
# Create an image of GSM24662.CEL:
image(celfiles.qc, which=1, add.legend=TRUE)
# Create an image of GSM524665.CEL
# There is a spatial artifact present
image(celfiles.qc, which=4, add.legend=TRUE)
# affyPLM also provides more informative boxplots
# RLE (Relative Log Expression) plots should have
# values close to zero.  GSM524665.CEL is an outlier
RLE(celfiles.qc, main="RLE")
# We can also use NUSE (Normalised Unscaled Standard Errors).
# The median standard error should be 1 for most genes.
# GSM524665.CEL appears to be an outlier on this plot too
NUSE(celfiles.qc, main="NUSE")
distance <- dist(t(eset),method="maximum")
clusters <- hclust(distance)
plot(clusters)
celfiles.filtered <- nsFilter(celfiles.gcrma, require.entrez=FALSE, remove.dupEntrez=FALSE)
# What got removed and why?
celfiles.filtered$filter.log
samples <- celfiles.gcrma$Target
# check the results of this
samples
# convert into factors
samples<- as.factor(samples)
# check factors have been assigned
samples
# set up the experimental design
design = model.matrix(~0 + samples)
##change the columns names of each column (example: sampleschroid->chroid ) 
colnames(design) <- c("choroid", "huvec", "iris", "retina")
#inspect the experiment design
design
library(limma)
# fit the linear model to the filtered expression set
fit <- lmFit(exprs(celfiles.filtered$eset), design)
# set up a contrast matrix to compare tissues v cell line
contrast.matrix <- makeContrasts(huvec_choroid = huvec - choroid,
                                 huvec_retina =  huvec - retina,
                                 huvec_iris =    huvec - iris,
                                 choroid_retina=  choroid-retina,
                                 choroid_iris=    choroid-iris,
                                 retina_iris= retina-iris,
                                   levels=design)
# check the contrast matrix
contrast.matrix
# Now the contrast matrix is combined with the per-probeset linear model fit.
huvec_fits <- contrasts.fit(fit, contrast.matrix)
huvec_ebFit <- eBayes(huvec_fits)
# return the top 10 results for any given contrast
# coef=1 is huvec_choroid, coef=2 is huvec_retina
topTable(huvec_ebFit, number=10, coef=1)
nrow(topTable(huvec_ebFit, coef=1, number=10000, lfc=5))
nrow(topTable(huvec_ebFit, coef=1, number=10000, lfc=4))
nrow(topTable(huvec_ebFit, coef=1, number=10000, lfc=3))
nrow(topTable(huvec_ebFit, coef=1, number=10000, lfc=2))
# Get a list for probesets with a four fold change or more

#probeset.list$ID = rownames(probeset.list)
 probeset.list <- topTable(huvec_ebFit,number=100, coef=1, lfc=4)



library(hgu133plus2.db)
library(annotate)
#gene.symbols <- getSYMBOL(probeset.list$ID, "hgu133plus2")
library(xtable)
ids<-rownames(probeset.list)
symb<-getSYMBOL(ids,  "hgu133plus2.db")
 
df<-data.frame( symb, probeset.list)
# #frame c to determine the number of decimal place
 print(xtable(head(df, n = 8), digits = c(0, 0, 2, 2, 2, -2, -2, 2)), type = 'html')

library(made4)
 df.subset<-df[1:500,]
 ex<-exprs(celfiles.gcrma)[row.names(df.subset),]
 
 
 sy.subset<-df.subset$Symbol
 heatmap.2(ex, trace = "none", scale="row", margins = c(10, 7), 
           col = colorRampPalette(c("red", "black", "green")), 
           labRow = sy.subset)
 install.packages("gplots")
 install.packages("ggplot2")
 library(ggplot2)
 dataggplot<-data.frame(df, n_log10_adj_pval = -c(log10(df$adj.P.Val)))
 a<-ggplot(dataggplot, aes(x = logFC, y = n_log10_adj_pval))
 a<-a+ylab("-log10(adjusted P value)\n")
 a<-a+xlab("logFC")
 a<-a+theme_classic(base_size = 12)
 a<-a+theme(legend.position="none")
 a<-a+scale_color_manual(values = wes_palette("Zissou")[c(1, 3, 5)])
 a<-a+geom_point()
 plot(a)
 
 
 dr<-data.frame(S1=exprs(celfiles.gcrma)[,1], S2=exprs(celfiles.gcrma)[,4])
 m<-ggplot(dr, aes(x=S1, y=S2))
 m<-m+geom_point()
 m<-m+theme_classic(base_size = 6)
m
