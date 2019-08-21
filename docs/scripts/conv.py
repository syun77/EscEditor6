#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import re
import glob

def usage():
	print("Usage: conv.py [sceneId]")

def execute(root, sceneId):
	
	print("======================================")
	print("Convert: scene%03d"%sceneId)
	print("======================================")
	
	# ツール
	tool = "%s/../tools/adv/gmadv.py"%(root)
	# 関数定義
	funcDef = "%s/common/define_functions.h"%(root)
	# 定数定義
	defines = "%s/common/const_header.txt"%(root)
	defines += ",%s/common/item_header.txt"%(root) # アイテム定数ヘッダ
	# 入力フォルダ
	inputDir = "%s/%03d/"%(root, sceneId)
	# 出力フォルダ
	outDir = "%s/../../assets/data/scene%03d/"%(root, sceneId)
	
	# 入力フォルダをカレントディレクトリに設定
	os.chdir(inputDir)
	
	# ■cdbからアイテム定数ヘッダを出力
	cmd = "python3 ../_convItemHeader.py %s/../../source/dat/layout.cdb"%root
	os.system(cmd)
	
	# ■スクリプトコンバート
	cmd = "python3 ../_conv.py %s %s %s %s %s"%(
		tool, funcDef, defines, inputDir, outDir)
	os.system(cmd)
	
	# ■定数ヘッダファイル出力
	cmd = "python3 ../_convConstHeader.py %s"%defines
	os.system(cmd)

def main(sceneId):
	# ルートディレクトリ取得
	root = os.path.dirname(os.path.abspath(__file__))
	if sceneId == "all":
		files = os.listdir(root)
		for f in files:
			if re.match(r'\d{3}', f):
				execute(root, int(f))
		return
	
	if re.match(r'\d{1,3}', sceneId) == None:
		raise Error("Invalid sceneId = '%s'"%sceneId)
	execute(root, int(sceneId))
if __name__ == '__main__':
	args = sys.argv
	argc = len(sys.argv)
	if argc < 2:
		# 引数が足りない
		print(args)
		print("Error: Not enough parameter. given=%d require=%d"%(argc, 2))
		usage()
		quit()

	# シーンID
	sceneId = args[1]

	main(sceneId)
