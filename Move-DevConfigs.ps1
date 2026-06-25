#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

# ==================== 配置区 ====================
$SourceBase = "C:\Users\Admin"
$TargetBase = "E:\Users\Admin"

$Folders = @(
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
    ".workbuddy"
)
# ================================================

function Write-ColorLog {
    param([string]$Message, [string]$Color = "White")
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor $Color
}

# 预检查
if (-not (Test-Path $SourceBase)) {
    Write-ColorLog "源目录不存在: $SourceBase" "Red"
    exit 1
}

if (-not (Test-Path $TargetBase)) {
    New-Item -ItemType Directory -Path $TargetBase -Force | Out-Null
    Write-ColorLog "已创建目标根目录: $TargetBase" "Green"
}

$SuccessCount = 0
$SkipCount = 0
$FailCount = 0

foreach ($Folder in $Folders) {
    $SrcPath = Join-Path $SourceBase $Folder
    $DstPath = Join-Path $TargetBase $Folder

    Write-Host "`n--- 处理: $Folder ---" -ForegroundColor Cyan

    # 跳过不存在的文件夹
    if (-not (Test-Path $SrcPath)) {
        Write-ColorLog "  ⊘ 源文件夹不存在，跳过" "Yellow"
        $SkipCount++
        continue
    }

    # 如果已经是联接点，跳过
    $Item = Get-Item $SrcPath -Force
    if ($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-ColorLog "  ⊘ 已是联接点，跳过" "Yellow"
        $SkipCount++
        continue
    }

    try {
        # Step 1: 使用 robocopy 镜像复制（保留权限和时间戳）
        Write-ColorLog "  → 正在复制到 E 盘..." "Gray"
        $RoboArgs = @($SrcPath, $DstPath, "/E", "/COPYALL", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS")
        $RoboResult = & robocopy @RoboArgs
        # robocopy 退出码 0-7 均为成功，>=8 为错误
        if ($LASTEXITCODE -ge 8) {
            throw "robocopy 失败，退出码: $LASTEXITCODE"
        }

        # Step 2: 验证复制完整性（比较文件数量）
        $SrcCount = (Get-ChildItem $SrcPath -Recurse -File -Force | Measure-Object).Count
        $DstCount = (Get-ChildItem $DstPath -Recurse -File -Force | Measure-Object).Count
        if ($SrcCount -ne $DstCount) {
            throw "文件数量不一致 (源:$SrcCount / 目标:$DstCount)，中止操作"
        }
        Write-ColorLog "  ✓ 复制验证通过 ($DstCount 个文件)" "Green"

        # Step 3: 删除原文件夹
        Write-ColorLog "  → 删除原文件夹..." "Gray"
        Remove-Item $SrcPath -Recurse -Force

        # Step 4: 创建目录联接 (Junction)
        Write-ColorLog "  → 创建目录联接..." "Gray"
        cmd /c mklink /J "$SrcPath" "$DstPath" | Out-Null

        # Step 5: 验证联接
        $LinkCheck = Get-Item $SrcPath -Force
        if ($LinkCheck.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            Write-ColorLog "  ✅ 迁移成功" "Green"
            $SuccessCount++
        } else {
            throw "联接创建后验证失败"
        }

    } catch {
        Write-ColorLog "  ❌ 失败: $_" "Red"
        # 如果复制成功但后续步骤失败，保留E盘副本供手动恢复
        if (Test-Path $DstPath) {
            Write-ColorLog "  ⚠ E盘副本已保留: $DstPath" "Yellow"
        }
        $FailCount++
    }
}

# 汇总报告
Write-Host "`n========================================" -ForegroundColor White
Write-Host " 迁移完成汇总" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White
Write-ColorLog "  ✅ 成功: $SuccessCount" "Green"
Write-ColorLog "  ⊘ 跳过: $SkipCount" "Yellow"
Write-ColorLog "  ❌ 失败: $FailCount" $(if ($FailCount -gt 0) { "Red" } else { "Green" })
Write-Host "========================================`n" -ForegroundColor White

if ($FailCount -gt 0) {
    Write-ColorLog "存在失败项，请检查上方日志并手动处理。" "Red"
    exit 1
}