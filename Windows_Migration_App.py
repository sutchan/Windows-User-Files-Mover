"""
Windows 用户文件迁移工具 - 桌面应用版
使用 CustomTkinter 实现 Windows 11 Fluent Design 风格界面
"""

import customtkinter as ctk
import os
import shutil
import json
from pathlib import Path
from tkinter import filedialog, messagebox
import threading
import time
from datetime import datetime

# 设置 CustomTkinter 外观
ctk.set_appearance_mode("light")  # "light", "dark", "system"
ctk.set_default_color_theme("blue")  # "blue", "green", "dark-blue"

class WindowsMigrationApp:
    def __init__(self):
        # 创建主窗口
        self.root = ctk.CTk()
        self.root.title("Windows 用户文件迁移工具")
        self.root.geometry("1400x900")
        
        # 应用图标（如果有的话）
        # self.root.iconbitmap("icon.ico")
        
        # 配置网格权重
        self.root.grid_rowconfigure(0, weight=1)
        self.root.grid_columnconfigure(1, weight=1)
        
        # 当前页面
        self.current_page = "dashboard"
        
        # 创建 UI
        self.create_sidebar()
        self.create_content_area()
        
        # 显示仪表盘
        self.show_page("dashboard")
    
    def create_sidebar(self):
        """创建左侧导航栏"""
        # 侧边栏框架
        self.sidebar = ctk.CTkFrame(self.root, width=280, corner_radius=0)
        self.sidebar.grid(row=0, column=0, sticky="nsew")
        self.sidebar.grid_rowconfigure(7, weight=1)
        
        # 标题
        self.logo_label = ctk.CTkLabel(
            self.sidebar, 
            text="导航",
            font=ctk.CTkFont(size=20, weight="bold")
        )
        self.logo_label.grid(row=0, column=0, padx=20, pady=(20, 10))
        
        # 导航按钮
        self.nav_buttons = {}
        
        nav_items = [
            ("dashboard", "仪表盘", "🏠"),
            ("migrate", "开始迁移", "▶️"),
            ("profiles", "迁移配置", "💾"),
            ("history", "迁移历史", "📜"),
        ]
        
        for i, (page_id, text, icon) in enumerate(nav_items):
            btn = ctk.CTkButton(
                self.sidebar,
                text=f"  {icon}  {text}",
                anchor="w",
                height=40,
                corner_radius=8,
                fg_color="transparent",
                text_color=("gray10", "gray90"),
                hover_color=("gray90", "gray20"),
                command=lambda p=page_id: self.show_page(p)
            )
            btn.grid(row=i+1, column=0, padx=10, pady=5, sticky="ew")
            self.nav_buttons[page_id] = btn
        
        # 分隔线
        separator = ctk.CTkFrame(self.sidebar, height=2, fg_color=("gray80", "gray20"))
        separator.grid(row=5, column=0, padx=20, pady=10, sticky="ew")
        
        # 高级功能标题
        advanced_label = ctk.CTkLabel(
            self.sidebar,
            text="高级功能",
            font=ctk.CTkFont(size=12, weight="bold"),
            text_color=("gray50", "gray50")
        )
        advanced_label.grid(row=6, column=0, padx=20, pady=(10, 5), sticky="w")
        
        # 高级功能按钮
        advanced_items = [
            ("symlinks", "符号链接管理", "🔗"),
            ("settings", "设置", "⚙️"),
        ]
        
        for i, (page_id, text, icon) in enumerate(advanced_items):
            btn = ctk.CTkButton(
                self.sidebar,
                text=f"  {icon}  {text}",
                anchor="w",
                height=40,
                corner_radius=8,
                fg_color="transparent",
                text_color=("gray10", "gray90"),
                hover_color=("gray90", "gray20"),
                command=lambda p=page_id: self.show_page(p)
            )
            btn.grid(row=7+i, column=0, padx=10, pady=5, sticky="ew")
            self.nav_buttons[page_id] = btn
        
        # 版本信息
        version_label = ctk.CTkLabel(
            self.sidebar,
            text="版本 1.11.0",
            font=ctk.CTkFont(size=11),
            text_color=("gray50", "gray50")
        )
        version_label.grid(row=9, column=0, padx=20, pady=(10, 20), sticky="s")
    
    def create_content_area(self):
        """创建右侧内容区域"""
        # 主内容框架
        self.main_frame = ctk.CTkFrame(self.root, corner_radius=0)
        self.main_frame.grid(row=0, column=1, sticky="nsew")
        self.main_frame.grid_rowconfigure(1, weight=1)
        self.main_frame.grid_columnconfigure(0, weight=1)
        
        # 面包屑导航
        self.breadcrumb = ctk.CTkLabel(
            self.main_frame,
            text="首页 > 仪表盘",
            font=ctk.CTkFont(size=12),
            anchor="w"
        )
        self.breadcrumb.grid(row=0, column=0, padx=30, pady=(20, 10), sticky="w")
        
        # 页面容器
        self.page_container = ctk.CTkFrame(self.main_frame, fg_color="transparent")
        self.page_container.grid(row=1, column=0, padx=30, pady=(10, 30), sticky="nsew")
        self.page_container.grid_rowconfigure(0, weight=1)
        self.page_container.grid_columnconfigure(0, weight=1)
    
    def show_page(self, page_id):
        """显示指定页面"""
        # 更新导航按钮状态
        for pid, btn in self.nav_buttons.items():
            if pid == page_id:
                btn.configure(fg_color=("gray90", "gray20"), text_color=("gray10", "gray90"))
            else:
                btn.configure(fg_color="transparent", text_color=("gray10", "gray90"))
        
        # 清除当前页面
        for widget in self.page_container.winfo_children():
            widget.destroy()
        
        # 更新面包屑
        page_names = {
            "dashboard": "仪表盘",
            "migrate": "开始迁移",
            "profiles": "迁移配置",
            "history": "迁移历史",
            "symlinks": "符号链接管理",
            "settings": "设置"
        }
        self.breadcrumb.configure(text=f"首页 > {page_names.get(page_id, '')}")
        
        # 显示新页面
        self.current_page = page_id
        
        if page_id == "dashboard":
            self.create_dashboard_page()
        elif page_id == "migrate":
            self.create_migrate_page()
        elif page_id == "profiles":
            self.create_profiles_page()
        elif page_id == "history":
            self.create_history_page()
        elif page_id == "symlinks":
            self.create_symlinks_page()
        elif page_id == "settings":
            self.create_settings_page()
    
    def create_dashboard_page(self):
        """创建仪表盘页面"""
        # 创建滚动框架
        scroll_frame = ctk.CTkScrollableFrame(self.page_container)
        scroll_frame.grid(row=0, column=0, sticky="nsew")
        scroll_frame.grid_columnconfigure(0, weight=1)
        
        # 欢迎横幅
        banner = ctk.CTkFrame(scroll_frame, height=150, corner_radius=12)
        banner.grid(row=0, column=0, padx=20, pady=(0, 20), sticky="ew")
        banner.grid_columnconfigure(1, weight=1)
        
        welcome_label = ctk.CTkLabel(
            banner,
            text="欢迎使用 Windows 用户文件迁移工具",
            font=ctk.CTkFont(size=24, weight="bold"),
            anchor="w"
        )
        welcome_label.grid(row=0, column=0, padx=30, pady=(30, 10), sticky="w")
        
        subtitle_label = ctk.CTkLabel(
            banner,
            text="安全、高效地将用户文件从系统盘迁移到其他驱动器",
            font=ctk.CTkFont(size=14),
            anchor="w",
            text_color=("gray40", "gray60")
        )
        subtitle_label.grid(row=1, column=0, padx=30, pady=(0, 30), sticky="w")
        
        migrate_btn = ctk.CTkButton(
            banner,
            text="开始迁移",
            width=120,
            height=40,
            command=lambda: self.show_page("migrate")
        )
        migrate_btn.grid(row=0, column=1, rowspan=2, padx=30, pady=30, sticky="e")
        
        # 状态卡片
        cards_frame = ctk.CTkFrame(scroll_frame, fg_color="transparent")
        cards_frame.grid(row=1, column=0, padx=20, pady=(0, 20), sticky="ew")
        cards_frame.grid_columnconfigure((0, 1, 2, 3), weight=1)
        
        # 卡片数据
        cards_data = [
            ("系统盘 (C:)", "78% 已使用", "125 GB / 160 GB", "🖥️", "green"),
            ("迁移状态", "准备就绪", "上次迁移: 2026-06-20", "✅", "blue"),
            ("可迁移文件夹", "6 个", "总计约 45.2 GB", "📁", "orange"),
            ("预计时间", "约 15 分钟", "基于上次迁移速度", "⏱️", "purple")
        ]
        
        for i, (title, value, detail, icon, color) in enumerate(cards_data):
            card = ctk.CTkFrame(cards_frame, corner_radius=12)
            card.grid(row=0, column=i, padx=10, pady=10, sticky="nsew")
            
            icon_label = ctk.CTkLabel(
                card,
                text=icon,
                font=ctk.CTkFont(size=32),
                anchor="w"
            )
            icon_label.grid(row=0, column=0, padx=20, pady=(20, 10), sticky="w")
            
            title_label = ctk.CTkLabel(
                card,
                text=title,
                font=ctk.CTkFont(size=12),
                anchor="w",
                text_color=("gray50", "gray50")
            )
            title_label.grid(row=1, column=0, padx=20, pady=(0, 5), sticky="w")
            
            value_label = ctk.CTkLabel(
                card,
                text=value,
                font=ctk.CTkFont(size=18, weight="bold"),
                anchor="w"
            )
            value_label.grid(row=2, column=0, padx=20, pady=(0, 5), sticky="w")
            
            detail_label = ctk.CTkLabel(
                card,
                text=detail,
                font=ctk.CTkFont(size=11),
                anchor="w",
                text_color=("gray50", "gray50")
            )
            detail_label.grid(row=3, column=0, padx=20, pady=(0, 20), sticky="w")
        
        # 快速操作
        actions_label = ctk.CTkLabel(
            scroll_frame,
            text="快速操作",
            font=ctk.CTkFont(size=18, weight="bold"),
            anchor="w"
        )
        actions_label.grid(row=2, column=0, padx=30, pady=(20, 10), sticky="w")
        
        actions_frame = ctk.CTkFrame(scroll_frame, fg_color="transparent")
        actions_frame.grid(row=3, column=0, padx=20, pady=(0, 20), sticky="ew")
        actions_frame.grid_columnconfigure((0, 1, 2, 3), weight=1)
        
        actions_data = [
            ("🚀", "快速迁移", "使用默认配置开始迁移", self.show_migrate),
            ("💾", "加载配置", "使用已保存的迁移配置", lambda: self.show_page("profiles")),
            ("🔗", "管理链接", "查看和管理符号链接", lambda: self.show_page("symlinks")),
            ("⚙️", "高级设置", "自定义迁移选项", lambda: self.show_page("settings"))
        ]
        
        for i, (icon, title, desc, cmd) in enumerate(actions_data):
            action_card = ctk.CTkButton(
                actions_frame,
                text="",
                height=100,
                corner_radius=12,
                command=cmd,
                fg_color=("gray95", "gray15"),
                hover_color=("gray90", "gray20")
            )
            action_card.grid(row=0, column=i, padx=10, pady=10, sticky="nsew")
            action_card.grid_rowconfigure((0, 1, 2), weight=1)
            action_card.grid_columnconfigure(0, weight=1)
            
            icon_label = ctk.CTkLabel(action_card, text=icon, font=ctk.CTkFont(size=28))
            icon_label.grid(row=0, column=0, pady=(10, 0))
            
            title_label = ctk.CTkLabel(
                action_card,
                text=title,
                font=ctk.CTkFont(size=14, weight="bold")
            )
            title_label.grid(row=1, column=0)
            
            desc_label = ctk.CTkLabel(
                action_card,
                text=desc,
                font=ctk.CTkFont(size=11),
                text_color=("gray50", "gray50")
            )
            desc_label.grid(row=2, column=0, pady=(0, 10))
    
    def create_migrate_page(self):
        """创建迁移向导页面"""
        # 创建滚动框架
        scroll_frame = ctk.CTkScrollableFrame(self.page_container)
        scroll_frame.grid(row=0, column=0, sticky="nsew")
        scroll_frame.grid_columnconfigure(0, weight=1)
        
        # 标题
        title_label = ctk.CTkLabel(
            scroll_frame,
            text="开始迁移",
            font=ctk.CTkFont(size=28, weight="bold"),
            anchor="w"
        )
        title_label.grid(row=0, column=0, padx=30, pady=(0, 10), sticky="w")
        
        desc_label = ctk.CTkLabel(
            scroll_frame,
            text="选择要迁移的文件夹并配置迁移选项",
            font=ctk.CTkFont(size=14),
            anchor="w",
            text_color=("gray50", "gray50")
        )
        desc_label.grid(row=1, column=0, padx=30, pady=(0, 30), sticky="w")
        
        # 步骤指示器
        steps_frame = ctk.CTkFrame(scroll_frame, corner_radius=12)
        steps_frame.grid(row=2, column=0, padx=30, pady=(0, 30), sticky="ew")
        steps_frame.grid_columnconfigure((0, 2, 4, 6), weight=1)
        
        self.current_step = 1
        self.steps_indicators = []
        
        for i in range(1, 5):
            # 步骤圆圈
            step_frame = ctk.CTkFrame(steps_frame, fg_color="transparent")
            step_frame.grid(row=0, column=(i-1)*2, padx=10, pady=20)
            
            indicator = ctk.CTkLabel(
                step_frame,
                text=str(i),
                width=32,
                height=32,
                corner_radius=16,
                fg_color=("gray80", "gray30") if i != 1 else ("blue", "blue"),
                text_color="white",
                font=ctk.CTkFont(size=14, weight="bold")
            )
            indicator.pack()
            self.steps_indicators.append(indicator)
            
            # 步骤标签
            label = ctk.CTkLabel(
                step_frame,
                text=["选择源目录", "选择目标目录", "配置选项", "确认并执行"][i-1],
                font=ctk.CTkFont(size=12)
            )
            label.pack(pady=(5, 0))
            
            # 连接线
            if i < 4:
                connector = ctk.CTkFrame(steps_frame, height=2, fg_color=("gray80", "gray30"))
                connector.grid(row=0, column=(i-1)*2+1, sticky="ew", pady=20)
        
        # 步骤内容区域
        self.step_content = ctk.CTkFrame(scroll_frame, corner_radius=12)
        self.step_content.grid(row=3, column=0, padx=30, pady=(0, 30), sticky="ew")
        
        # 显示第一步
        self.show_step_content(1)
        
        # 导航按钮
        nav_frame = ctk.CTkFrame(scroll_frame, fg_color="transparent")
        nav_frame.grid(row=4, column=0, padx=30, pady=(0, 30), sticky="ew")
        nav_frame.grid_columnconfigure(1, weight=1)
        
        self.prev_btn = ctk.CTkButton(
            nav_frame,
            text="< 上一步",
            width=100,
            state="disabled",
            command=self.prev_step
        )
        self.prev_btn.grid(row=0, column=0, padx=(0, 10))
        
        self.next_btn = ctk.CTkButton(
            nav_frame,
            text="下一步 >",
            width=100,
            command=self.next_step
        )
        self.next_btn.grid(row=0, column=2, padx=(10, 0))
        
        self.start_btn = ctk.CTkButton(
            nav_frame,
            text="开始迁移",
            width=120,
            fg_color="green",
            hover_color="darkgreen",
            command=self.start_migration,
            state="disabled"
        )
        self.start_btn.grid(row=0, column=2, padx=(10, 0))
        self.start_btn.grid_remove()  # 隐藏开始按钮
    
    def show_step_content(self, step):
        """显示指定步骤的内容"""
        # 清除当前内容
        for widget in self.step_content.winfo_children():
            widget.destroy()
        
        self.step_content.grid_columnconfigure(0, weight=1)
        
        if step == 1:
            self.create_step1_content()
        elif step == 2:
            self.create_step2_content()
        elif step == 3:
            self.create_step3_content()
        elif step == 4:
            self.create_step4_content()
    
    def create_step1_content(self):
        """步骤1: 选择源目录"""
        title = ctk.CTkLabel(
            self.step_content,
            text="选择要迁移的用户文件夹",
            font=ctk.CTkFont(size=18, weight="bold"),
            anchor="w"
        )
        title.grid(row=0, column=0, padx=30, pady=(30, 10), sticky="w")
        
        desc = ctk.CTkLabel(
            self.step_content,
            text="选择位于系统盘（C:）的用户文件夹",
            font=ctk.CTkFont(size=13),
            anchor="w",
            text_color=("gray50", "gray50")
        )
        desc.grid(row=1, column=0, padx=30, pady=(0, 20), sticky="w")
        
        # 文件夹列表
        folders = [
            ("文档", "C:\\Users\\Username\\Documents", "2.5 GB"),
            ("图片", "C:\\Users\\Username\\Pictures", "8.3 GB"),
            ("音乐", "C:\\Users\\Username\\Music", "3.1 GB"),
            ("视频", "C:\\Users\\Username\\Videos", "15.7 GB"),
            ("下载", "C:\\Users\\Username\\Downloads", "5.2 GB"),
            ("桌面", "C:\\Users\\Username\\Desktop", "1.8 GB")
        ]
        
        self.folder_checkboxes = {}
        
        for i, (name, path, size) in enumerate(folders):
            frame = ctk.CTkFrame(self.step_content, corner_radius=8)
            frame.grid(row=i+2, column=0, padx=30, pady=(0, 10), sticky="ew")
            frame.grid_columnconfigure(1, weight=1)
            
            var = ctk.StringVar(value="1" if name == "文档" else "0")
            checkbox = ctk.CTkCheckBox(
                frame,
                text="",
                variable=var,
                onvalue="1",
                offvalue="0"
            )
            checkbox.grid(row=0, column=0, padx=(15, 10), pady=15)
            self.folder_checkboxes[name] = var
            
            name_label = ctk.CTkLabel(
                frame,
                text=name,
                font=ctk.CTkFont(size=14, weight="bold"),
                anchor="w"
            )
            name_label.grid(row=0, column=1, padx=(0, 10), pady=15, sticky="w")
            
            path_label = ctk.CTkLabel(
                frame,
                text=path,
                font=ctk.CTkFont(size=12),
                anchor="w",
                text_color=("gray50", "gray50")
            )
            path_label.grid(row=0, column=2, padx=10, pady=15, sticky="w")
            
            size_label = ctk.CTkLabel(
                frame,
                text=size,
                font=ctk.CTkFont(size=12),
                anchor="e"
            )
            size_label.grid(row=0, column=3, padx=(10, 15), pady=15, sticky="e")
    
    def create_step2_content(self):
        """步骤2: 选择目标目录"""
        title = ctk.CTkLabel(
            self.step_content,
            text="选择迁移目标位置",
            font=ctk.CTkFont(size=18, weight="bold"),
            anchor="w"
        )
        title.grid(row=0, column=0, padx=30, pady=(30, 10), sticky="w")
        
        desc = ctk.CTkLabel(
            self.step_content,
            text="选择非系统盘的目标位置",
            font=ctk.CTkFont(size=13),
            anchor="w",
            text_color=("gray50", "gray50")
        )
        desc.grid(row=1, column=0, padx=30, pady=(0, 20), sticky="w")
        
        # 目标驱动器选择
        drives_frame = ctk.CTkFrame(self.step_content, fg_color="transparent")
        drives_frame.grid(row=2, column=0, padx=30, pady=(0, 20), sticky="ew")
        drives_frame.grid_columnconfigure((0, 1), weight=1)
        
        self.target_drive = ctk.StringVar(value="E:")
        
        drive_radio1 = ctk.CTkRadioButton(
            drives_frame,
            text="E: 数据盘 (500 GB 可用)",
            variable=self.target_drive,
            value="E:",
            font=ctk.CTkFont(size=14)
        )
        drive_radio1.grid(row=0, column=0, padx=10, pady=10, sticky="w")
        
        drive_radio2 = ctk.CTkRadioButton(
            drives_frame,
            text="F: 备份盘 (200 GB 可用)",
            variable=self.target_drive,
            value="F:",
            font=ctk.CTkFont(size=14)
        )
        drive_radio2.grid(row=0, column=1, padx=10, pady=10, sticky="w")
        
        # 自定义路径
        custom_frame = ctk.CTkFrame(self.step_content, fg_color="transparent")
        custom_frame.grid(row=3, column=0, padx=30, pady=(0, 20), sticky="ew")
        custom_frame.grid_columnconfigure(1, weight=1)
        
        custom_label = ctk.CTkLabel(
            custom_frame,
            text="或自定义路径:",
            font=ctk.CTkFont(size=13),
            anchor="w"
        )
        custom_label.grid(row=0, column=0, padx=(0, 10), pady=10, sticky="w")
        
        self.custom_path = ctk.CTkEntry(
            custom_frame,
            placeholder_text="D:\\MyData",
            height=40
        )
        self.custom_path.grid(row=0, column=1, padx=(0, 10), pady=10, sticky="ew")
        self.custom_path.insert(0, "E:\\Users")
        
        browse_btn = ctk.CTkButton(
            custom_frame,
            text="浏览",
            width=80,
            height=40,
            command=self.browse_target_folder
        )
        browse_btn.grid(row=0, column=2, pady=10)
    
    def create_step3_content(self):
        """步骤3: 配置选项"""
        title = ctk.CTkLabel(
            self.step_content,
            text="配置迁移选项",
            font=ctk.CTkFont(size=18, weight="bold"),
            anchor="w"
        )
        title.grid(row=0, column=0, padx=30, pady=(30, 10), sticky="w")
        
        desc = ctk.CTkLabel(
            self.step_content,
            text="自定义迁移行为",
            font=ctk.CTkFont(size=13),
            anchor="w",
            text_color=("gray50", "gray50")
        )
        desc.grid(row=1, column=0, padx=30, pady=(0, 20), sticky="w")
        
        # 选项列表
        options = [
            ("复制后验证", "比较源文件和目标文件，确保数据完整性", "verify", True),
            ("创建符号链接", "在原位置创建符号链接，保持应用兼容性", "symlink", True),
            ("迁移后删除源文件", "成功迁移后删除源位置的文件（释放空间）", "delete", False),
            ("使用快速模式", "跳过已有文件，加快迁移速度", "fast", True)
        ]
        
        self.option_vars = {}
        
        for i, (title_text, desc_text, key, default) in enumerate(options):
            frame = ctk.CTkFrame(self.step_content, corner_radius=8)
            frame.grid(row=i+2, column=0, padx=30, pady=(0, 10), sticky="ew")
            frame.grid_columnconfigure(0, weight=1)
            
            text_frame = ctk.CTkFrame(frame, fg_color="transparent")
            text_frame.grid(row=0, column=0, padx=15, pady=15, sticky="w")
            
            title_label = ctk.CTkLabel(
                text_frame,
                text=title_text,
                font=ctk.CTkFont(size=14, weight="bold"),
                anchor="w"
            )
            title_label.pack(anchor="w")
            
            desc_label = ctk.CTkLabel(
                text_frame,
                text=desc_text,
                font=ctk.CTkFont(size=12),
                anchor="w",
                text_color=("gray50", "gray50")
            )
            desc_label.pack(anchor="w", pady=(5, 0))
            
            var = ctk.StringVar(value="1" if default else "0")
            switch = ctk.CTkSwitch(
                frame,
                text="",
                variable=var,
                onvalue="1",
                offvalue="0"
            )
            switch.grid(row=0, column=1, padx=15, pady=15)
            self.option_vars[key] = var
    
    def create_step4_content(self):
        """步骤4: 确认并执行"""
        title = ctk.CTkLabel(
            self.step_content,
            text="确认迁移设置",
            font=ctk.CTkFont(size=18, weight="bold"),
            anchor="w"
        )
        title.grid(row=0, column=0, padx=30, pady=(30, 10), sticky="w")
        
        desc = ctk.CTkLabel(
            self.step_content,
            text="请检查以下设置，确认无误后点击"开始迁移"",
            font=ctk.CTkFont(size=13),
            anchor="w",
            text_color=("gray50", "gray50")
        )
        desc.grid(row=1, column=0, padx=30, pady=(0, 20), sticky="w")
        
        # 确认摘要
        summary = ctk.CTkFrame(self.step_content, corner_radius=12)
        summary.grid(row=2, column=0, padx=30, pady=(0, 20), sticky="ew")
        summary.grid_columnconfigure(0, weight=1)
        
        # 获取选中的文件夹
        selected_folders = [name for name, var in self.folder_checkboxes.items() if var.get() == "1"]
        
        row = 0
        
        # 要迁移的文件夹
        folder_title = ctk.CTkLabel(
            summary,
            text="要迁移的文件夹:",
            font=ctk.CTkFont(size=14, weight="bold"),
            anchor="w"
        )
        folder_title.grid(row=row, column=0, padx=30, pady=(20, 10), sticky="w")
        row += 1
        
        for folder in selected_folders:
            folder_label = ctk.CTkLabel(
                summary,
                text=f"  • {folder}",
                font=ctk.CTkFont(size=13),
                anchor="w"
            )
            folder_label.grid(row=row, column=0, padx=30, pady=(0, 5), sticky="w")
            row += 1
        
        # 目标位置
        target_title = ctk.CTkLabel(
            summary,
            text="目标位置:",
            font=ctk.CTkFont(size=14, weight="bold"),
            anchor="w"
        )
        target_title.grid(row=row, column=0, padx=30, pady=(20, 10), sticky="w")
        row += 1
        
        target_path = self.custom_path.get() if self.custom_path.get() else self.target_drive.get()
        target_label = ctk.CTkLabel(
            summary,
            text=f"  {target_path}\\Username",
            font=ctk.CTkFont(size=13),
            anchor="w"
        )
        target_label.grid(row=row, column=0, padx=30, pady=(0, 20), sticky="w")
        row += 1
        
        # 警告
        warning = ctk.CTkFrame(summary, corner_radius=8, fg_color=("orange95", "orange10"))
        warning.grid(row=row, column=0, padx=30, pady=(0, 20), sticky="ew")
        
        warning_label = ctk.CTkLabel(
            warning,
            text="⚠️ 注意: 迁移过程可能需要几分钟到几十分钟，取决于文件大小。请确保目标磁盘有足够空间。",
            font=ctk.CTkFont(size=12),
            anchor="w",
            wraplength=600
        )
        warning_label.grid(row=0, column=0, padx=20, pady=15, sticky="w")
    
    def next_step(self):
        """下一步"""
        if self.current_step < 4:
            self.current_step += 1
            self.update_step_indicators()
            self.show_step_content(self.current_step)
            
            self.prev_btn.configure(state="normal")
            
            if self.current_step == 4:
                self.next_btn.grid_remove()
                self.start_btn.grid()
                self.start_btn.configure(state="normal")
    
    def prev_step(self):
        """上一步"""
        if self.current_step > 1:
            self.current_step -= 1
            self.update_step_indicators()
            self.show_step_content(self.current_step)
            
            self.next_btn.grid()
            self.start_btn.grid_remove()
            
            if self.current_step == 1:
                self.prev_btn.configure(state="disabled")
    
    def update_step_indicators(self):
        """更新步骤指示器"""
        for i, indicator in enumerate(self.steps_indicators):
            if i + 1 == self.current_step:
                indicator.configure(fg_color=("blue", "blue"))
            elif i + 1 < self.current_step:
                indicator.configure(fg_color=("green", "green"))
            else:
                indicator.configure(fg_color=("gray80", "gray30"))
    
    def browse_target_folder(self):
        """浏览目标文件夹"""
        folder = filedialog.askdirectory()
        if folder:
            self.custom_path.delete(0, "end")
            self.custom_path.insert(0, folder)
    
    def start_migration(self):
        """开始迁移"""
        # 这里应该实现实际的迁移逻辑
        # 目前只是显示一个成功消息
        messagebox.showinfo("迁移", "迁移功能正在开发中...\n\n实际实现需要调用 Robocopy 等工具。")
    
    def create_profiles_page(self):
        """创建配置管理页面"""
        # 占位符 - 实际实现类似仪表盘页面
        label = ctk.CTkLabel(
            self.page_container,
            text="迁移配置页面 - 开发中",
            font=ctk.CTkFont(size=24, weight="bold")
        )
        label.grid(row=0, column=0, padx=30, pady=30)
    
    def create_history_page(self):
        """创建历史记录页面"""
        # 占位符 - 实际实现类似仪表盘页面
        label = ctk.CTkLabel(
            self.page_container,
            text="迁移历史页面 - 开发中",
            font=ctk.CTkFont(size=24, weight="bold")
        )
        label.grid(row=0, column=0, padx=30, pady=30)
    
    def create_symlinks_page(self):
        """创建符号链接管理页面"""
        # 占位符 - 实际实现类似仪表盘页面
        label = ctk.CTkLabel(
            self.page_container,
            text="符号链接管理页面 - 开发中",
            font=ctk.CTkFont(size=24, weight="bold")
        )
        label.grid(row=0, column=0, padx=30, pady=30)
    
    def create_settings_page(self):
        """创建设置页面"""
        # 占位符 - 实际实现类似仪表盘页面
        label = ctk.CTkLabel(
            self.page_container,
            text="设置页面 - 开发中",
            font=ctk.CTkFont(size=24, weight="bold")
        )
        label.grid(row=0, column=0, padx=30, pady=30)
    
    def show_migrate(self):
        """显示迁移页面"""
        self.show_page("migrate")
    
    def run(self):
        """运行应用"""
        self.root.mainloop()


if __name__ == "__main__":
    # 检查是否安装了 customtkinter
    try:
        app = WindowsMigrationApp()
        app.run()
    except ImportError:
        print("错误: 未安装 customtkinter")
        print("请运行: pip install customtkinter")
        print("\n然后重新运行此脚本。")
