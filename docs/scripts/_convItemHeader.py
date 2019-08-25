#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import re
import glob
import json

def usage():
	print("Usage: _convItemHeader.py [item.cdb]")

class Writer:
	def __init__(self):
		self.buf = ""
	def write(self, line, tab=0):
		for i in range(tab):
			self.buf += "\t"
		self.buf += "%s\n"%line

def execute(cdb, root):
	f = open(cdb)
	jsonStr = f.read()
	f.close()
	jsonDict = json.loads(jsonStr)
	writer = Writer()
	writer.write("const:")
	for dat in jsonDict["sheets"]:
		if dat["name"] == "items":
			for line in dat["lines"]:
				writer.write("  %s: %s # %s"%(line["const"], line["id"], line["name"]))
				#writer.write("  %s: %s"%(line["const"], line["id"]))
	
	path = root + "/common/item_header.txt"
	fOut = open(path, "w")
	fOut.write(writer.buf)
	fOut.close()
	
	print("************************")
	print("output: item_header.txt")
	print("************************")

def main(cdb):
	# ルートディレクトリ取得
	root = os.path.dirname(os.path.abspath(__file__))
	execute(cdb, root)

if __name__ == '__main__':
	args = sys.argv
	argc = len(sys.argv)
	if argc < 2:
		# 引数が足りない
		print(args)
		print("Error: Not enough parameter. given=%d require=%d"%(argc, 2))
		usage()
		quit()

	# アイテム.cdb
	cdb = args[1]

	main(cdb)
