#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import glob

def usage():
	print("Usage: _conv.py [gmadv.py] [define_functions.h] [define_consts.txt] [input_dir] [output_dir]")

def main(tool, fFuncDef, fDefines, inputDir, outDir):
	
	print("--------------------------------------")
	print("tool: %s"%tool);
	print("fFuncDef: %s"%fFuncDef);
	print("fDefines: %s"%fDefines);
	print("inputDir: %s"%inputDir);
	print("outDir: %s"%outDir);
	print("--------------------------------------")
	
	# *.advを取得
	advList = glob.glob("%s*.adv"%inputDir)

	for adv in advList:
		fInput = adv
		fOut   = outDir + adv.replace(inputDir, "").replace(".adv", ".csv")

		cmd = "python3 %s %s %s %s %s"%(
			tool, fFuncDef, fDefines, fInput, fOut)
		print("%s"%fInput)
		os.system(cmd)
		print("--------------------------------------")
		
		# ログを削除する
		fLog = fOut + ".log"
		if os.path.exists(fLog):
			os.remove(fLog)

if __name__ == '__main__':
	args = sys.argv
	argc = len(sys.argv)
	if argc < 6:
		# 引数が足りない
		print(args)
		print("Error: Not enough parameter. given=%d require=%d"%(argc, 6))
		usage()
		quit()

	# ツール
	tool = args[1]
	# 関数定義
	fFuncDef = args[2]
	# 定数定義
	fDefines = args[3]
	# 入力フォルダ
	inputDir = args[4]
	# 出力フォルダ
	outDir = args[5]

	main(tool, fFuncDef, fDefines, inputDir, outDir)
