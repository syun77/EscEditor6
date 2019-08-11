#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" 構文木ビットクラス """

from node.node import Node
from code import Code

class Bit(Node):
	def __init__(self, bit):
		try:
			self.number = int(bit) # フラグの番号
		except:
			raise Exception("Error: Illigal bit '%s'"%str(bit))
	def getNumber(self):
		return self.number
	def run(self, writer):
		""" ビット命令書き込み（参照した場合のみ。変数代入時はAssignクラス）
		# [opecode, ビットの番号値]
		# [1,       4           ]
		# = 5byte
		"""
		writer.writeString(Code.CODE_BIT)
		writer.writeString(self.number)
		writer.writeLog("フラグ, %d"%self.number)
		writer.writeCrlf()
