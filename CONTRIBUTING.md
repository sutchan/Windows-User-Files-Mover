# 贡献指南

感谢您考虑为 Windows-User-Files-Mover 做出贡献！💙

本文档提供了参与本项目的指南，包括如何提交 Issue、提交 Pull Request、代码规范等。

---

## 🌟 如何贡献

您可以通过多种方式为本项目做出贡献：

1. **报告 Bug** - 发现 Bug？请创建 Issue 报告
2. **提出新功能** - 有新想法？请创建 Feature Request
3. **提交代码** - 修复 Bug 或实现新功能？请提交 Pull Request
4. **改进文档** - 文档有错误或不够清晰？请提交 PR 改进
5. **回答问题** - 在 Issue 中帮助其他用户

---

## 🐛 报告 Bug

### 在创建 Bug 报告之前

1. **检查现有 Issue** - 确保没有人报告过相同的问题
2. **使用最新版本** - 确保您使用的是最新版本（v1.12.0）
3. **复现步骤** - 尝试找到可复现的步骤

### 创建 Bug 报告

请创建 Issue 并使用以下模板：

```markdown
**Bug 描述**
简明扼要地描述 bug。

**重现步骤**
1. 转到 '...'
2. 点击 '....'
3. 滚动到 '....'
4. 看到错误

**预期行为**
简明扼要地描述您期望发生的事情。

**实际行为**
发生了什么。

**截图**
如果适用，请添加截图来帮助解释您的问题。

**环境**
- 操作系统：[例如 Windows 10 21H2]
- Python 版本：[例如 Python 3.9]
- 项目版本：[例如 v1.12.0]
- 使用的版本：[例如 Python GUI 版 / EXE 版 / 批处理版]

**附加信息**
添加任何其他关于问题的信息。
```

---

## ✨ 提出新功能

### 在创建功能请求之前

1. **检查现有 Issue** - 确保没有人提出过类似的功能
2. **考虑范围** - 新功能是否符合项目的目标？
3. **描述清晰** - 清楚地描述新功能的使用场景

### 创建功能请求

请创建 Issue 并使用以下模板：

```markdown
**功能描述**
简明扼要地描述新功能。

**使用场景**
描述为什么需要这个功能，解决什么问题。

**解决方案**
如果可能，描述您期望的实现方式。

**替代方案**
描述您考虑过的任何其他解决方案。

**附加信息**
添加任何其他的上下文或截图。
```

---

## 🔧 提交代码

### 开发流程

1. **Fork 本仓库**
   - 点击右上角的 "Fork" 按钮

2. **克隆您的 Fork**
   ```bash
   git clone https://github.com/<your-username>/Windows-User-Files-Mover.git
   cd Windows-User-Files-Mover
   ```

3. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/your-bug-fix
   ```

4. **进行更改**
   - 编写代码
   - 添加测试（如果适用）
   - 更新文档

5. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加新功能"
   ```

6. **推送到您的 Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **创建 Pull Request**
   - 访问您的 Fork 页面
   - 点击 "Compare & pull request"
   - 填写 PR 描述

---

## 📝 代码规范

### Python 代码规范

1. **遵循 PEP 8**
   - 使用 4 个空格缩进
   - 每行不超过 79 个字符（建议）
   - 使用空行组织代码

2. **导入顺序**
   ```python
   # 标准库导入
   import os
   import sys
   from datetime import datetime
   
   # 第三方库导入
   import customtkinter as ctk
   import tkinter as tk
   
   # 本地模块导入
   # （如果有）
   ```

3. **文档字符串**
   - 所有模块、类、公共方法都应该有文档字符串
   - 使用中文或英文，但要保持一致
   - 包含作者、版本、项目地址信息

   ```python
   """
   模块/类/函数描述
   
   作者：SutChan
   版本：v1.12.0
   项目地址：https://github.com/sutchan/Windows-User-Files-Mover
   """
   ```

4. **编码声明**
   - 所有 Python 文件都应该以 UTF-8 编码声明开头
   ```python
   #!/usr/bin/env python3
   # -*- coding: utf-8 -*-
   ```

5. **版本号**
   - 所有文件中的版本号应该保持一致
   - 当前版本：v1.12.0

### 批处理文件规范

1. **使用 UTF-8 编码**
2. **添加注释说明**
3. **版本号信息**
   ```batch
   rem 版本: v1.12.0
   rem 作者: SutChan
   ```

### PowerShell 规范

1. **使用 UTF-8 编码**
2. **添加帮助注释**
   ```powershell
   <#
   .SYNOPSIS
       ...
   .VERSION
       v1.12.0
   .AUTHOR
       SutChan
   #>
   ```

---

## � commit 规范

请使用清晰的 commit 消息，建议遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

### Commit 类型

- **feat**: 新功能
- **fix**: Bug 修复
- **docs**: 文档更改
- **style**: 代码格式更改（不影响功能）
- **refactor**: 代码重构
- **test**: 添加或修改测试
- **chore**: 构建过程或辅助工具的更改

### 示例

```bash
feat: 添加 Windows 11 风格界面
fix: 修复版本号不一致问题
docs: 更新 README.md 安装说明
refactor: 重构文件迁移逻辑
```

---

## ✅ Pull Request 规范

### PR 标题

使用清晰的标题，建议遵循 Conventional Commits 规范：

```
feat: 添加 Windows 桌面应用版
fix: 修复 EXE 打包后字体解析错误
docs: 添加 CONTRIBUTING.md 贡献指南
```

### PR 描述

请包含以下内容：

1. **描述** - PR 解决了什么问题
2. **更改类型** - feat / fix / docs / refactor 等
3. **测试** - 如何测试这些更改
4. **截图** - 如果适用，添加截图
5. **相关问题** - 关联的 Issue（如果有）

### PR 模板

```markdown
## 描述
简明扼要地描述此 PR 的更改。

## 更改类型
- [ ] feat (新功能)
- [ ] fix (Bug 修复)
- [ ] docs (文档更改)
- [ ] style (代码格式)
- [ ] refactor (代码重构)
- [ ] test (测试)
- [ ] chore (构建/工具)

## 测试
描述如何测试这些更改。

## 截图
如果适用，添加截图。

## 相关问题
关闭 #[issue-number]
```

---

## 🔍 代码审查

所有 Pull Request 都需要经过代码审查：

1. **检查清单**
   - [ ] 代码遵循项目规范
   - [ ] 所有测试通过（如果有）
   - [ ] 文档已更新（如果需要）
   - [ ] 版本号已更新（如果需要）

2. **审查流程**
   - 维护者会在 7 天内审查 PR
   - 可能需要修改才能合并
   - 合并前需要至少 1 个批准

---

## 📞 联系我们

如果您有任何问题或需要帮助，请：

- **创建 Issue** - 提出问题或讨论
- **邮件联系** - [您的邮箱]（可选）

---

## 📄 许可证

通过提交代码，您同意您的贡献将在 MIT 许可证下授权。

---

**再次感谢您的贡献！🙏**
