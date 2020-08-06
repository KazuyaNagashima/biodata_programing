#データの読み込み(培養細胞における遺伝子のRPKM値)
DATA <- read.table("./data/rpkm_LUAD_cell_lines.txt",header = T,
                   quote="",sep="\t", row.names=1, check.names=FALSE)

#中身の確認
DATA
#データの行数を数える
nrow(DATA)
#データ列数を数える
ncol(DATA)
#列名を確認
colnames(DATA)
#行名を上から10行表示
head(rownames(DATA), n=10 )

DATA[1,] #1行目を表示
DATA[1,3]#1行目3列目を表示
head(DATA[,25],n=4) #25列目のRPKMを4行表示
head(DATA$SAEC,n=4) #SAEC(25列目)のRPKMを4行表示(データフレーム)
#列名にハイフンやスペースなどを含む場合は、バッククォートで 囲うとよい
head(DATA$`PC-9`,n=4) #PC-9のRPKMを4行表示

#LC2/adとSAEC の発現量を比較する

#ピアソン相関係数を算出する(+1はRPKM0だと駄目なため)
cor.test(log2(DATA$LC2ad+1),log2(DATA$SAEC+1),method="pearson")

library(ggplot2) #ggplot2 を呼び出す

max(log2(DATA+1)) #最大値を出力
min(log2(DATA+1)) #最小値を出力

#scattering plotを描く(ggplot2)
p <- ggplot(log2(DATA+1),aes(x=LC2ad, y=SAEC))+
  geom_point()+  #散布図
  geom_smooth(method="lm",se=FALSE,colour ="red")+ #回帰直線
  theme_bw() #白を基調としたテーマ

p <- p+
  xlab("LC2/ad log2(RPKM+1)")+ #x軸ラベル
  ylab("SAEC log2(RPKM+1)")+ #y軸ラベル
  xlim(0,13)+ylim(0,13) #x軸とy軸の範囲指定

#scattering plotを出力する(解像度100dpi,幅6インチ,高さ6インチ)
ggsave(file="scatter.png",plot=p,dpi=100,width=6,height=6)


#ヒートマップを書く
#パッケージにはheatmap.2(gplots),ggplot2,ComplexHeatmapなどがある

library(gplots) #gplotsを呼び出す

#フィルタリング
#少なくとも1細胞株でRPKM>5の遺伝子のみを抽出する(発現量が低すぎる遺伝子の行は除外)
DATA2 <- DATA[which(apply(DATA,1,max)>5),]
DATA3 <- log2(DATA2+1)
DATA4 <- t(scale(t(DATA3))) #Z-Score

#階層的クラスタリング
#ユークリッド距離、ウォード法
d1 <- dist(DATA4, method="euclidean")
d2 <- dist(t(DATA4), method="euclidean")
c1 <- hclust(d1, method="ward.D2")
c2 <- hclust(d2, method="ward.D2")

#heatmap --> pdf
pdf(file="heatmap.pdf", pointsize=8, width=10, height=15)

heatmap.2(as.matrix(DATA4),
Colv=as.dendrogram(c2),Rowv=as.dendrogram(c1),
dendrogram="both",na.color="grey",
scale="none", trace="none", density.info="none",
col=colorpanel(53, low="purple", mid="black", high="green"),
keysize=1, symkey=T, key=T, key.xlab="Z-Score",
key.title="", lhei=c(1,10), lwid=c(1,5), margin=c(8,5))

dev.off()
