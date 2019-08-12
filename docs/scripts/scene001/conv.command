#!/bin/sh

# 現在のディレクトリをカレントディレクトリに設定
cd `dirname $0`

# ツール
tool=../../tools/adv/gmadv.py
# 関数定義
funcDef=../common/define_functions.h
# 定数定義
defines=../common/const_header.txt
# 入力フォルダ
inputDir=./
# 出力フォルダ
outDir=../../../assets/data/scene001/

# コンバート実行
python3 ../conv.py $tool $funcDef $defines $inputDir $outDir

#read Wait

# ターミナルを閉じる
#killall Terminal
