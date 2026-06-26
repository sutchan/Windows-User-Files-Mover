#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
开发配置文件夹迁移工具 - 图形界面版本

功能：
  将开发工具配置目录（.vscode、.cursor、.workbuddy 等）从系统盘迁移到其他分区，
  使用 NTFS 目录联接（Junction Point）保持路径兼容，应用程序无感知。

作者：SutChan
版本：v1.11.0
项目地址：https://github.com/sutchan/Windows-User-Files-Mover
"""

import os
import sys
import ctypes
import threading
import subprocess
import shutil
from datetime import datetime
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext

# ──────────────────────────────────────────────
#  常量
# ──────────────────────────────────────────────
APP_TITLE   = "开发配置文件夹迁移工具"
APP_VERSION = "v1.11.0"
APP_AUTHOR  = "SutChan"
APP_URL     = "https://github.com/sutchan/Windows-User-Files-Mover"

USERNAME     = os.environ.get("USERNAME") or os.getlogin()
DEFAULT_SRC  = os.path.expanduser("~")                          # C:\Users\<name>
DEFAULT_DST  = f"E:\\Users\\{USERNAME}"

DEFAULT_FOLDERS = [
    ".codebuddy",
    ".codebuddycn",
    ".codex",
    ".cursor",
    ".gemini",
    ".lingma",
    ".trae",
    ".trae-aicc",
    ".trae-cn",
    ".vscode",
    ".workbuddy",
]

# ──────────────────────────────────────────────
#  工具函数
# ──────────────────────────────────────────────

def is_admin() -> bool:
    try:
        return bool(ctypes.windll.shell32.IsUserAnAdmin())
    except Exception:
        return False


def request_admin():
    """以管理员身份重启自身"""
    params = " ".join(f'"{a}"' if " " in a else a for a in sys.argv)
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)


def is_junction(path: str) -> bool:
    """判断路径是否为 Junction Point"""
    try:
        item = subprocess.run(
            ["cmd", "/c", f'fsutil reparsepoint query "{path}" >nul 2>&1 && echo JUNCTION'],
            capture_output=True, text=True
        )
        # 备用：通过 FILE_ATTRIBUTE_REPARSE_POINT 检测
        attrs = ctypes.windll.kernel32.GetFileAttributesW(path)
        return bool(attrs != 0xFFFFFFFF and attrs & 0x400)
    except Exception:
        return False


def get_dir_size_mb(path: str) -> float:
    """粗略统计目录大小（MB）"""
    total = 0
    try:
        for dirpath, _, files in os.walk(path):
            for f in files:
                fp = os.path.join(dirpath, f)
                try:
                    total += os.path.getsize(fp)
                except OSError:
                    pass
    except Exception:
        pass
    return total / (1024 * 1024)


def get_free_space_mb(drive: str) -> float:
    """获取指定盘符的剩余空间（MB）"""
    try:
        free_bytes = ctypes.c_ulonglong(0)
        ctypes.windll.kernel32.GetDiskFreeSpaceExW(
            drive, None, None, ctypes.byref(free_bytes)
        )
        return free_bytes.value / (1024 * 1024)
    except Exception:
        return 0.0


# ──────────────────────────────────────────────
#  主窗口
# ──────────────────────────────────────────────

class DevConfigsMoverApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title(f"{APP_TITLE}  {APP_VERSION}")
        self.root.geometry("860x680")
        self.root.minsize(760, 580)
        self.root.resizable(True, True)

        self._running = False
        self._log_file = os.path.join(
            os.path.dirname(os.path.abspath(sys.argv[0])),
            "Move_DevConfigs_GUI.log"
        )

        self._setup_style()
        self._build_ui()

        # 启动时权限检测
        if not is_admin():
            self._log("[警告] 当前未以管理员身份运行，迁移操作将失败。", "warn")

    # ── 样式 ──────────────────────────────────

    def _setup_style(self):
        style = ttk.Style()
        try:
            style.theme_use("vista")
        except Exception:
            pass

        style.configure("Title.TLabel",  foreground="#1565C0")
        style.configure("Info.TLabel",   foreground="#757575")
        style.configure("Warn.TLabel",   foreground="#C62828")
        style.configure("Action.TButton", padding=(12, 4))

    # ── UI 构建 ───────────────────────────────

    def _build_ui(self):
        # 顶部标题
        header = ttk.Frame(self.root, padding=(14, 10, 14, 4))
        header.pack(fill=tk.X)

        ttk.Label(header, text=f"  {APP_TITLE}", style="Title.TLabel").pack(side=tk.LEFT)

        info_right = ttk.Frame(header)
        info_right.pack(side=tk.RIGHT)
        ttk.Label(info_right, text=f"版本 {APP_VERSION}  |  作者 {APP_AUTHOR}", style="Info.TLabel").pack(anchor=tk.E)
        ttk.Label(info_right, text=APP_URL, style="Info.TLabel", cursor="hand2").pack(anchor=tk.E)

        ttk.Separator(self.root, orient=tk.HORIZONTAL).pack(fill=tk.X, padx=14)

        # 主内容区
        body = ttk.Frame(self.root, padding=(14, 8, 14, 4))
        body.pack(fill=tk.BOTH, expand=True)

        body.columnconfigure(0, weight=1)
        body.rowconfigure(2, weight=1)  # 文件夹列表行可伸展
        body.rowconfigure(4, weight=2)  # 日志区可伸展

        # ─ 路径配置 ──────────────────────────
        path_frame = ttk.LabelFrame(body, text="路径配置", padding=(10, 6))
        path_frame.grid(row=0, column=0, sticky="ew", pady=(0, 8))
        path_frame.columnconfigure(1, weight=1)

        ttk.Label(path_frame, text="源目录（系统盘）：").grid(row=0, column=0, sticky=tk.W, padx=4, pady=4)
        self.src_var = tk.StringVar(value=DEFAULT_SRC)
        src_entry = ttk.Entry(path_frame, textvariable=self.src_var)
        src_entry.grid(row=0, column=1, sticky="ew", padx=4, pady=4)
        ttk.Button(path_frame, text="浏览…", command=lambda: self._browse(self.src_var)).grid(row=0, column=2, padx=4)

        ttk.Label(path_frame, text="目标目录（目标盘）：").grid(row=1, column=0, sticky=tk.W, padx=4, pady=4)
        self.dst_var = tk.StringVar(value=DEFAULT_DST)
        dst_entry = ttk.Entry(path_frame, textvariable=self.dst_var)
        dst_entry.grid(row=1, column=1, sticky="ew", padx=4, pady=4)
        ttk.Button(path_frame, text="浏览…", command=lambda: self._browse(self.dst_var)).grid(row=1, column=2, padx=4)

        # ─ 选项 ──────────────────────────────
        opt_frame = ttk.LabelFrame(body, text="迁移选项", padding=(10, 6))
        opt_frame.grid(row=1, column=0, sticky="ew", pady=(0, 8))

        self.whatif_var = tk.BooleanVar(value=False)
        ttk.Checkbutton(opt_frame, text="预览模式（WhatIf）—— 不执行实际操作，仅显示将要做的事",
                        variable=self.whatif_var).pack(anchor=tk.W)

        self.verify_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(opt_frame, text="复制后验证文件数量一致性",
                        variable=self.verify_var).pack(anchor=tk.W)

        # ─ 文件夹列表 ─────────────────────────
        list_frame = ttk.LabelFrame(body, text="要迁移的配置文件夹", padding=(10, 6))
        list_frame.grid(row=2, column=0, sticky="nsew", pady=(0, 8))
        list_frame.columnconfigure(0, weight=1)
        list_frame.rowconfigure(0, weight=1)

        # 列表框 + 滚动条
        lf_inner = ttk.Frame(list_frame)
        lf_inner.grid(row=0, column=0, sticky="nsew", columnspan=3)
        lf_inner.columnconfigure(0, weight=1)
        lf_inner.rowconfigure(0, weight=1)

        vsb = ttk.Scrollbar(lf_inner, orient=tk.VERTICAL)
        vsb.pack(side=tk.RIGHT, fill=tk.Y)

        self.folder_listbox = tk.Listbox(
            lf_inner,
            selectmode=tk.MULTIPLE,
            font=("Consolas", 10),
            height=8,
            yscrollcommand=vsb.set,
            bd=1, relief=tk.SUNKEN,
            selectbackground="#1565C0",
            selectforeground="white",
        )
        self.folder_listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        vsb.config(command=self.folder_listbox.yview)

        for folder in DEFAULT_FOLDERS:
            self.folder_listbox.insert(tk.END, folder)
        # 默认全选
        self.folder_listbox.selection_set(0, tk.END)

        # 列表操作按钮行
        btn_list_row = ttk.Frame(list_frame)
        btn_list_row.grid(row=1, column=0, sticky="ew", pady=(4, 0))

        ttk.Button(btn_list_row, text="全选",     command=self._select_all).pack(side=tk.LEFT, padx=4)
        ttk.Button(btn_list_row, text="取消全选", command=self._deselect_all).pack(side=tk.LEFT, padx=4)
        ttk.Button(btn_list_row, text="扫描实际存在的目录", command=self._scan_existing).pack(side=tk.LEFT, padx=12)

        # 自定义输入
        add_row = ttk.Frame(list_frame)
        add_row.grid(row=2, column=0, sticky="ew", pady=(4, 0))
        ttk.Label(add_row, text="添加自定义文件夹：").pack(side=tk.LEFT)
        self.custom_folder_var = tk.StringVar()
        ttk.Entry(add_row, textvariable=self.custom_folder_var, width=24).pack(side=tk.LEFT, padx=4)
        ttk.Button(add_row, text="➕ 添加", command=self._add_custom).pack(side=tk.LEFT)
        ttk.Button(add_row, text="🗑 删除选中", command=self._remove_selected).pack(side=tk.LEFT, padx=8)

        # ─ 状态 & 操作按钮 ───────────────────
        act_frame = ttk.Frame(body)
        act_frame.grid(row=3, column=0, sticky="ew", pady=(0, 6))
        act_frame.columnconfigure(0, weight=1)

        self.status_var = tk.StringVar(value="就绪")
        self.status_label = ttk.Label(act_frame, textvariable=self.status_var, style="Info.TLabel")
        self.status_label.grid(row=0, column=0, sticky=tk.W)

        btn_row = ttk.Frame(act_frame)
        btn_row.grid(row=0, column=1)

        self.btn_preview = ttk.Button(btn_row, text="🔍 扫描状态", command=self._do_scan_status, width=14)
        self.btn_preview.pack(side=tk.LEFT, padx=4)

        self.btn_run = ttk.Button(btn_row, text="🚀 开始迁移", command=self._do_migrate,
                                  style="Action.TButton", width=14)
        self.btn_run.pack(side=tk.LEFT, padx=4)

        ttk.Button(btn_row, text="清空日志", command=self._clear_log, width=10).pack(side=tk.LEFT, padx=4)

        # ─ 日志区域 ──────────────────────────
        log_frame = ttk.LabelFrame(body, text="操作日志", padding=(6, 4))
        log_frame.grid(row=4, column=0, sticky="nsew", pady=(0, 4))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)

        self.log_text = scrolledtext.ScrolledText(
            log_frame,
            wrap=tk.WORD,
            font=("Consolas", 9),
            bg="#1E1E1E",
            fg="#D4D4D4",
            insertbackground="#FFFFFF",
            selectbackground="#264F78",
            bd=0, relief=tk.FLAT,
            state=tk.DISABLED,
        )
        self.log_text.pack(fill=tk.BOTH, expand=True)

        # 日志颜色标签
        self.log_text.tag_config("info",    foreground="#9CDCFE")
        self.log_text.tag_config("success", foreground="#4EC9B0")
        self.log_text.tag_config("warn",    foreground="#CE9178")
        self.log_text.tag_config("error",   foreground="#F44747")
        self.log_text.tag_config("skip",    foreground="#808080")
        self.log_text.tag_config("head",    foreground="#DCDCAA")

        # 右键菜单
        ctx = tk.Menu(self.root, tearoff=0)
        ctx.add_command(label="复制选中", command=self._copy_log)
        ctx.add_command(label="清空日志", command=self._clear_log)
        self.log_text.bind("<Button-3>", lambda e: ctx.post(e.x_root, e.y_root))

        self._log(f"[{APP_TITLE}] {APP_VERSION} 启动完成", "head")
        self._log(f"当前用户：{USERNAME}   源目录：{DEFAULT_SRC}", "info")

    # ── 辅助 UI 方法 ──────────────────────────

    def _browse(self, var: tk.StringVar):
        path = filedialog.askdirectory(initialdir=var.get() or os.path.expanduser("~"))
        if path:
            var.set(os.path.normpath(path))

    def _select_all(self):
        self.folder_listbox.selection_set(0, tk.END)

    def _deselect_all(self):
        self.folder_listbox.selection_clear(0, tk.END)

    def _add_custom(self):
        val = self.custom_folder_var.get().strip()
        if val:
            # 检查是否已存在
            existing = list(self.folder_listbox.get(0, tk.END))
            if val not in existing:
                self.folder_listbox.insert(tk.END, val)
                self.folder_listbox.selection_set(tk.END)
            self.custom_folder_var.set("")

    def _remove_selected(self):
        idxs = list(self.folder_listbox.curselection())
        for i in reversed(idxs):
            self.folder_listbox.delete(i)

    def _scan_existing(self):
        """仅保留在源目录中实际存在的文件夹"""
        src = self.src_var.get()
        all_items = list(self.folder_listbox.get(0, tk.END))
        self.folder_listbox.delete(0, tk.END)
        self.folder_listbox.selection_clear(0, tk.END)
        for item in all_items:
            full = os.path.join(src, item)
            self.folder_listbox.insert(tk.END, item)
            if os.path.exists(full):
                idx = self.folder_listbox.size() - 1
                self.folder_listbox.selection_set(idx)
        self._log(f"扫描完成，{self.folder_listbox.size()} 个文件夹已列出，已勾选实际存在的条目。", "info")

    def _copy_log(self):
        try:
            sel = self.log_text.get(tk.SEL_FIRST, tk.SEL_LAST)
            self.root.clipboard_clear()
            self.root.clipboard_append(sel)
        except tk.TclError:
            pass

    def _clear_log(self):
        self.log_text.config(state=tk.NORMAL)
        self.log_text.delete(1.0, tk.END)
        self.log_text.config(state=tk.DISABLED)

    # ── 日志 ──────────────────────────────────

    def _log(self, msg: str, level: str = "info"):
        ts  = datetime.now().strftime("%H:%M:%S")
        line = f"[{ts}] {msg}\n"

        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, line, level)
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)
        self.root.update_idletasks()

        try:
            with open(self._log_file, "a", encoding="utf-8") as f:
                f.write(line)
        except Exception:
            pass

    def _set_status(self, text: str):
        self.status_var.set(text)
        self.root.update_idletasks()

    # ── 扫描状态 ──────────────────────────────

    def _do_scan_status(self):
        src     = self.src_var.get()
        folders = list(self.folder_listbox.get(0, tk.END))
        selected_idx = set(self.folder_listbox.curselection())

        self._log("=" * 55, "head")
        self._log("  目录状态扫描", "head")
        self._log("=" * 55, "head")

        for i, folder in enumerate(folders):
            full = os.path.join(src, folder)
            if not os.path.exists(full):
                tag = "skip"
                status_str = "不存在 — 跳过"
            elif is_junction(full):
                tag = "success"
                status_str = "✓ 已是联接点 — 无需迁移"
            else:
                size_mb = get_dir_size_mb(full)
                tag = "info" if i in selected_idx else "skip"
                status_str = f"待迁移  {size_mb:.1f} MB"
            self._log(f"  {folder:<22} {status_str}", tag)

        self._log("扫描完成。", "info")

    # ── 迁移核心 ──────────────────────────────

    def _do_migrate(self):
        if self._running:
            messagebox.showwarning("请稍候", "当前有迁移任务正在执行，请等待完成。")
            return

        # 权限检查
        if not is_admin():
            if messagebox.askyesno("权限不足",
                                   "当前程序没有管理员权限。\n"
                                   "创建目录联接必须以管理员身份运行。\n\n"
                                   "是否以管理员身份重启？"):
                request_admin()
                sys.exit()
            return

        src      = self.src_var.get().strip()
        dst      = self.dst_var.get().strip()
        whatif   = self.whatif_var.get()
        verify   = self.verify_var.get()
        selected = [self.folder_listbox.get(i)
                    for i in self.folder_listbox.curselection()]

        if not selected:
            messagebox.showwarning("未选择", "请至少勾选一个要迁移的文件夹。")
            return

        if not os.path.isdir(src):
            messagebox.showerror("路径错误", f"源目录不存在：\n{src}")
            return

        drive = os.path.splitdrive(dst)[0] + "\\"
        free_mb = get_free_space_mb(drive)
        self._log(f"目标盘 {drive} 剩余空间：{free_mb:.0f} MB", "info")

        if not whatif:
            msg = (f"即将迁移 {len(selected)} 个文件夹\n"
                   f"  源：{src}\n  目标：{dst}\n\n"
                   "迁移完成后源目录将替换为联接点，请确认数据已备份。\n\n继续？")
            if not messagebox.askyesno("确认迁移", msg, icon="warning"):
                return

        self._running = True
        self.btn_run.config(state=tk.DISABLED)
        self.btn_preview.config(state=tk.DISABLED)

        def worker():
            try:
                self._migrate_worker(src, dst, selected, whatif, verify)
            finally:
                self._running = False
                self.root.after(0, lambda: self.btn_run.config(state=tk.NORMAL))
                self.root.after(0, lambda: self.btn_preview.config(state=tk.NORMAL))

        threading.Thread(target=worker, daemon=True).start()

    def _migrate_worker(self, src: str, dst: str, folders: list,
                         whatif: bool, verify: bool):
        success_n = skip_n = fail_n = 0

        self._log("=" * 55, "head")
        mode_str = "[ 预览模式 WhatIf ]" if whatif else "[ 执行模式 ]"
        self._log(f"  开发配置文件夹迁移  {mode_str}", "head")
        self._log(f"  源：{src}", "info")
        self._log(f"  目标：{dst}", "info")
        self._log("=" * 55, "head")

        # 确保目标根目录存在
        if not whatif:
            os.makedirs(dst, exist_ok=True)

        for folder in folders:
            src_path = os.path.join(src, folder)
            dst_path = os.path.join(dst, folder)

            self._log(f"\n─── {folder} ───", "head")
            self._set_status(f"正在处理：{folder}")

            # 1. 源目录不存在
            if not os.path.exists(src_path):
                self._log(f"  ⊘ 源目录不存在，跳过", "skip")
                skip_n += 1
                continue

            # 2. 已经是联接点
            if is_junction(src_path):
                self._log(f"  ⊘ 已是联接点，无需迁移", "skip")
                skip_n += 1
                continue

            if whatif:
                size_mb = get_dir_size_mb(src_path)
                self._log(f"  [WhatIf] 将执行：Robocopy {src_path!r} → {dst_path!r}  ({size_mb:.1f} MB)", "warn")
                self._log(f"  [WhatIf] 将执行：rmdir {src_path!r}", "warn")
                self._log(f"  [WhatIf] 将执行：mklink /J {src_path!r} {dst_path!r}", "warn")
                skip_n += 1
                continue

            try:
                # 3. ROBOCOPY
                self._log(f"  → 正在复制到目标盘…", "info")
                robo_args = [
                    "robocopy", src_path, dst_path,
                    "/E", "/COPYALL", "/R:1", "/W:1",
                    "/NFL", "/NDL", "/NJH", "/NJS"
                ]
                result = subprocess.run(robo_args, capture_output=True, text=True)
                if result.returncode >= 8:
                    raise RuntimeError(f"Robocopy 失败，退出码 {result.returncode}\n{result.stderr}")
                self._log(f"  ✓ 复制完成（Robocopy 退出码 {result.returncode}）", "success")

                # 4. 验证
                if verify:
                    src_count = sum(len(files) for _, _, files in os.walk(src_path))
                    dst_count = sum(len(files) for _, _, files in os.walk(dst_path))
                    if src_count != dst_count:
                        raise RuntimeError(
                            f"文件数量不一致！源：{src_count}，目标：{dst_count}，中止操作。"
                        )
                    self._log(f"  ✓ 验证通过（{dst_count} 个文件）", "success")

                # 5. 删除源目录
                self._log(f"  → 删除原目录…", "info")
                shutil.rmtree(src_path)
                self._log(f"  ✓ 原目录已删除", "success")

                # 6. 创建 Junction Point
                self._log(f"  → 创建目录联接…", "info")
                mk_result = subprocess.run(
                    ["cmd", "/c", "mklink", "/J", src_path, dst_path],
                    capture_output=True, text=True
                )
                if mk_result.returncode != 0:
                    raise RuntimeError(f"mklink 失败：{mk_result.stdout}{mk_result.stderr}")

                # 7. 联接验证
                if is_junction(src_path):
                    self._log(f"  ✅ 迁移成功  {folder}", "success")
                    success_n += 1
                else:
                    raise RuntimeError("联接创建后验证失败。")

            except Exception as exc:
                self._log(f"  ❌ 失败：{exc}", "error")
                if os.path.isdir(dst_path):
                    self._log(f"  ⚠ 目标副本已保留：{dst_path}", "warn")
                fail_n += 1

        # 汇总
        self._log("\n" + "=" * 55, "head")
        self._log("  迁移汇总", "head")
        self._log("=" * 55, "head")
        self._log(f"  ✅ 成功：{success_n}", "success")
        self._log(f"  ⊘  跳过：{skip_n}",   "skip")
        self._log(f"  ❌ 失败：{fail_n}",    "error" if fail_n else "success")
        self._log("=" * 55, "head")

        self._set_status(f"完成 — 成功 {success_n} / 跳过 {skip_n} / 失败 {fail_n}")

        if fail_n:
            self.root.after(0, lambda: messagebox.showwarning(
                "部分失败",
                f"迁移完成，但有 {fail_n} 个文件夹失败。\n请查看日志了解详情。"
            ))
        elif success_n > 0:
            self.root.after(0, lambda: messagebox.showinfo(
                "迁移完成",
                f"全部 {success_n} 个文件夹已成功迁移！"
            ))


# ──────────────────────────────────────────────
#  入口
# ──────────────────────────────────────────────

def main():
    if sys.platform != "win32":
        print("此工具仅支持 Windows 操作系统。")
        sys.exit(1)

    root = tk.Tk()

    DevConfigsMoverApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
