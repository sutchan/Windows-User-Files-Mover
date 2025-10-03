#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Windows用户文件迁移和设置备份还原工具

功能：
1. 文件迁移 - 将用户文件夹从系统盘迁移到其他分区
2. 开始菜单备份 - 备份开始菜单布局、文件夹和数据库
3. 开始菜单还原 - 还原开始菜单设置

作者：SutChan
版本：v1.10.1
项目地址：https://github.com/sutchan/Windows-User-Files-Mover
"""

import os
import sys
import time
import shutil
import subprocess
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import threading
from datetime import datetime
import ctypes

class WindowsUserFilesMover:
    def __init__(self, root):
        """初始化应用程序"""
        self.root = root
        self.root.title("Windows用户文件迁移工具")
        self.root.geometry("800x600")
        self.root.minsize(700, 500)
        self.root.iconbitmap(default="")  # 可以添加图标路径
        
        # 设置中文字体支持
        self.style = ttk.Style()
        
        # 配置现代主题样式
        self.configure_styles()
        
        # 创建主框架
        self.main_frame = ttk.Frame(self.root, padding="10")
        self.main_frame.pack(fill=tk.BOTH, expand=True)
        
        # 创建标题区域
        title_frame = ttk.Frame(self.main_frame)
        title_frame.pack(fill=tk.X, pady=5)
        
        # 创建标题
        self.title_label = ttk.Label(title_frame, text="Windows用户文件迁移和设置备份还原工具", 
                                     font=("SimHei", 16, "bold"), foreground="#1a73e8")
        self.title_label.pack(pady=10)
        
        # 创建作者、版本和项目地址信息
        info_frame = ttk.Frame(title_frame)
        info_frame.pack(fill=tk.X, pady=2)
        
        self.info_label = ttk.Label(info_frame, text="作者：SutChan    版本：v1.10.1    项目地址：https://github.com/sutchan/Windows-User-Files-Mover", 
                                   font=("SimHei", 10), foreground="#5f6368")
        self.info_label.pack()
        
        # 添加分隔线
        ttk.Separator(self.main_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=5)
        
        # 创建选项卡控件
        self.tab_control = ttk.Notebook(self.main_frame)
        
        # 创建文件迁移选项卡
        self.tab_migrate = ttk.Frame(self.tab_control)
        self.tab_control.add(self.tab_migrate, text="文件迁移")
        
        # 创建开始菜单备份选项卡
        self.tab_backup = ttk.Frame(self.tab_control)
        self.tab_control.add(self.tab_backup, text="开始菜单备份")
        
        # 创建开始菜单还原选项卡
        self.tab_restore = ttk.Frame(self.tab_control)
        self.tab_control.add(self.tab_restore, text="开始菜单还原")
        
        # 放置选项卡控件
        self.tab_control.pack(fill=tk.BOTH, expand=True, pady=10)
        
        # 初始化各个选项卡
        self.init_migrate_tab()
        self.init_backup_tab()
        self.init_restore_tab()
        
        # 创建日志区域 - 美化设计
        self.log_frame = ttk.LabelFrame(self.main_frame, text="操作日志")
        self.log_frame.pack(fill=tk.BOTH, expand=True, pady=10)
        
        # 添加分隔线
        ttk.Separator(self.log_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=5)
        
        # 创建日志文本框 - 美化样式
        self.log_text = scrolledtext.ScrolledText(
            self.log_frame,
            wrap=tk.WORD,
            font=("SimHei", 10),
            bg="#f5f5f5",
            fg="#333333",
            insertbackground="#1a73e8",
            selectbackground="#1a73e8",
            selectforeground="white",
            bd=1,
            relief=tk.SUNKEN
        )
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        self.log_text.config(state=tk.DISABLED)
        
        # 为日志框添加双击复制功能
        self.log_text.bind("<Double-1>", lambda e: self.copy_log_text())
        
        # 配置右键菜单
        self.setup_context_menu()
        
        # 记录开始时间
        self.log("应用程序启动成功")
        
    def configure_styles(self):
        """配置UI样式"""
        # 设置ttk主题
        if sys.platform == 'win32':
            # Windows系统设置
            self.root.option_add("*Font", "SimHei 10")
            
            # 配置ttk样式
            self.style.configure(
                "TLabel",
                font=("SimHei", 10),
                foreground="#333333"
            )
            
            self.style.configure(
                "TButton",
                font=("SimHei", 10),
                padding=(5, 2)
            )
            
            self.style.map(
                "TButton",
                foreground=[('active', '#ffffff')],
                background=[('active', '#1a73e8')]
            )
            
            self.style.configure(
                "TEntry",
                font=("SimHei", 10),
                padding=(3, 3)
            )
            
            self.style.configure(
                "TLabelframe.Label",
                font=("SimHei", 10, "bold"),
                foreground="#444444"
            )
            
            self.style.configure(
                "TNotebook.Tab",
                font=("SimHei", 10),
                padding=(10, 3)
            )
            
            self.style.map(
                "TNotebook.Tab",
                foreground=[('selected', '#1a73e8')],
                background=[('selected', '#ffffff')]
            )
    
    def setup_context_menu(self):
        """设置右键菜单"""
        self.context_menu = tk.Menu(self.root, tearoff=0, font=("SimHei", 10))
        self.context_menu.add_command(label="清空日志", command=self.clear_log)
        self.context_menu.add_separator()
        self.context_menu.add_command(label="复制选中内容", command=self.copy_log_text)
        
        # 绑定右键菜单到日志文本框
        self.log_text.bind("<Button-3>", self.show_context_menu)
        
    def copy_log_text(self):
        """复制选中的日志文本"""
        try:
            selected_text = self.log_text.get(tk.SEL_FIRST, tk.SEL_LAST)
            self.root.clipboard_clear()
            self.root.clipboard_append(selected_text)
        except tk.TclError:
            pass
        
    def show_context_menu(self, event):
        """显示右键菜单"""
        self.context_menu.post(event.x_root, event.y_root)
        
    def clear_log(self):
        """清空日志"""
        self.log_text.config(state=tk.NORMAL)
        self.log_text.delete(1.0, tk.END)
        self.log_text.config(state=tk.DISABLED)
        self.log("日志已清空")
        
    def init_migrate_tab(self):
        """初始化文件迁移选项卡"""
        # 创建内容框架
        content_frame = ttk.Frame(self.tab_migrate, padding=(10, 5))
        content_frame.pack(fill=tk.BOTH, expand=True)
        
        # 创建源目录选择
        source_frame = ttk.Frame(content_frame)
        source_frame.pack(fill=tk.X, pady=8, padx=5)
        
        ttk.Label(source_frame, text="源目录：").pack(side=tk.LEFT, padx=5, pady=2)
        self.source_var = tk.StringVar(value=os.path.expandvars("%USERPROFILE%"))
        self.source_entry = ttk.Entry(source_frame, textvariable=self.source_var, width=50)
        self.source_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5, pady=2)
        self.source_button = ttk.Button(source_frame, text="浏览...", command=self.browse_source)
        self.source_button.pack(side=tk.RIGHT, padx=5, pady=2)
        
        # 创建目标目录选择
        target_frame = ttk.Frame(content_frame)
        target_frame.pack(fill=tk.X, pady=8, padx=5)
        
        ttk.Label(target_frame, text="目标目录：").pack(side=tk.LEFT, padx=5, pady=2)
        self.target_var = tk.StringVar(value="E:\\Users\\Admin")
        self.target_entry = ttk.Entry(target_frame, textvariable=self.target_var, width=50)
        self.target_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5, pady=2)
        self.target_button = ttk.Button(target_frame, text="浏览...", command=self.browse_target)
        self.target_button.pack(side=tk.RIGHT, padx=5, pady=2)
        
        # 添加分隔线
        ttk.Separator(content_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=5)
        
        # 创建迁移选项
        options_frame = ttk.LabelFrame(content_frame, text="迁移选项")
        options_frame.pack(fill=tk.X, pady=10, padx=5)
        
        self.migrate_appdata_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="迁移AppData文件夹", variable=self.migrate_appdata_var).pack(anchor=tk.W, padx=15, pady=6)
        
        # 创建应用列表
        apps_frame = ttk.LabelFrame(content_frame, text="选择要迁移的应用数据")
        apps_frame.pack(fill=tk.BOTH, expand=True, pady=10, padx=5)
        
        # 创建滚动框架
        scroll_frame = ttk.Frame(apps_frame)
        scroll_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        # 创建垂直滚动条
        scrollbar = ttk.Scrollbar(scroll_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        # 创建应用列表框 - 美化样式
        self.app_listbox = tk.Listbox(
            scroll_frame,
            selectmode=tk.MULTIPLE,
            yscrollcommand=scrollbar.set,
            height=10,
            font=("SimHei", 10),
            bd=1,
            relief=tk.SUNKEN,
            selectbackground="#1a73e8",
            selectforeground="white",
            highlightbackground="#e0e0e0",
            highlightcolor="#1a73e8"
        )
        self.app_listbox.pack(fill=tk.BOTH, expand=True, padx=5)
        scrollbar.config(command=self.app_listbox.yview)
        
        # 预填充常见应用
        common_apps = [
            "Google", "Adobe", "Apple Computer", "Wandoujia2", "Winamp",
            "ytmediacenter", "Yodao", "aef", "Netease", "SogouPY",
            "Tencent", "SketchUp", "Teiron", "Kingsoft", "Lantern",
            "Thea Render", "youku", "Microsoft", "Comms"
        ]
        
        for app in common_apps:
            self.app_listbox.insert(tk.END, app)
        
        # 创建全选按钮
        buttons_frame = ttk.Frame(apps_frame)
        buttons_frame.pack(fill=tk.X, pady=5, padx=10)
        
        ttk.Button(buttons_frame, text="全选", command=self.select_all_apps).pack(side=tk.LEFT, padx=10, pady=5)
        ttk.Button(buttons_frame, text="取消全选", command=self.deselect_all_apps).pack(side=tk.LEFT, padx=10, pady=5)
        
        # 创建迁移按钮
        button_frame = ttk.Frame(content_frame)
        button_frame.pack(fill=tk.X, pady=10, padx=5)
        
        # 添加提示信息
        warning_label = ttk.Label(button_frame, text="提示：迁移操作需要管理员权限，操作前请备份重要数据！", 
                                 foreground="#d32f2f", font=("SimHei", 9))
        warning_label.pack(side=tk.LEFT, padx=5)
        
        # 美化的迁移按钮
        self.migrate_button = ttk.Button(button_frame, text="开始迁移", command=self.start_migration, width=15)
        self.migrate_button.pack(side=tk.RIGHT, padx=5)
        
    def init_backup_tab(self):
        """初始化开始菜单备份选项卡"""
        # 创建内容框架
        content_frame = ttk.Frame(self.tab_backup, padding=(10, 5))
        content_frame.pack(fill=tk.BOTH, expand=True)
        
        # 创建备份路径选择
        path_frame = ttk.Frame(content_frame)
        path_frame.pack(fill=tk.X, pady=10, padx=5)
        
        ttk.Label(path_frame, text="备份路径：").pack(side=tk.LEFT, padx=5, pady=2)
        self.backup_path_var = tk.StringVar(value=os.path.join(os.getcwd(), "StartMenu_Backup"))
        self.backup_entry = ttk.Entry(path_frame, textvariable=self.backup_path_var, width=50)
        self.backup_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5, pady=2)
        self.backup_button_browse = ttk.Button(path_frame, text="浏览...", command=self.browse_backup_path)
        self.backup_button_browse.pack(side=tk.RIGHT, padx=5, pady=2)
        
        # 添加分隔线
        ttk.Separator(content_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=5)
        
        # 创建备份选项
        options_frame = ttk.LabelFrame(content_frame, text="备份选项")
        options_frame.pack(fill=tk.X, pady=10, padx=5)
        
        self.backup_layout_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="备份开始菜单布局 (XML)", variable=self.backup_layout_var).pack(anchor=tk.W, padx=15, pady=8)
        
        self.backup_folder_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="备份开始菜单文件夹", variable=self.backup_folder_var).pack(anchor=tk.W, padx=15, pady=8)
        
        self.backup_db_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="备份开始菜单数据库", variable=self.backup_db_var).pack(anchor=tk.W, padx=15, pady=8)
        
        # 添加提示信息
        info_frame = ttk.Frame(content_frame)
        info_frame.pack(fill=tk.X, pady=10, padx=5)
        
        info_label = ttk.Label(info_frame, text="备份文件将保存在选定的路径中，并自动创建带有时间戳的子目录。", 
                             foreground="#5f6368", font=("SimHei", 9), wraplength=700)
        info_label.pack(padx=10)
        
        # 创建备份按钮
        button_frame = ttk.Frame(content_frame)
        button_frame.pack(fill=tk.X, pady=10, padx=5)
        
        self.backup_button = ttk.Button(button_frame, text="开始备份", command=self.start_backup, width=15)
        self.backup_button.pack(side=tk.RIGHT, padx=5)
        
    def init_restore_tab(self):
        """初始化开始菜单还原选项卡"""
        # 创建内容框架
        content_frame = ttk.Frame(self.tab_restore, padding=(10, 5))
        content_frame.pack(fill=tk.BOTH, expand=True)
        
        # 创建还原路径选择
        path_frame = ttk.Frame(content_frame)
        path_frame.pack(fill=tk.X, pady=10, padx=5)
        
        ttk.Label(path_frame, text="备份文件路径：").pack(side=tk.LEFT, padx=5, pady=2)
        self.restore_path_var = tk.StringVar()
        self.restore_entry = ttk.Entry(path_frame, textvariable=self.restore_path_var, width=50)
        self.restore_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5, pady=2)
        self.restore_button_browse = ttk.Button(path_frame, text="浏览...", command=self.browse_restore_path)
        self.restore_button_browse.pack(side=tk.RIGHT, padx=5, pady=2)
        
        # 添加分隔线
        ttk.Separator(content_frame, orient=tk.HORIZONTAL).pack(fill=tk.X, pady=5)
        
        # 创建还原选项
        options_frame = ttk.LabelFrame(content_frame, text="还原选项")
        options_frame.pack(fill=tk.X, pady=10, padx=5)
        
        self.restore_layout_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="还原开始菜单布局", variable=self.restore_layout_var).pack(anchor=tk.W, padx=15, pady=8)
        
        self.restore_folder_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="还原开始菜单文件夹", variable=self.restore_folder_var).pack(anchor=tk.W, padx=15, pady=8)
        
        self.restore_db_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(options_frame, text="还原开始菜单数据库", variable=self.restore_db_var).pack(anchor=tk.W, padx=15, pady=8)
        
        # 创建警告信息
        warning_frame = ttk.LabelFrame(content_frame, text="重要注意事项")
        warning_frame.pack(fill=tk.X, pady=10, padx=5)
        
        # 设置警告框样式
        warning_frame.configure(style="Warning.TLabelframe")
        self.style.configure("Warning.TLabelframe.Label", foreground="#d32f2f")
        
        warning_text = """⚠️ 1. 还原操作需要管理员权限
⚠️ 2. 还原过程中会临时关闭Windows资源管理器
⚠️ 3. 还原完成后需要重启电脑才能生效
⚠️ 4. 请确保备份文件完整无损
⚠️ 5. 还原操作可能会覆盖当前的开始菜单设置"""
        ttk.Label(warning_frame, text=warning_text, font=("SimHei", 9, "bold"), 
                 foreground="#d32f2f", justify=tk.LEFT).pack(padx=15, pady=8)
        
        # 创建还原按钮
        button_frame = ttk.Frame(content_frame)
        button_frame.pack(fill=tk.X, pady=10, padx=5)
        
        self.restore_button = ttk.Button(button_frame, text="开始还原", command=self.start_restore, width=15)
        self.restore_button.pack(side=tk.RIGHT, padx=5)
        
    def browse_directory(self, title, variable, initialdir=None):
        """通用目录浏览函数"""
        directory = filedialog.askdirectory(title=title, initialdir=initialdir or variable.get())
        if directory:
            variable.set(directory)
    
    def browse_source(self):
        """浏览源目录"""
        self.browse_directory("选择源目录", self.source_var)
        
    def browse_target(self):
        """浏览目标目录"""
        self.browse_directory("选择目标目录", self.target_var)
        
    def browse_backup_path(self):
        """浏览备份路径"""
        self.browse_directory("选择备份路径", self.backup_path_var)
        
    def browse_restore_path(self):
        """浏览还原路径"""
        self.browse_directory("选择备份文件路径", self.restore_path_var, initialdir="")
            
    def select_all_apps(self):
        """全选应用列表"""
        self.app_listbox.selection_set(0, tk.END)
        
    def deselect_all_apps(self):
        """取消全选应用列表"""
        self.app_listbox.selection_clear(0, tk.END)
        
    def log(self, message):
        """记录日志信息"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_message = f"[{timestamp}] {message}\n"
        
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, log_message)
        
        # 自动滚动到最新日志
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)
        
        # 刷新界面
        self.root.update_idletasks()
        
    def is_admin(self):
        """检查是否以管理员身份运行"""
        try:
            return ctypes.windll.shell32.IsUserAnAdmin()
        except:
            return False
            
    def run_as_admin(self):
        """以管理员身份重启程序"""
        ctypes.windll.shell32.ShellExecuteW(
            None, "runas", sys.executable, ' '.join(sys.argv), None, 1
        )
        
    def start_migration(self):
        """开始文件迁移"""
        # 检查是否以管理员身份运行
        try:
            if not self.is_admin():
                self.log("需要管理员权限才能执行文件迁移操作")
                if messagebox.askyesno("权限不足", "需要管理员权限才能执行文件迁移操作，是否以管理员身份重启程序？"):
                    self.run_as_admin()
                    sys.exit()
                return
        except ImportError:
            self.log("警告：无法检查管理员权限，请确保以管理员身份运行")
        
        # 获取源目录和目标目录
        source_dir = self.source_var.get()
        target_dir = self.target_var.get()
        
        # 验证目录是否存在
        if not os.path.exists(source_dir):
            messagebox.showerror("错误", f"源目录不存在: {source_dir}")
            return
        
        # 确保目标目录存在
        if not os.path.exists(target_dir):
            try:
                os.makedirs(target_dir)
                self.log(f"已创建目标目录: {target_dir}")
            except Exception as e:
                messagebox.showerror("错误", f"无法创建目标目录: {str(e)}")
                return
        
        # 获取选中的应用
        selected_apps = [self.app_listbox.get(i) for i in self.app_listbox.curselection()]
        
        if not selected_apps:
            messagebox.showwarning("警告", "请至少选择一个要迁移的应用")
            return
        
        # 确认操作
        if not messagebox.askyesno("确认", f"确定要将选中的应用数据从 {source_dir} 迁移到 {target_dir} 吗？\n此操作将会删除原始文件并创建链接。"):
            return
        
        # 禁用迁移按钮
        self.migrate_button.config(state=tk.DISABLED)
        
        # 在新线程中执行迁移操作
        def migrate_thread():
            try:
                self.log(f"开始文件迁移操作")
                self.log(f"源目录: {source_dir}")
                self.log(f"目标目录: {target_dir}")
                
                # 迁移选中的应用
                for app in selected_apps:
                    self.migrate_app_data(app, source_dir, target_dir)
                
                self.log("文件迁移操作已完成")
                messagebox.showinfo("完成", "文件迁移操作已成功完成！")
            except Exception as e:
                self.log(f"迁移过程中发生错误: {str(e)}")
                messagebox.showerror("错误", f"迁移过程中发生错误: {str(e)}")
            finally:
                # 启用迁移按钮
                self.migrate_button.config(state=tk.NORMAL)
                
        # 启动迁移线程
        threading.Thread(target=migrate_thread, daemon=True).start()
        
    def migrate_app_data(self, app_name, source_dir, target_dir):
        """迁移应用程序数据"""
        # 常见的应用数据路径
        app_paths = [
            os.path.join(source_dir, "AppData", "Local", app_name),
            os.path.join(source_dir, "AppData", "LocalLow", app_name),
            os.path.join(source_dir, "AppData", "Roaming", app_name)
        ]
        
        for app_path in app_paths:
            if os.path.exists(app_path):
                # 构建目标路径
                rel_path = os.path.relpath(app_path, source_dir)
                target_path = os.path.join(target_dir, rel_path)
                
                # 确保目标路径的父目录存在
                target_parent = os.path.dirname(target_path)
                if not os.path.exists(target_parent):
                    os.makedirs(target_parent)
                    self.log(f"已创建目录: {target_parent}")
                
                # 迁移文件
                self.log(f"正在迁移: {app_path} -> {target_path}")
                
                # 使用robocopy命令复制文件
                try:
                    cmd = f'robocopy "{app_path}" "{target_path}" /E /COPYALL /XJ'
                    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                    
                    if result.returncode < 8:  # robocopy返回码小于8表示成功
                        # 删除原始目录
                        self.log(f"正在删除原始目录: {app_path}")
                        shutil.rmtree(app_path, ignore_errors=True)
                        
                        # 创建目录联接
                        self.log(f"正在创建目录联接: {app_path} -> {target_path}")
                        cmd = f'mklink /J "{app_path}" "{target_path}"'
                        subprocess.run(cmd, shell=True, check=True)
                        self.log(f"成功迁移: {app_name}")
                    else:
                        self.log(f"复制失败，返回码: {result.returncode}")
                        self.log(f"错误输出: {result.stderr}")
                except Exception as e:
                    self.log(f"迁移 {app_name} 时发生错误: {str(e)}")
        
    def start_backup(self):
        """开始开始菜单备份"""
        # 获取备份路径
        backup_path = self.backup_path_var.get()
        
        # 生成带时间戳的备份目录
        timestamp = datetime.now().strftime("%Y%m%d_%H%M")
        backup_dir = os.path.join(backup_path, f"StartMenu_Backup_{timestamp}")
        
        # 确保备份目录存在
        try:
            os.makedirs(backup_dir, exist_ok=True)
            self.log(f"已创建备份目录: {backup_dir}")
        except Exception as e:
            messagebox.showerror("错误", f"无法创建备份目录: {str(e)}")
            return
        
        # 禁用备份按钮
        self.backup_button.config(state=tk.DISABLED)
        
        # 在新线程中执行备份操作
        def backup_thread():
            try:
                self.log(f"开始开始菜单备份操作")
                
                # 备份开始菜单布局
                if self.backup_layout_var.get():
                    self.backup_start_layout(backup_dir)
                
                # 备份开始菜单文件夹
                if self.backup_folder_var.get():
                    self.backup_start_folder(backup_dir)
                
                # 备份开始菜单数据库
                if self.backup_db_var.get():
                    self.backup_start_db(backup_dir)
                
                self.log("开始菜单备份操作已完成")
                messagebox.showinfo("完成", f"开始菜单备份已成功完成！\n备份文件保存在: {backup_dir}")
            except Exception as e:
                self.log(f"备份过程中发生错误: {str(e)}")
                messagebox.showerror("错误", f"备份过程中发生错误: {str(e)}")
            finally:
                # 启用备份按钮
                self.backup_button.config(state=tk.NORMAL)
                
        # 启动备份线程
        threading.Thread(target=backup_thread, daemon=True).start()
        
    def backup_start_layout(self, backup_dir):
        """备份开始菜单布局"""
        self.log("正在备份开始菜单布局...")
        
        try:
            # 使用PowerShell命令备份开始菜单布局
            layout_file = os.path.join(backup_dir, "StartLayout.xml")
            cmd = f'powershell -Command "Export-StartLayout -Path \"{layout_file}\""'
            subprocess.run(cmd, shell=True, check=True)
            self.log(f"开始菜单布局已备份到: {layout_file}")
        except Exception as e:
            self.log(f"备份开始菜单布局时发生错误: {str(e)}")
            
    def backup_start_folder(self, backup_dir):
        """备份开始菜单文件夹"""
        self.log("正在备份开始菜单文件夹...")
        
        try:
            # 获取开始菜单文件夹路径
            start_menu_path = os.path.expandvars("%APPDATA%\Microsoft\Windows\Start Menu")
            target_path = os.path.join(backup_dir, "Start Menu")
            
            # 使用robocopy命令复制文件
            cmd = f'robocopy "{start_menu_path}" "{target_path}" /E /COPYALL /XJ'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode < 8:  # robocopy返回码小于8表示成功
                self.log(f"开始菜单文件夹已备份到: {target_path}")
            else:
                self.log(f"复制开始菜单文件夹失败，返回码: {result.returncode}")
                self.log(f"错误输出: {result.stderr}")
        except Exception as e:
            self.log(f"备份开始菜单文件夹时发生错误: {str(e)}")
            
    def backup_start_db(self, backup_dir):
        """备份开始菜单数据库"""
        self.log("正在备份开始菜单数据库...")
        
        try:
            # 获取数据库路径
            db_path = os.path.expandvars("%LOCALAPPDATA%\TileDataLayer\Database")
            
            if os.path.exists(db_path):
                target_path = os.path.join(backup_dir, "TileDataLayer", "Database")
                
                # 确保目标路径存在
                os.makedirs(os.path.dirname(target_path), exist_ok=True)
                
                # 使用robocopy命令复制文件
                cmd = f'robocopy "{db_path}" "{target_path}" /E /COPYALL /XJ'
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                
                if result.returncode < 8:  # robocopy返回码小于8表示成功
                    self.log(f"开始菜单数据库已备份到: {target_path}")
                else:
                    self.log(f"复制开始菜单数据库失败，返回码: {result.returncode}")
                    self.log(f"错误输出: {result.stderr}")
            else:
                self.log(f"开始菜单数据库路径不存在: {db_path}")
        except Exception as e:
            self.log(f"备份开始菜单数据库时发生错误: {str(e)}")
            
    def start_restore(self):
        """开始开始菜单还原"""
        # 检查是否以管理员身份运行
        try:
            if not self.is_admin():
                self.log("需要管理员权限才能执行还原操作")
                if messagebox.askyesno("权限不足", "需要管理员权限才能执行还原操作，是否以管理员身份重启程序？"):
                    self.run_as_admin()
                    sys.exit()
                return
        except ImportError:
            self.log("警告：无法检查管理员权限，请确保以管理员身份运行")
        
        # 获取还原路径
        restore_path = self.restore_path_var.get()
        
        # 验证路径是否存在
        if not os.path.exists(restore_path):
            messagebox.showerror("错误", f"备份路径不存在: {restore_path}")
            return
        
        # 确认操作
        if not messagebox.askyesno("确认", "确定要执行开始菜单还原操作吗？\n此操作会临时关闭Windows资源管理器，完成后需要重启电脑才能生效。"):
            return
        
        # 禁用还原按钮
        self.restore_button.config(state=tk.DISABLED)
        
        # 在新线程中执行还原操作
        def restore_thread():
            try:
                self.log(f"开始开始菜单还原操作")
                
                # 关闭Windows资源管理器
                self.log("正在关闭Windows资源管理器...")
                subprocess.run('taskkill /F /IM explorer.exe', shell=True, capture_output=True, text=True)
                
                # 给系统一点时间关闭资源管理器
                time.sleep(2)
                
                # 还原开始菜单文件夹
                if self.restore_folder_var.get():
                    self.restore_start_folder(restore_path)
                
                # 还原开始菜单数据库
                if self.restore_db_var.get():
                    self.restore_start_db(restore_path)
                
                # 还原开始菜单布局
                if self.restore_layout_var.get():
                    self.restore_start_layout(restore_path)
                
                # 重启Windows资源管理器
                self.log("正在重启Windows资源管理器...")
                subprocess.run('start explorer.exe', shell=True, capture_output=True, text=True)
                
                self.log("开始菜单还原操作已完成")
                messagebox.showinfo("完成", "开始菜单还原已成功完成！\n请重启电脑以确保更改生效。")
            except Exception as e:
                self.log(f"还原过程中发生错误: {str(e)}")
                # 尝试重启资源管理器
                try:
                    subprocess.run('start explorer.exe', shell=True)
                except:
                    pass
                messagebox.showerror("错误", f"还原过程中发生错误: {str(e)}")
            finally:
                # 启用还原按钮
                self.restore_button.config(state=tk.NORMAL)
                
        # 启动还原线程
        threading.Thread(target=restore_thread, daemon=True).start()
        
    def restore_start_layout(self, restore_path):
        """还原开始菜单布局"""
        self.log("正在还原开始菜单布局...")
        
        try:
            # 检查布局文件是否存在
            layout_file = os.path.join(restore_path, "StartLayout.xml")
            
            if os.path.exists(layout_file):
                # 使用PowerShell命令还原开始菜单布局
                cmd = f'powershell -Command "Import-StartLayout -LayoutPath \"{layout_file}\" -MountPath \"C:\\""'
                subprocess.run(cmd, shell=True, check=True)
                self.log(f"开始菜单布局已从 {layout_file} 还原")
            else:
                self.log(f"开始菜单布局文件不存在: {layout_file}")
        except Exception as e:
            self.log(f"还原开始菜单布局时发生错误: {str(e)}")
            
    def restore_start_folder(self, restore_path):
        """还原开始菜单文件夹"""
        self.log("正在还原开始菜单文件夹...")
        
        try:
            # 检查备份文件夹是否存在
            backup_folder = os.path.join(restore_path, "Start Menu")
            
            if os.path.exists(backup_folder):
                # 获取开始菜单文件夹路径
                start_menu_path = os.path.expandvars("%APPDATA%\Microsoft\Windows\Start Menu")
                
                # 使用robocopy命令还原文件
                cmd = f'robocopy "{backup_folder}" "{start_menu_path}" /E /COPYALL /XJ /IS /IT'
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                
                if result.returncode < 8:  # robocopy返回码小于8表示成功
                    self.log(f"开始菜单文件夹已还原")
                else:
                    self.log(f"还原开始菜单文件夹失败，返回码: {result.returncode}")
                    self.log(f"错误输出: {result.stderr}")
            else:
                self.log(f"开始菜单文件夹备份不存在: {backup_folder}")
        except Exception as e:
            self.log(f"还原开始菜单文件夹时发生错误: {str(e)}")
            
    def restore_start_db(self, restore_path):
        """还原开始菜单数据库"""
        self.log("正在还原开始菜单数据库...")
        
        try:
            # 检查备份数据库是否存在
            backup_db = os.path.join(restore_path, "TileDataLayer", "Database")
            
            if os.path.exists(backup_db):
                # 获取数据库路径
                db_path = os.path.expandvars("%LOCALAPPDATA%\TileDataLayer\Database")
                
                # 确保目标路径存在
                if not os.path.exists(db_path):
                    os.makedirs(db_path)
                    
                # 使用robocopy命令还原文件
                cmd = f'robocopy "{backup_db}" "{db_path}" /E /COPYALL /XJ /IS /IT'
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                
                if result.returncode < 8:  # robocopy返回码小于8表示成功
                    self.log(f"开始菜单数据库已还原")
                else:
                    self.log(f"还原开始菜单数据库失败，返回码: {result.returncode}")
                    self.log(f"错误输出: {result.stderr}")
            else:
                self.log(f"开始菜单数据库备份不存在: {backup_db}")
        except Exception as e:
            self.log(f"还原开始菜单数据库时发生错误: {str(e)}")
            
if __name__ == "__main__":
    # 检查是否为Windows系统
    if sys.platform != 'win32':
        print("此工具仅支持Windows操作系统")
        sys.exit(1)
        
    # 创建主窗口
    root = tk.Tk()
    
    # 设置中文字体支持
    try:
        # Windows系统设置
        root.option_add("*Font", "SimHei 10")
    except:
        pass
        
    # 创建应用程序实例
    app = WindowsUserFilesMover(root)
    
    # 运行主循环
    root.mainloop()