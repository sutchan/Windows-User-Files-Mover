// Windows 11 应用原型 - 交互逻辑

// 页面配置
const pageConfig = {
    'dashboard': {
        title: '仪表盘',
        icon: 'fas fa-home'
    },
    'migrate': {
        title: '开始迁移',
        icon: 'fas fa-play'
    },
    'profiles': {
        title: '迁移配置',
        icon: 'fas fa-save'
    },
    'history': {
        title: '迁移历史',
        icon: 'fas fa-history'
    },
    'symlinks': {
        title: '符号链接管理',
        icon: 'fas fa-link'
    },
    'settings': {
        title: '设置',
        icon: 'fas fa-cog'
    }
};

// 当前页面
let currentPage = 'dashboard';

// 初始化
document.addEventListener('DOMContentLoaded', function() {
    initializeNavigation();
    initializeTitleBar();
    initializeButtons();
    
    // 显示仪表盘
    showPage('dashboard');
});

// 初始化导航
function initializeNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    
    navItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            
            const page = this.getAttribute('data-page');
            if (page) {
                navigateTo(page);
            }
        });
    });
}

// 初始化标题栏按钮
function initializeTitleBar() {
    const minimizeBtn = document.querySelector('.title-bar-button.minimize');
    const maximizeBtn = document.querySelector('.title-bar-button.maximize');
    const closeBtn = document.querySelector('.title-bar-button.close');
    
    if (minimizeBtn) {
        minimizeBtn.addEventListener('click', function() {
            showNotification('最小化', 'info');
        });
    }
    
    if (maximizeBtn) {
        maximizeBtn.addEventListener('click', function() {
            const window = document.querySelector('.win11-window');
            window.classList.toggle('maximized');
            showNotification('切换最大化', 'info');
        });
    }
    
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            showDialog('确认退出', '您确定要退出 Windows 用户文件迁移工具吗？', function() {
                showNotification('应用已关闭', 'info');
            });
        });
    }
}

// 初始化按钮
function initializeButtons() {
    // 为所有 win11-button 添加涟漪效果
    const buttons = document.querySelectorAll('.win11-button');
    
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            // 创建涟漪效果
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                border-radius: 50%;
                background: rgba(0, 0, 0, 0.1);
                left: ${x}px;
                top: ${y}px;
                transform: scale(0);
                animation: ripple 0.6s ease-out;
                pointer-events: none;
            `;
            
            this.style.position = 'relative';
            this.style.overflow = 'hidden';
            this.appendChild(ripple);
            
            setTimeout(() => ripple.remove(), 600);
        });
    });
}

// 导航到指定页面
function navigateTo(page) {
    // 更新导航项状态
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('data-page') === page) {
            item.classList.add('active');
        }
    });
    
    // 显示页面
    showPage(page);
}

// 显示页面
function showPage(page) {
    // 隐藏所有页面
    const pages = document.querySelectorAll('.page-content');
    pages.forEach(p => p.classList.add('hidden'));
    
    // 显示目标页面
    const targetPage = document.getElementById(page + '-page');
    if (targetPage) {
        targetPage.classList.remove('hidden');
        currentPage = page;
        
        // 更新面包屑
        updateBreadcrumb(page);
        
        // 如果页面内容为空，加载内容
        if (targetPage.children.length === 0) {
            loadPageContent(page, targetPage);
        }
    }
}

// 更新面包屑
function updateBreadcrumb(page) {
    const breadcrumb = document.querySelector('.breadcrumb');
    const config = pageConfig[page];
    
    if (breadcrumb && config) {
        breadcrumb.innerHTML = `
            <span class="breadcrumb-item" onclick="navigateTo('dashboard')">首页</span>
            <span class="breadcrumb-separator">></span>
            <span class="breadcrumb-item active">${config.title}</span>
        `;
    }
}

// 加载页面内容
function loadPageContent(page, container) {
    switch(page) {
        case 'migrate':
            loadMigratePage(container);
            break;
        case 'profiles':
            loadProfilesPage(container);
            break;
        case 'history':
            loadHistoryPage(container);
            break;
        case 'symlinks':
            loadSymlinksPage(container);
            break;
        case 'settings':
            loadSettingsPage(container);
            break;
    }
}

// 加载迁移页面
function loadMigratePage(container) {
    container.innerHTML = `
        <div class="migrate-wizard">
            <h2 class="page-title">开始迁移</h2>
            <p class="page-description">选择要迁移的文件夹和目标位置</p>
            
            <div class="wizard-steps">
                <div class="wizard-step active">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <div class="step-title">选择源目录</div>
                        <div class="step-description">选择要迁移的用户文件夹</div>
                    </div>
                </div>
                
                <div class="wizard-step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <div class="step-title">选择目标目录</div>
                        <div class="step-description">选择迁移目标位置</div>
                    </div>
                </div>
                
                <div class="wizard-step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <div class="step-title">配置选项</div>
                        <div class="step-description">设置迁移选项</div>
                    </div>
                </div>
                
                <div class="wizard-step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <div class="step-title">确认并执行</div>
                        <div class="step-description">确认设置并开始迁移</div>
                    </div>
                </div>
            </div>
            
            <div class="wizard-actions">
                <button class="win11-button" disabled>上一步</button>
                <button class="win11-button primary" onclick="showNotification('开始迁移', 'success')">
                    下一步
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        </div>
    `;
}

// 加载配置页面
function loadProfilesPage(container) {
    container.innerHTML = `
        <div class="profiles-page">
            <h2 class="page-title">迁移配置</h2>
            <p class="page-description">管理已保存的迁移配置</p>
            
            <div class="profiles-list">
                <div class="profile-card">
                    <div class="profile-icon">
                        <i class="fas fa-save"></i>
                    </div>
                    <div class="profile-content">
                        <div class="profile-name">默认配置</div>
                        <div class="profile-description">标准迁移设置</div>
                        <div class="profile-meta">
                            <span>创建时间: 2026-06-20</span>
                            <span>使用次数: 5</span>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <button class="win11-button small">编辑</button>
                        <button class="win11-button small primary">使用</button>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// 加载历史记录页面
function loadHistoryPage(container) {
    container.innerHTML = `
        <div class="history-page">
            <h2 class="page-title">迁移历史</h2>
            <p class="page-description">查看过去的迁移记录</p>
            
            <div class="history-filters">
                <button class="win11-button small active">全部</button>
                <button class="win11-button small">成功</button>
                <button class="win11-button small">失败</button>
            </div>
            
            <div class="history-table">
                <div class="history-table-header">
                    <div class="history-col">时间</div>
                    <div class="history-col">文件夹</div>
                    <div class="history-col">大小</div>
                    <div class="history-col">状态</div>
                    <div class="history-col">操作</div>
                </div>
                <div class="history-table-body">
                    <div class="history-row">
                        <div class="history-col">2026-06-20 14:30</div>
                        <div class="history-col">文档</div>
                        <div class="history-col">2.5 GB</div>
                        <div class="history-col"><span class="status-badge success">成功</span></div>
                        <div class="history-col"><button class="win11-button small">详情</button></div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// 加载符号链接页面
function loadSymlinksPage(container) {
    container.innerHTML = `
        <div class="symlinks-page">
            <h2 class="page-title">符号链接管理</h2>
            <p class="page-description">查看和管理符号链接</p>
            
            <div class="symlinks-list">
                <div class="symlink-item">
                    <div class="symlink-icon">
                        <i class="fas fa-link"></i>
                    </div>
                    <div class="symlink-content">
                        <div class="symlink-name">文档</div>
                        <div class="symlink-path">C:\\Users\\Username\\Documents -> E:\\Users\\Username\\Documents</div>
                    </div>
                    <div class="symlink-status active">
                        <i class="fas fa-check-circle"></i>
                        正常
                    </div>
                </div>
            </div>
        </div>
    `;
}

// 加载设置页面
function loadSettingsPage(container) {
    container.innerHTML = `
        <div class="settings-page">
            <h2 class="page-title">设置</h2>
            <p class="page-description">自定义应用行为</p>
            
            <div class="settings-group">
                <h3 class="settings-group-title">常规设置</h3>
                
                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-label">启动时检查更新</div>
                        <div class="setting-description">自动检查并提示更新</div>
                    </div>
                    <div class="setting-control">
                        <label class="win11-toggle">
                            <input type="checkbox" checked>
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-label">迁移后验证文件</div>
                        <div class="setting-description">比较源文件和目标文件</div>
                    </div>
                    <div class="setting-control">
                        <label class="win11-toggle">
                            <input type="checkbox" checked>
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // 添加切换开关样式
    addToggleStyles();
}

// 添加切换开关样式
function addToggleStyles() {
    if (!document.getElementById('toggle-styles')) {
        const style = document.createElement('style');
        style.id = 'toggle-styles';
        style.textContent = `
            .win11-toggle {
                position: relative;
                display: inline-block;
                width: 40px;
                height: 20px;
            }
            
            .win11-toggle input {
                opacity: 0;
                width: 0;
                height: 0;
            }
            
            .toggle-slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: 0.3s;
                border-radius: 20px;
            }
            
            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 16px;
                width: 16px;
                left: 2px;
                bottom: 2px;
                background-color: white;
                transition: 0.3s;
                border-radius: 50%;
            }
            
            input:checked + .toggle-slider {
                background-color: var(--primary-color);
            }
            
            input:checked + .toggle-slider:before {
                transform: translateX(20px);
            }
        `;
        document.head.appendChild(style);
    }
}

// 显示对话框
function showDialog(title, message, onConfirm) {
    const overlay = document.getElementById('dialog-overlay');
    const dialogTitle = overlay.querySelector('.dialog-title span');
    const dialogMessage = overlay.querySelector('.dialog-message');
    
    dialogTitle.textContent = title;
    dialogMessage.textContent = message;
    
    overlay.classList.remove('hidden');
    
    // 保存确认回调
    window.dialogConfirmCallback = onConfirm;
}

// 关闭对话框
function closeDialog() {
    const overlay = document.getElementById('dialog-overlay');
    overlay.classList.add('hidden');
    window.dialogConfirmCallback = null;
}

// 确认操作
function confirmAction() {
    if (window.dialogConfirmCallback) {
        window.dialogConfirmCallback();
    }
    closeDialog();
}

// 显示通知
function showNotification(message, type = 'info') {
    // 创建通知元素
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
        <span>${message}</span>
    `;
    
    // 添加样式
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        display: flex;
        align-items: center;
        gap: 10px;
        z-index: 2000;
        animation: slideIn 0.3s ease-out;
        font-family: var(--font-family);
        font-size: 14px;
        border-left: 4px solid ${type === 'success' ? 'var(--success-color)' : type === 'error' ? 'var(--danger-color)' : 'var(--primary-color)'};
    `;
    
    document.body.appendChild(notification);
    
    // 3秒后自动移除
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// 显示设置页面
function showSettings() {
    navigateTo('settings');
}

// 添加动画样式
const animationStyles = document.createElement('style');
animationStyles.textContent = `
    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    @keyframes slideOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100px);
        }
    }
    
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    
    .page-title {
        font-size: 28px;
        font-weight: 600;
        color: var(--gray-100);
        margin-bottom: 8px;
    }
    
    .page-description {
        font-size: 14px;
        color: var(--gray-60);
        margin-bottom: 24px;
    }
    
    .wizard-steps {
        display: flex;
        flex-direction: column;
        gap: 16px;
        margin-bottom: 32px;
    }
    
    .wizard-step {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 16px;
        background: rgba(255, 255, 255, 0.8);
        border-radius: 8px;
        border: 1px solid rgba(0, 0, 0, 0.05);
    }
    
    .wizard-step.active {
        border-color: var(--primary-color);
        background: rgba(0, 102, 204, 0.05);
    }
    
    .step-number {
        width: 32px;
        height: 32px;
        background: var(--primary-color);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
    }
    
    .step-title {
        font-weight: 600;
        color: var(--gray-100);
        margin-bottom: 4px;
    }
    
    .step-description {
        font-size: 12px;
        color: var(--gray-60);
    }
    
    .wizard-actions {
        display: flex;
        justify-content: space-between;
    }
    
    .win11-button.small {
        padding: 6px 12px;
        font-size: 12px;
    }
    
    .status-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
    }
    
    .status-badge.success {
        background: rgba(13, 104, 50, 0.1);
        color: var(--success-color);
    }
`;
document.head.appendChild(animationStyles);
