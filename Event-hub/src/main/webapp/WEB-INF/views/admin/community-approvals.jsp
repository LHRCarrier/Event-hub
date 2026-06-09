<div id="page-community-approvals" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <div class="title-icon">
                <i class="fas fa-users-cog"></i>
            </div>
            <div class="title-content">
                <h1 class="page-title">Community Creation Approvals</h1>
                <p class="page-subtitle">Review and manage community creation requests</p>
            </div>
        </div>
        <div class="page-stats">
            <div class="stat-item">
                <span class="stat-value" id="pendingCount">0</span>
                <span class="stat-label">Pending</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
                <span class="stat-value" id="approvedCount">0</span>
                <span class="stat-label">Approved</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
                <span class="stat-value" id="rejectedCount">0</span>
                <span class="stat-label">Rejected</span>
            </div>
        </div>
    </div>

    <div class="tabs-container" id="approvalTabs">
        <button class="tab-btn active" onclick="selectApprovalTab('PENDING')">
            <i class="fas fa-clock"></i>
            <span>Pending</span>
            <span class="tab-count" id="pendingTabCount">0</span>
        </button>
        <button class="tab-btn" onclick="selectApprovalTab('APPROVED')">
            <i class="fas fa-check-circle"></i>
            <span>Approved</span>
            <span class="tab-count" id="approvedTabCount">0</span>
        </button>
        <button class="tab-btn" onclick="selectApprovalTab('REJECTED')">
            <i class="fas fa-times-circle"></i>
            <span>Rejected</span>
            <span class="tab-count" id="rejectedTabCount">0</span>
        </button>
    </div>

    <div class="approvals-grid" id="communityCreationApplicationsList">
    </div>

    <nav aria-label="Page navigation" class="pagination-nav">
        <ul class="pagination justify-content-center" id="communityCreationApplicationsPagination">
        </ul>
    </nav>
</div>

<style>
/* ============================================
   页面切入动画 - 多层级渐进效果
   ============================================ */
#page-community-approvals {
    animation: pageFadeIn 0.7s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    padding: 28px 36px;
    min-height: 100vh;
    opacity: 0;
}

@keyframes pageFadeIn {
    0% {
        opacity: 0;
        transform: translateY(30px);
        filter: blur(10px);
    }
    50% {
        opacity: 0.6;
        filter: blur(5px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
        filter: blur(0);
    }
}

/* 页面头部入场动画 */
#page-community-approvals .page-header {
    animation: headerSlideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) 0.1s forwards;
    opacity: 0;
}

@keyframes headerSlideIn {
    0% {
        opacity: 0;
        transform: translateX(-30px);
    }
    100% {
        opacity: 1;
        transform: translateX(0);
    }
}

/* Tab容器入场动画 */
#page-community-approvals .tabs-container {
    animation: tabsSlideIn 0.5s cubic-bezier(0.4, 0, 0.2, 1) 0.2s forwards;
    opacity: 0;
}

@keyframes tabsSlideIn {
    0% {
        opacity: 0;
        transform: translateY(20px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 卡片网格入场动画 */
#page-community-approvals .approvals-grid {
    animation: gridFadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1) 0.3s forwards;
    opacity: 0;
}

@keyframes gridFadeIn {
    0% {
        opacity: 0;
        transform: scale(0.98);
    }
    100% {
        opacity: 1;
        transform: scale(1);
    }
}

/* ============================================
   页面头部样式
   ============================================ */
#page-community-approvals .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 28px;
    padding: 20px 24px;
    background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05));
    border: 1px solid rgba(255,255,255,0.12);
    border-radius: 14px;
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 0 4px 20px rgba(255,255,255,0.06);
    position: relative;
    overflow: hidden;
}

#page-community-approvals .page-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 50%;
    background: linear-gradient(180deg, rgba(255,255,255,0.06) 0%, transparent 100%);
    pointer-events: none;
}

/* 脉冲光晕效果 */
#page-community-approvals .page-header::after {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle at 30% 20%, rgba(255,255,255,0.08) 0%, transparent 50%);
    animation: pulseGlow 4s ease-in-out infinite;
    pointer-events: none;
}

@keyframes pulseGlow {
    0%, 100% {
        transform: scale(1);
        opacity: 0.5;
    }
    50% {
        transform: scale(1.1);
        opacity: 0.8;
    }
}

#page-community-approvals .page-title-section {
    display: flex;
    align-items: center;
    gap: 16px;
}

#page-community-approvals .title-icon {
    width: 48px;
    height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.18);
    border-radius: 12px;
    font-size: 20px;
    color: rgba(255,255,255,0.85);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .title-icon:hover {
    transform: scale(1.05) rotate(5deg);
    box-shadow: 0 8px 28px rgba(255,255,255,0.15);
}

#page-community-approvals .title-content {
    display: flex;
    flex-direction: column;
    gap: 3px;
}

#page-community-approvals .page-title {
    font-size: 22px;
    font-weight: 700;
    color: rgba(255,255,255,0.92);
    margin: 0;
    line-height: 1.2;
    letter-spacing: -0.3px;
}

#page-community-approvals .page-subtitle {
    font-size: 13px;
    color: rgba(255,255,255,0.6);
    margin: 0;
    font-weight: 400;
}

#page-community-approvals .page-stats {
    display: flex;
    align-items: center;
    gap: 18px;
    padding: 10px 18px;
    background: rgba(255,255,255,0.04);
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);
}

#page-community-approvals .stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 3px;
    transition: transform 0.25s ease;
}

#page-community-approvals .stat-item:hover {
    transform: translateY(-2px);
}

#page-community-approvals .stat-value {
    font-size: 20px;
    font-weight: 700;
    color: rgba(255,255,255,0.9);
    line-height: 1;
    transition: all 0.3s ease;
}

#page-community-approvals .stat-item:hover .stat-value {
    text-shadow: 0 0 20px rgba(255,255,255,0.3);
}

#page-community-approvals .stat-label {
    font-size: 11px;
    font-weight: 500;
    color: rgba(255,255,255,0.55);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

#page-community-approvals .stat-divider {
    width: 1px;
    height: 32px;
    background: rgba(255,255,255,0.15);
}

/* ============================================
   Tab容器样式
   ============================================ */
#page-community-approvals .tabs-container {
    display: flex;
    gap: 10px;
    margin-bottom: 24px;
    padding: 4px;
    background: rgba(255,255,255,0.04);
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);
}

/* ============================================
   Tab按钮样式
   ============================================ */
#page-community-approvals .tab-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 22px;
    border: 1px solid transparent;
    border-radius: 10px;
    background: transparent;
    color: rgba(255,255,255,0.7);
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

#page-community-approvals .tab-btn i {
    font-size: 15px;
    opacity: 0.75;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .tab-count {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    background: rgba(255,255,255,0.08);
    border-radius: 6px;
    font-size: 11px;
    font-weight: 600;
    color: rgba(255,255,255,0.75);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 波浪扫过效果 */
#page-community-approvals .tab-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, 
        transparent 0%, 
        rgba(255,255,255,0.1) 30%, 
        rgba(255,255,255,0.2) 50%, 
        rgba(255,255,255,0.1) 70%, 
        transparent 100%);
    transition: left 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .tab-btn:hover::before {
    left: 100%;
}

#page-community-approvals .tab-btn:hover {
    background: rgba(255,255,255,0.08);
    color: rgba(255,255,255,0.9);
    transform: translateY(-2px);
}

#page-community-approvals .tab-btn:hover i {
    opacity: 1;
    transform: scale(1.1);
}

#page-community-approvals .tab-btn.active {
    background: rgba(255,255,255,0.12);
    border-color: rgba(255,255,255,0.2);
    color: rgba(255,255,255,0.95);
    box-shadow: 0 4px 20px rgba(255,255,255,0.1);
    transform: translateY(-2px);
}

#page-community-approvals .tab-btn.active i {
    opacity: 1;
}

#page-community-approvals .tab-btn.active .tab-count {
    background: rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.9);
    animation: countPulse 2s ease-in-out infinite;
}

@keyframes countPulse {
    0%, 100% {
        transform: scale(1);
        box-shadow: 0 0 0 0 rgba(255,255,255,0.1);
    }
    50% {
        transform: scale(1.05);
        box-shadow: 0 0 0 4px rgba(255,255,255,0.05);
    }
}

/* ============================================
   卡片网格布局
   ============================================ */
#page-community-approvals .approvals-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 20px;
    margin-bottom: 28px;
}

/* ============================================
   卡片样式 - 增强动画效果
   ============================================ */
#page-community-approvals .approval-card {
    display: flex;
    flex-direction: column;
    border-radius: 16px;
    background: linear-gradient(135deg, rgba(255,255,255,0.07), rgba(255,255,255,0.03));
    border: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    box-shadow: 0 2px 14px rgba(255,255,255,0.04);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
    position: relative;
    animation: cardFadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    opacity: 0;
}

/* 卡片逐个入场动画 */
#page-community-approvals .approvals-grid .approval-card:nth-child(1) { animation-delay: 0.35s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(2) { animation-delay: 0.42s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(3) { animation-delay: 0.49s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(4) { animation-delay: 0.56s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(5) { animation-delay: 0.63s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(6) { animation-delay: 0.70s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(7) { animation-delay: 0.77s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(8) { animation-delay: 0.84s; }
#page-community-approvals .approvals-grid .approval-card:nth-child(n+9) { animation-delay: 0.9s; }

@keyframes cardFadeInUp {
    0% {
        opacity: 0;
        transform: translateY(30px) scale(0.95);
        filter: blur(8px);
    }
    50% {
        opacity: 0.7;
        filter: blur(4px);
    }
    100% {
        opacity: 1;
        transform: translateY(0) scale(1);
        filter: blur(0);
    }
}

/* 交错入场效果 - 偶数卡片从右侧入场 */
#page-community-approvals .approvals-grid .approval-card:nth-child(even) {
    animation-name: cardFadeInUpRight;
}

@keyframes cardFadeInUpRight {
    0% {
        opacity: 0;
        transform: translate(20px, 30px) scale(0.95) rotate(2deg);
        filter: blur(8px);
    }
    50% {
        opacity: 0.7;
        transform: translate(10px, 15px) scale(0.98) rotate(1deg);
        filter: blur(4px);
    }
    100% {
        opacity: 1;
        transform: translate(0, 0) scale(1) rotate(0);
        filter: blur(0);
    }
}

/* 顶部渐变光晕 */
#page-community-approvals .approval-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255,255,255,0.08) 0%, transparent 100%);
    pointer-events: none;
    z-index: 1;
}

/* 扫光动画效果 */
#page-community-approvals .approval-card::after {
    content: '';
    position: absolute;
    top: 0;
    left: -150%;
    width: 50%;
    height: 100%;
    background: linear-gradient(90deg, 
        transparent 0%, 
        rgba(255,255,255,0.08) 50%, 
        rgba(255,255,255,0.15) 70%, 
        transparent 100%);
    transform: skewX(-20deg);
    transition: left 0.8s cubic-bezier(0.4, 0, 0.2, 1);
    pointer-events: none;
    z-index: 2;
}

#page-community-approvals .approval-card:hover::after {
    left: 150%;
}

/* 悬停效果增强 */
#page-community-approvals .approval-card:hover {
    transform: translateY(-6px) scale(1.02);
    border-color: rgba(255,255,255,0.2);
    box-shadow: 
        0 12px 40px rgba(255,255,255,0.1),
        0 0 0 1px rgba(255,255,255,0.1) inset;
    background: linear-gradient(135deg, rgba(255,255,255,0.12), rgba(255,255,255,0.05));
}

/* ============================================
   卡片头部样式
   ============================================ */
#page-community-approvals .approval-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 18px;
    position: relative;
    z-index: 3;
}

#page-community-approvals .approval-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.12);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .approval-card:hover .approval-icon {
    transform: scale(1.1) rotate(10deg);
    box-shadow: 0 12px 32px rgba(255,255,255,0.2);
    background: rgba(255,255,255,0.15);
}

/* ============================================
   状态标签样式
   ============================================ */
#page-community-approvals .approval-status {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 5px;
    transition: all 0.3s ease;
}

#page-community-approvals .approval-status::before {
    content: '';
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: currentColor;
    animation: statusPulse 2s ease-in-out infinite;
}

@keyframes statusPulse {
    0%, 100% {
        opacity: 1;
        transform: scale(1);
    }
    50% {
        opacity: 0.5;
        transform: scale(0.8);
    }
}

#page-community-approvals .approval-card:hover .approval-status {
    transform: scale(1.05);
}

#page-community-approvals .approval-status.pending {
    background: rgba(251,191,36,0.15);
    border: 1px solid rgba(251,191,36,0.25);
    color: #fbbf24;
}

#page-community-approvals .approval-status.approved {
    background: rgba(74,222,128,0.15);
    border: 1px solid rgba(74,222,128,0.25);
    color: #4ade80;
}

#page-community-approvals .approval-status.rejected {
    background: rgba(248,113,113,0.15);
    border: 1px solid rgba(248,113,113,0.25);
    color: #f87171;
}

/* ============================================
   卡片内容样式
   ============================================ */
#page-community-approvals .approval-content {
    padding: 0 18px 14px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex: 1;
    position: relative;
    z-index: 3;
}

#page-community-approvals .approval-name {
    font-size: 16px;
    font-weight: 600;
    color: rgba(255,255,255,0.92);
    margin: 0;
    line-height: 1.3;
    transition: color 0.3s ease;
}

#page-community-approvals .approval-card:hover .approval-name {
    color: rgba(255,255,255,0.98);
}

#page-community-approvals .approval-desc {
    font-size: 13px;
    color: rgba(255,255,255,0.6);
    margin: 0;
    line-height: 1.5;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    transition: color 0.3s ease;
}

#page-community-approvals .approval-card:hover .approval-desc {
    color: rgba(255,255,255,0.7);
}

/* ============================================
   元信息样式
   ============================================ */
#page-community-approvals .approval-meta {
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 12px;
    color: rgba(255,255,255,0.55);
    margin-top: 10px;
    padding-top: 10px;
    border-top: 1px solid rgba(255,255,255,0.06);
}

#page-community-approvals .meta-item {
    display: flex;
    align-items: center;
    gap: 6px;
    transition: color 0.3s ease;
}

#page-community-approvals .approval-card:hover .meta-item {
    color: rgba(255,255,255,0.65);
}

#page-community-approvals .meta-item i {
    font-size: 13px;
    opacity: 0.6;
    width: 14px;
    text-align: center;
    transition: opacity 0.3s ease;
}

#page-community-approvals .approval-card:hover .meta-item i {
    opacity: 0.8;
}

/* ============================================
   操作按钮区域 - 增强动画效果
   ============================================ */
#page-community-approvals .approval-actions {
    display: flex;
    gap: 10px;
    padding: 0 18px 18px;
    position: relative;
    z-index: 3;
}

#page-community-approvals .action-btn {
    flex: 1;
    padding: 11px 16px;
    border: 1px solid rgba(255,255,255,0.12);
    border-radius: 10px;
    background: rgba(255,255,255,0.06);
    color: rgba(255,255,255,0.78);
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 12px;
    font-weight: 500;
    position: relative;
    overflow: hidden;
}

#page-community-approvals .action-btn i {
    font-size: 14px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 扫光效果 */
#page-community-approvals .action-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, 
        transparent 0%, 
        rgba(255,255,255,0.15) 50%, 
        transparent 100%);
    transition: left 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .action-btn:hover::before {
    left: 100%;
}

/* 悬停效果 */
#page-community-approvals .action-btn:hover {
    background: rgba(255,255,255,0.12);
    border-color: rgba(255,255,255,0.25);
    color: rgba(255,255,255,0.95);
    transform: translateY(-3px);
    box-shadow: 
        0 8px 24px rgba(255,255,255,0.12),
        inset 0 1px 0 rgba(255,255,255,0.15);
}

#page-community-approvals .action-btn:hover i {
    transform: scale(1.15);
}

/* 点击反馈 */
#page-community-approvals .action-btn:active {
    transform: translateY(-1px) scale(0.97);
    box-shadow: 
        0 4px 12px rgba(255,255,255,0.08),
        inset 0 2px 4px rgba(0,0,0,0.1);
}

/* 涟漪效果 */
#page-community-approvals .action-btn::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    background: rgba(255,255,255,0.2);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    transition: width 0.4s ease, height 0.4s ease, opacity 0.4s ease;
    opacity: 0;
}

#page-community-approvals .action-btn:active::after {
    width: 200%;
    height: 200%;
    opacity: 0;
}

/* Approve按钮样式 */
#page-community-approvals .action-btn.approve {
    background: rgba(34,197,94,0.12);
    border-color: rgba(34,197,94,0.25);
    color: rgba(34,197,94,0.85);
}

#page-community-approvals .action-btn.approve:hover {
    background: rgba(34,197,94,0.2);
    border-color: rgba(34,197,94,0.4);
    color: #22c55e;
    box-shadow: 
        0 8px 24px rgba(34,197,94,0.25),
        inset 0 1px 0 rgba(34,197,94,0.3);
}

/* Reject按钮样式 */
#page-community-approvals .action-btn.reject {
    background: rgba(248,113,113,0.12);
    border-color: rgba(248,113,113,0.25);
    color: rgba(248,113,113,0.85);
}

#page-community-approvals .action-btn.reject:hover {
    background: rgba(248,113,113,0.2);
    border-color: rgba(248,113,113,0.4);
    color: #ef4444;
    box-shadow: 
        0 8px 24px rgba(248,113,113,0.25),
        inset 0 1px 0 rgba(248,113,113,0.3);
}

/* ============================================
   分页导航样式 - 增强动画效果
   ============================================ */
#page-community-approvals .pagination-nav {
    margin-top: 24px;
    padding: 14px;
    background: rgba(255,255,255,0.04);
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);
    animation: paginationFadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1) 0.4s forwards;
    opacity: 0;
}

@keyframes paginationFadeIn {
    0% {
        opacity: 0;
        transform: translateY(10px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Pagination样式 */
#page-community-approvals .pagination {
    display: flex;
    gap: 10px;
    list-style: none;
    padding: 0;
    margin: 0;
    justify-content: center;
}

#page-community-approvals .pagination li {
    display: flex;
}

#page-community-approvals .pagination li a,
#page-community-approvals .pagination li span {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 40px;
    height: 40px;
    padding: 0 14px;
    border-radius: 10px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.75);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    position: relative;
    overflow: hidden;
}

/* 扫光效果 */
#page-community-approvals .pagination li a::before,
#page-community-approvals .pagination li span::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, 
        transparent 0%, 
        rgba(255,255,255,0.15) 50%, 
        transparent 100%);
    transition: left 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-approvals .pagination li a:hover::before {
    left: 100%;
}

#page-community-approvals .pagination li.active span::before {
    left: 100%;
}

/* 悬停和激活效果 */
#page-community-approvals .pagination li a:hover,
#page-community-approvals .pagination li.active span,
#page-community-approvals .pagination li.active a {
    background: rgba(255,255,255,0.12);
    border-color: rgba(255,255,255,0.25);
    color: rgba(255,255,255,0.95);
    transform: translateY(-3px) scale(1.05);
    box-shadow: 
        0 6px 20px rgba(255,255,255,0.12),
        inset 0 1px 0 rgba(255,255,255,0.15);
}

/* 禁用状态 */
#page-community-approvals .pagination li.disabled span,
#page-community-approvals .pagination li.disabled a {
    opacity: 0.4;
    cursor: not-allowed;
    transform: none;
}

#page-community-approvals .pagination li.disabled span:hover,
#page-community-approvals .pagination li.disabled a:hover {
    background: rgba(255,255,255,0.05);
    border-color: rgba(255,255,255,0.1);
    transform: none;
    box-shadow: none;
}

/* ============================================
   响应式设计
   ============================================ */
@media (max-width: 1024px) {
    #page-community-approvals {
        padding: 24px 28px;
    }
    
    #page-community-approvals .page-header {
        flex-direction: column;
        gap: 16px;
        align-items: flex-start;
    }
    
    #page-community-approvals .page-stats {
        width: 100%;
        justify-content: space-around;
    }
    
    #page-community-approvals .approvals-grid {
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 18px;
    }
}

@media (max-width: 768px) {
    #page-community-approvals {
        padding: 18px 20px;
    }
    
    #page-community-approvals .page-header {
        padding: 16px 18px;
        margin-bottom: 20px;
    }
    
    #page-community-approvals .title-icon {
        width: 42px;
        height: 42px;
        font-size: 18px;
    }
    
    #page-community-approvals .page-title {
        font-size: 19px;
    }
    
    #page-community-approvals .page-subtitle {
        font-size: 13px;
    }
    
    #page-community-approvals .stat-value {
        font-size: 18px;
    }
    
    #page-community-approvals .approvals-grid {
        grid-template-columns: 1fr;
        gap: 16px;
    }
    
    #page-community-approvals .tabs-container {
        flex-wrap: wrap;
        gap: 8px;
        padding: 8px;
    }
    
    #page-community-approvals .tab-btn {
        padding: 10px 16px;
        font-size: 12px;
        flex: 1;
        min-width: 0;
        justify-content: center;
    }
    
    #page-community-approvals .tab-btn span:not(.tab-count) {
        display: none;
    }
    
    #page-community-approvals .approval-header {
        padding: 16px;
    }
    
    #page-community-approvals .approval-icon {
        width: 48px;
        height: 48px;
        font-size: 20px;
    }
    
    #page-community-approvals .approval-content {
        padding: 0 16px 14px;
    }
    
    #page-community-approvals .approval-actions {
        flex-direction: column;
        gap: 10px;
        padding: 0 16px 16px;
    }
    
    #page-community-approvals .action-btn {
        width: 100%;
    }
    
    #page-community-approvals .pagination-nav {
        padding: 12px;
    }
    
    #page-community-approvals .pagination {
        gap: 8px;
    }
    
    #page-community-approvals .pagination li a,
    #page-community-approvals .pagination li span {
        min-width: 40px;
        height: 40px;
        padding: 0 10px;
        font-size: 12px;
        border-radius: 10px;
    }
}

@media (max-width: 480px) {
    #page-community-approvals .page-header {
        padding: 14px 16px;
    }
    
    #page-community-approvals .page-title-section {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
    }
    
    #page-community-approvals .stat-divider {
        display: none;
    }
    
    #page-community-approvals .page-stats {
        flex-direction: column;
        gap: 12px;
        padding: 12px 16px;
    }
    
    #page-community-approvals .tab-btn {
        padding: 10px 16px;
    }
    
    #page-community-approvals .tab-count {
        min-width: 20px;
        height: 20px;
        font-size: 11px;
    }
}
</style>