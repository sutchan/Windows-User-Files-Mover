// Windows 文件迁移工具 - 交互逻辑

// ===== 页面导航 =====
function navigateToPage(pageName) {
    // 隐藏所有页面
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });
    
    // 移除所有导航项的活动状态
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // 显示目标页面
    const targetPage = document.getElementById('page-' + pageName);
    if (targetPage) {
        targetPage.classList.add('active');
    }
    
    // 设置活动导航项
    const targetNav = document.querySelector(`.nav-item[data-page="${pageName}"]`);
    if (targetNav) {
        targetNav.classList.add('active');
    }
    
    // 更新页面标题
    const pageTitles = {
        'dashboard': '仪表盘',
        'migrate': '开始迁移',
        'profiles': '迁移配置',
        'history': '迁移历史',
        'symlinks': '符号链接管理',
        'settings': '设置',
        'styleguide': '设计系统'
    };
    
    const pageTitle = document.getElementById('pageTitle');
    if (pageTitle && pageTitles[pageName]) {
        pageTitle.textContent = pageTitles[pageName];
    }
    
    // 关闭移动端侧边栏
    if (window.innerWidth <= 768) {
        document.getElementById('sidebar').classList.remove('open');
    }
    
    // 显示通知（演示）
    if (pageName !== 'dashboard') {
        showNotification('info', '页面切换', `已切换到${pageTitles[pageName]}页面`);
    }
}

// ===== 通知系统 =====
function showNotification(type, title, message, duration = 3000) {
    const container = document.getElementById('notificationContainer');
    
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    const icons = {
        'success': 'fas fa-check-circle',
        'warning': 'fas fa-exclamation-triangle',
        'error': 'fas fa-times-circle',
        'info': 'fas fa-info-circle'
    };
    
    notification.innerHTML = `
        <div class="notification-icon">
            <i class="${icons[type] || icons['info']}"></i>
        </div>
        <div class="notification-content">
            <div class="notification-title">${title}</div>
            <div class="notification-message">${message}</div>
        </div>
        <button class="notification-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    container.appendChild(notification);
    
    // 自动消失
    if (duration > 0) {
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => notification.remove(), 300);
        }, duration);
    }
    
    return notification;
}

// ===== 刷新仪表盘 =====
function refreshDashboard() {
    const btn = event.target.closest('button');
    const icon = btn.querySelector('i');
    
    // 添加旋转动画
    icon.style.animation = 'spin 1s linear infinite';
    btn.disabled = true;
    
    // 模拟刷新
    setTimeout(() => {
        icon.style.animation = '';
        btn.disabled = false;
        
        // 更新统计数字（模拟动态效果）
        animateValue('statFiles', 1247, 1247, 1000);
        
        showNotification('success', '刷新成功', '仪表盘数据已更新');
    }, 1000);
}

// ===== 数字动画 =====
function animateValue(elementId, start, end, duration) {
    const element = document.getElementById(elementId);
    if (!element) return;
    
    const range = end - start;
    const increment = end > start ? 1 : -1;
    const stepTime = Math.abs(Math.floor(duration / range));
    let current = start;
    
    const timer = setInterval(() => {
        current += increment;
        element.textContent = current.toLocaleString();
        
        if (current === end) {
            clearInterval(timer);
        }
    }, stepTime);
}

// ===== 开始迁移向导 =====
function startMigrationWizard() {
    showNotification('info', '迁移向导', '正在启动迁移向导...');
    
    // 模拟打开向导对话框
    setTimeout(() => {
        showNotification('success', '向导已启动', '请按照以下步骤完成迁移配置');
    }, 500);
}

// ===== 刷新系统状态 =====
function refreshSystemStatus() {
    const btn = event.target.closest('button');
    const icon = btn.querySelector('i');
    
    icon.style.animation = 'spin 1s linear infinite';
    btn.disabled = true;
    
    setTimeout(() => {
        icon.style.animation = '';
        btn.disabled = false;
        
        // 更新时间
        const now = new Date();
        const timeStr = now.toLocaleString('zh-CN');
        document.querySelector('.status-item:last-child .status-value').textContent = timeStr;
        
        showNotification('success', '状态已刷新', '系统状态已更新');
    }, 800);
}

// ===== 显示键盘快捷键 =====
function showKeyboardShortcuts() {
    showNotification('info', '键盘快捷键', 'Ctrl+N: 新建迁移 | Ctrl+R: 刷新 | Ctrl+,: 设置');
}

// ===== 移动端菜单切换 =====
document.getElementById('menuToggle')?.addEventListener('click', function() {
    document.getElementById('sidebar').classList.toggle('open');
});

// ===== 初始化 =====
document.addEventListener('DOMContentLoaded', function() {
    console.log('Windows 文件迁移工具原型已加载');
    
    // 为所有导航项添加点击事件
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const page = this.getAttribute('data-page');
            if (page) {
                navigateToPage(page);
            }
        });
    });
    
    // 默认显示仪表盘
    navigateToPage('dashboard');
    
    // 添加 CSS 动画
    const style = document.createElement('style');
    style.textContent = `
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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
        
        button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
    `;
    document.head.appendChild(style);
    
    // 显示欢迎通知
    setTimeout(() => {
        showNotification('success', '欢迎回来', '文件迁移工具已就绪');
    }, 500);
});

// ===== 响应式处理 =====
window.addEventListener('resize', function() {
    if (window.innerWidth > 768) {
        document.getElementById('sidebar').classList.remove('open');
    }
});

// ===== 键盘快捷键 =====
document.addEventListener('keydown', function(e) {
    // Ctrl+N: 新建迁移
    if (e.ctrlKey && e.key === 'n') {
        e.preventDefault();
        navigateToPage('migrate');
    }
    
    // Ctrl+R: 刷新
    if (e.ctrlKey && e.key === 'r') {
        e.preventDefault();
        if (document.getElementById('page-dashboard').classList.contains('active')) {
            refreshDashboard();
        }
    }
    
    // Ctrl+,: 设置
    if (e.ctrlKey && e.key === ',') {
        e.preventDefault();
        navigateToPage('settings');
    }
    
    // ESC: 关闭侧边栏（移动端）
    if (e.key === 'Escape' && window.innerWidth <= 768) {
        document.getElementById('sidebar').classList.remove('open');
    }
});

// ===== 导出函数供 HTML 使用 =====
window.navigateToPage = navigateToPage;
window.refreshDashboard = refreshDashboard;
window.startMigrationWizard = startMigrationWizard;
window.refreshSystemStatus = refreshSystemStatus;
window.showKeyboardShortcuts = showKeyboardShortcuts;
window.showNotification = showNotification;
