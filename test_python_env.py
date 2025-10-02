#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Python环境测试脚本
作者: SutChan
版本: v1.10.1
项目地址: https://github.com/sutchan/Windows-User-Files-Mover
"""

import sys
import os

print("Windows用户文件迁移工具 - Python环境测试")
print("项目地址: https://github.com/sutchan/Windows-User-Files-Mover")
print("版本: v1.10.1")
print("作者: SutChan")
print()
print("Python版本:", sys.version)
print("Python可执行文件路径:", sys.executable)
print("当前工作目录:", os.getcwd())
print("系统环境变量PATH:", os.environ.get('PATH', '未设置'))

print("\n测试完成。按任意键退出...")
input()