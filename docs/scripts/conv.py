#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import re
import glob

def usage():
	print("Usage: conv.py [sceneId]")

def execute(root, sceneId, name=None):
	
	if name is None:
		print("======================================")
		print("Convert: scene%03d"%sceneId)
		print("======================================")
	else:
		print("======================================")
		print("Convert: %s"%name)
		print("======================================")
		
	# ツール
	tool = "%s/../tools/adv/gmadv.py"%(root)
	# 関数定義
	funcDef = "%s/common/define_functions.h"%(root)
	# 定数定義
	defines = "%s/common/const_header.txt"%(root)
	defines += ",%s/common/cdb_header.txt"%(root) # CastleDB定数ヘッダ

	if name is None:
		# 入力フォルダ
		inputDir = "%s/%03d/"%(root, sceneId)
		# 出力フォルダ
		outDir = "%s/../../assets/data/scene%03d/"%(root, sceneId)
	else:
		# 入力フォルダ
		inputDir = "%s/%s/"%(root, name)
		# 出力フォルダ
		outDir = "%s/../../assets/data/%s/"%(root, name)
	
	
	# 入力フォルダをカレントディレクトリに設定
	os.chdir(inputDir)
	
	# ■cdbから定数ヘッダを出力
	cmd = "python3 ../_convCdbHeader.py %s/../../source/dat/esc.cdb"%root
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
		# 全てのシーンをコンバート
		files = os.listdir(root)
		for f in files:
			if re.match(r'\d{3}', f):
				execute(root, int(f))
		# アイテムもコンバート
		execute(root, 0, "item")
		return
	
	if sceneId == "item":
		# アイテムスクリプトをコンバート
		execute(root, 0, "item")
		return
	
	if re.match(r'\d{1,3}', sceneId) == None:
		# 不正なシーンID
		raise Error("Invalid sceneId = '%s'"%sceneId)
	# 指定のシーンのみをコンバートする
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
