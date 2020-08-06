#Rを動かしてみる

#現在のディレクトリを表示する
getwd()

#作業ディレクトリを設定する
setwd("C:/Users/kazuy/OneDrive/3_授業関係/M1/バイオデータプログラミング/3_Rの基礎")

#aに1を代入する
a <- 1
a

#bに2を代入する
b <- 2
b

#四則演算
c <- a + b
c
a - b
a * b
a / b
a **b

#ベクトルをdに代入する
d <- c(1, 2, 3, 4, 5, 6)
d

#dの2番目の要素を取り出す
d[2]

#行列をxに代入する
#dのベクトル、2行3列
x <- matrix(d, nrow =2, ncol =3)
x

#xの1行目3列目の要素を取り出す
x[1,3]

#行名をつける
rownames(x) <- c("A","B")

#列名をつける
colnames(x) <- c("C","D","E")
x

#テーブルを取り出す(txtで出力)
#appendは上書きする場合はF
write.table (x, file="test.txt",sep="\t", append=F,row.names=T, col.names=NA, quote=F)

#保存する(処理した変数などを.Rdataに保存)
save(a, b, c, d, x, file="test.Rdata")

#Rを終了する
q()

#Rを起動して保存したデータをロードする
load(test.Rdata)

#全部保存したい場合
#save(list=ls(),file="all.Rdata")

#変数名を変えてロードしたい場合(xからy)
#saveRDS(object=x, "test.rds")
#y <- readRDS(file ="test.rds")

#実行方法
#1)Rスクリプトを書いて一気に source() で実行する。
#source("note.R")
#2)コマンドラインで実行
#$R --vanilla --slave < note.R




