<div id="page-community-detail" class="page-content d-none">
    <div class="detail-header">
        <button class="btn-back" onclick="showPage('communities')">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Communities</span>
        </button>
    </div>

    <div class="detail-content" id="communityDetailContent">
    </div>

    <div class="detail-grid">
        <div class="detail-card">
            <div class="card-header">
                <h3 class="card-title">Members</h3>
            </div>
            <div class="card-body" id="communityMembersPreview"></div>
        </div>
        <div class="detail-card">
            <div class="card-header">
                <h3 class="card-title">Events</h3>
            </div>
            <div class="card-body" id="communityEventsPreview"></div>
        </div>
    </div>
</div>

<style>
/* ============================================
   Community Detail 页面样式
   ============================================ */

/* 页面头部 */
#page-community-detail .detail-header {
    margin-bottom: 28px;
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

#page-community-detail .btn-back {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.06);
    color: rgba(255, 255, 255, 0.85);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

#page-community-detail .btn-back::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.5s ease;
}

#page-community-detail .btn-back:hover {
    background: rgba(255, 255, 255, 0.12);
    border-color: rgba(255, 255, 255, 0.25);
    color: rgba(255, 255, 255, 0.95);
    transform: translateX(-4px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

#page-community-detail .btn-back:hover::before {
    left: 100%;
}

/* 详情内容区域 */
#page-community-detail .detail-content {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    box-shadow:
        0 8px 32px rgba(0, 0, 0, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    overflow: hidden;
    margin-bottom: 28px;
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) 0.1s forwards;
    opacity: 0;
    position: relative;
    transition:all ease 0.4s;
}

#page-community-detail .detail-content::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.06) 0%, transparent 100%);
    pointer-events: none;
    transition: background 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .detail-content:hover {
    border-color: rgba(255, 255, 255, 0.18);
    box-shadow:
        0 12px 40px rgba(0, 0, 0, 0.18),
        inset 0 1px 0 rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-community-detail .detail-content:hover::before {
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
}

/* 统计行 */
#page-community-detail .stats-row {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    margin-bottom: 24px;
}

/* 统计项 */
#page-community-detail .stat-item {
    background: rgba(255, 255, 255, 0.06);
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
    border-radius: 12px;
    padding: 16px;
    text-align: center;
    border: 1px solid rgba(255, 255, 255, 0.08);
    transition: all ease 0.4s;
}

#page-community-detail .stat-item:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.15);
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-community-detail .stat-icon {
    font-size: 24px;
    color: rgba(107, 179, 217, 0.8);
    margin-bottom: 8px;
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .stat-item:hover .stat-icon {
    color: rgba(107, 179, 217, 1);
}

#page-community-detail .stat-value {
    font-size: 20px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.95);
    margin-bottom: 4px;
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .stat-item:hover .stat-value {
    color: rgba(255, 255, 255, 1);
}

#page-community-detail .stat-label {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.55);
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .stat-item:hover .stat-label {
    color: rgba(255, 255, 255, 0.7);
}

/* 操作按钮区域 */
#page-community-detail .action-buttons {
    display: flex;
    gap: 12px;
    justify-content: flex-end;
    margin-bottom: 0;
}

/* 详情网格 */
#page-community-detail .detail-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 20px;
}

/* 详情卡片 */
#page-community-detail .detail-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    box-shadow:
        0 8px 32px rgba(0, 0, 0, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    overflow: hidden;
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    opacity: 0;
    position: relative;
    transition: all ease 0.4s;
    will-change: transform, box-shadow;
    cursor: pointer;
}

#page-community-detail .detail-card:nth-child(1) { animation-delay: 0.15s; }
#page-community-detail .detail-card:nth-child(2) { animation-delay: 0.25s; }

#page-community-detail .detail-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.08) 0%, transparent 100%);
    pointer-events: none;
    border-radius: 20px 20px 0 0;
    transition: background 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .detail-card:hover {
    transform: translateY(-6px) scale(1.01);
    box-shadow:
        0 16px 48px rgba(0, 0, 0, 0.25),
        inset 0 0 0 1px rgba(255, 255, 255, 0.2);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.06));
    border-color: rgba(255, 255, 255, 0.18);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-community-detail .detail-card:hover::before {
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.12) 0%, transparent 100%);
}

#page-community-detail .detail-card:active {
    transform: translateY(-2px) scale(0.995);
    box-shadow:
        0 8px 24px rgba(0, 0, 0, 0.18),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.02));
    border-color: rgba(255, 255, 255, 0.1);
}

#page-community-detail .detail-card.selected {
    box-shadow:
        0 12px 40px rgba(107, 179, 217, 0.2),
        inset 0 0 0 2px rgba(107, 179, 217, 0.4);
    background: linear-gradient(135deg, rgba(107, 179, 217, 0.15), rgba(255, 255, 255, 0.05));
    border-color: rgba(107, 179, 217, 0.35);
}

/* 卡片头部 */
#page-community-detail .card-header {
    padding: 20px 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    position: relative;
    z-index: 1;
}

#page-community-detail .card-title {
    font-size: 16px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.9);
    margin: 0;
}

/* 卡片内容 */
#page-community-detail .card-body {
    padding: 20px 24px;
    position: relative;
    z-index: 1;
}

/* 社区横幅样式 */
#page-community-detail .community-banner {
    padding: 32px;
    position: relative;
    overflow: hidden;
}

#page-community-detail .community-banner::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(180deg, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0.3) 100%);
    pointer-events: none;
}

#page-community-detail .community-banner h1 {
    font-size: 32px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.98);
    margin: 0 0 8px 0;
    text-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
    position: relative;
    z-index: 1;
}

#page-community-detail .community-banner p {
    font-size: 15px;
    color: rgba(255, 255, 255, 0.8);
    margin: 0;
    position: relative;
    z-index: 1;
}

/* 统计卡片 */
#page-community-detail .stat-card {
    background: rgba(255, 255, 255, 0.06);
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    border: 1px solid rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    will-change: transform, box-shadow;
}

#page-community-detail .stat-card:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.15);
    transform: translateY(-4px) scale(1.02);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
}

#page-community-detail .stat-card:active {
    transform: translateY(-2px) scale(0.99);
    background: rgba(255, 255, 255, 0.04);
}

#page-community-detail .stat-card i {
    font-size: 24px;
    color: rgba(255, 255, 255, 0.6);
    margin-bottom: 8px;
    display: block;
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .stat-card:hover i {
    color: rgba(255, 255, 255, 0.8);
}

#page-community-detail .stat-card .font-medium {
    font-size: 18px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.95);
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .stat-card:hover .font-medium {
    color: rgba(255, 255, 255, 1);
}

/* 操作按钮 */
#page-community-detail .btn-primary {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 20px;
    border: 1px solid rgba(107, 179, 217, 0.4);
    border-radius: 10px;
    background: rgba(107, 179, 217, 0.15);
    color: rgba(107, 179, 217, 0.95);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
    will-change: transform, box-shadow;
}

#page-community-detail .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
    transition: left 0.5s ease;
    pointer-events: none;
}

#page-community-detail .btn-primary:hover {
    background: rgba(107, 179, 217, 0.25);
    border-color: rgba(107, 179, 217, 0.6);
    transform: translateY(-3px) scale(1.02);
    box-shadow: 0 6px 20px rgba(107, 179, 217, 0.25);
}

#page-community-detail .btn-primary:hover::before {
    left: 100%;
}

#page-community-detail .btn-primary:active {
    transform: translateY(-1px) scale(0.995);
    box-shadow: 0 3px 10px rgba(107, 179, 217, 0.15);
    background: rgba(107, 179, 217, 0.1);
    border-color: rgba(107, 179, 217, 0.3);
}

#page-community-detail .btn-community {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 20px;
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.06);
    color: rgba(255, 255, 255, 0.85);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
    will-change: transform, box-shadow;
}

#page-community-detail .btn-community::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.5s ease;
    pointer-events: none;
}

#page-community-detail .btn-community:hover {
    background: rgba(255, 255, 255, 0.12);
    border-color: rgba(255, 255, 255, 0.25);
    color: rgba(255, 255, 255, 0.95);
    transform: translateY(-3px) scale(1.02);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

#page-community-detail .btn-community:hover::before {
    left: 100%;
}

#page-community-detail .btn-community:active {
    transform: translateY(-1px) scale(0.995);
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    background: rgba(255, 255, 255, 0.04);
    border-color: rgba(255, 255, 255, 0.1);
}

/* 成员预览项 */
#page-community-detail .member-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    margin: 0 -16px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.04);
    border-radius: 10px;
    transition: background 0.25s cubic-bezier(0.4, 0, 0.2, 1),
                transform 0.25s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
}

#page-community-detail .member-item:last-child {
    border-bottom: none;
}

#page-community-detail .member-item:hover {
    background: rgba(255, 255, 255, 0.06);
    transform: translateX(4px);
    box-shadow: -2px 0 0 rgba(107, 179, 217, 0.4);
}

#page-community-detail .member-item:active {
    transform: translateX(2px);
    background: rgba(255, 255, 255, 0.08);
}

#page-community-detail .member-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    flex-shrink: 0;
}

#page-community-detail .member-item:hover .member-avatar {
    transform: scale(1.1);
    background: rgba(255, 255, 255, 0.15);
}

#page-community-detail .member-info {
    flex: 1;
    min-width: 0;
}

#page-community-detail .member-name {
    font-size: 14px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    margin: 0 0 2px 0;
    transition: color 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .member-item:hover .member-name {
    color: rgba(255, 255, 255, 0.98);
}

#page-community-detail .member-role {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.5);
    margin: 0;
    transition: color 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .member-item:hover .member-role {
    color: rgba(255, 255, 255, 0.65);
}

/* 活动预览项 */
#page-community-detail .event-preview-item {
    padding: 16px;
    background: rgba(255, 255, 255, 0.04);
    border-radius: 12px;
    margin-bottom: 12px;
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    border: 1px solid rgba(255, 255, 255, 0.06);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                background 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    position: relative;
    overflow: hidden;
}

#page-community-detail .event-preview-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.08), transparent);
    transition: left 0.5s ease;
    pointer-events: none;
}

#page-community-detail .event-preview-item:last-child {
    margin-bottom: 0;
}

#page-community-detail .event-preview-item:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.12);
    transform: translateX(6px) scale(1.01);
    box-shadow: -4px 0 0 rgba(107, 179, 217, 0.4),
                0 4px 16px rgba(0, 0, 0, 0.15);
}

#page-community-detail .event-preview-item:hover::before {
    left: 100%;
}

#page-community-detail .event-preview-item:active {
    transform: translateX(3px) scale(0.998);
    background: rgba(255, 255, 255, 0.06);
}

#page-community-detail .event-preview-title {
    font-size: 15px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.95);
    margin: 0 0 8px 0;
    position: relative;
    z-index: 1;
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .event-preview-item:hover .event-preview-title {
    color: rgba(255, 255, 255, 1);
}

#page-community-detail .event-preview-meta {
    display: flex;
    align-items: center;
    gap: 16px;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.55);
    position: relative;
    z-index: 1;
    transition: color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-detail .event-preview-item:hover .event-preview-meta {
    color: rgba(255, 255, 255, 0.7);
}

#page-community-detail .event-preview-meta i {
    margin-right: 4px;
}

/* 空状态 */
#page-community-detail .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    color: rgba(255, 255, 255, 0.4);
}

#page-community-detail .empty-state i {
    font-size: 48px;
    margin-bottom: 16px;
}

#page-community-detail .empty-state p {
    margin: 0;
    font-size: 14px;
}

/* 入场动画 */
@keyframes fadeInUp {
    0% {
        opacity: 0;
        transform: translateY(20px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 性能优化：针对移动设备的优化 */
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
    
    #page-community-detail .detail-card,
    #page-community-detail .stat-card,
    #page-community-detail .btn-primary,
    #page-community-detail .btn-community {
        will-change: auto;
    }
}

/* 响应式设计 - 平板设备 */
@media (max-width: 768px) {
    #page-community-detail {
        padding: 20px 16px;
    }
    
    #page-community-detail .community-banner {
        padding: 24px;
    }
    
    #page-community-detail .community-banner h1 {
        font-size: 26px;
    }
    
    #page-community-detail .btn-back span {
        display: none;
    }
    
    #page-community-detail .btn-back {
        padding: 10px;
    }
    
    #page-community-detail .stats-row {
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
    }
    
    #page-community-detail .detail-grid {
        grid-template-columns: 1fr;
        gap: 16px;
    }
    
    #page-community-detail .card-header,
    #page-community-detail .card-body {
        padding: 16px;
    }
    
    /* 平板设备上减少模糊效果以提升性能 */
    #page-community-detail .detail-card,
    #page-community-detail .detail-content {
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
    }
    
    #page-community-detail .stat-card {
        backdrop-filter: blur(6px);
        -webkit-backdrop-filter: blur(6px);
    }
    
    #page-community-detail .stat-item {
        backdrop-filter: blur(6px);
        -webkit-backdrop-filter: blur(6px);
    }
}

/* 响应式设计 - 手机设备 */
@media (max-width: 480px) {
    #page-community-detail .community-banner h1 {
        font-size: 22px;
    }
    
    #page-community-detail .stats-row {
        grid-template-columns: repeat(2, 1fr);
        gap: 10px;
    }
    
    #page-community-detail .stat-item {
        padding: 12px;
    }
    
    #page-community-detail .stat-icon {
        font-size: 20px;
    }
    
    #page-community-detail .stat-value {
        font-size: 16px;
    }
    
    #page-community-detail .btn-primary span,
    #page-community-detail .btn-community span {
        display: none;
    }
    
    #page-community-detail .btn-primary,
    #page-community-detail .btn-community {
        padding: 12px;
    }
    
    /* 手机设备上进一步优化性能 */
    #page-community-detail .detail-card,
    #page-community-detail .detail-content {
        backdrop-filter: blur(6px);
        -webkit-backdrop-filter: blur(6px);
    }
    
    #page-community-detail .stat-card {
        backdrop-filter: blur(4px);
        -webkit-backdrop-filter: blur(4px);
    }
    
    #page-community-detail .stat-item {
        backdrop-filter: blur(4px);
        -webkit-backdrop-filter: blur(4px);
    }
    
    /* 手机设备上减少动画效果 */
    #page-community-detail .detail-card:hover {
        transform: translateY(-3px) scale(1.005);
    }
    
    #page-community-detail .stat-card:hover {
        transform: translateY(-2px) scale(1.01);
    }
    
    #page-community-detail .event-preview-item:hover {
        transform: translateX(4px) scale(1.005);
    }
}
</style>