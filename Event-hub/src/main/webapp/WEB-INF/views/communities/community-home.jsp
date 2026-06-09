<div id="page-community-home" class="page-content d-none">
    <div class="page-header">
        <button class="btn-back" onclick="showPage('communities')">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Communities</span>
        </button>
        <div class="page-stats">
            <div class="stat-item">
                <span class="stat-value" id="statCommunityMembers">0</span>
                <span class="stat-label">Members</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
                <span class="stat-value" id="statCommunityEvents">0</span>
                <span class="stat-label">Events</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
                <span class="stat-value" id="statCommunityRegistrations">0</span>
                <span class="stat-label">Registrations</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
                <span class="stat-value" id="statCommunityUpcoming">0</span>
                <span class="stat-label">Upcoming</span>
            </div>
        </div>
    </div>

    <div class="community-banner">
        <div class="banner-content">
            <div class="banner-icon" id="communityLogo"><i class="fas fa-building"></i></div>
            <div class="banner-info">
                <h1 class="community-name" id="communityName">Community Name</h1>
                <p class="community-desc" id="communityDescription">Community description</p>
            </div>
        </div>
    </div>

    <div class="tabs-container" id="communityTabs">
        <button class="tab-btn active" onclick="switchCommunityTab('overview')" data-tab="overview">
            <i class="fas fa-home"></i>
            <span>Overview</span>
        </button>
        <button class="tab-btn" onclick="switchCommunityTab('events')" data-tab="events">
            <i class="fas fa-calendar"></i>
            <span>Events</span>
        </button>
        <button class="tab-btn" onclick="switchCommunityTab('members')" data-tab="members">
            <i class="fas fa-users"></i>
            <span>Members</span>
        </button>
        <button class="tab-btn" id="tabBtnApplications" style="display:none;" onclick="switchCommunityTab('applications')" data-tab="applications">
            <i class="fas fa-clipboard-check"></i>
            <span>Applications</span>
            <span class="tab-badge" id="pendingAppBadge" style="display:none;">0</span>
        </button>
    </div>

    <div id="tab-overview" class="tab-panel">
        <div class="overview-grid">
            <div class="panel-card">
                <div class="panel-header">
                    <h3 class="panel-title">Recent Events</h3>
                    <button class="panel-action" onclick="switchCommunityTab('events')">View All</button>
                </div>
                <div id="communityRecentEvents" class="panel-content">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-calendar"></i></div>
                        <p>No events yet</p>
                    </div>
                </div>
            </div>
            <div class="panel-card">
                <div class="panel-header">
                    <h3 class="panel-title">New Members</h3>
                    <button class="panel-action" onclick="switchCommunityTab('members')">View All</button>
                </div>
                <div id="communityNewMembers" class="panel-content">
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-users"></i></div>
                        <p>No members yet</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tab-events" class="tab-panel d-none">
        <div class="events-header">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" class="search-input" placeholder="Search events..." id="communityEventSearchInput">
            </div>
            <button class="btn-primary" id="btnCreateCommunityEvent" style="display:none;" onclick="createCommunityEvent()">
                <i class="fas fa-plus"></i>
                <span>Create Event</span>
            </button>
        </div>
        <div class="cards-grid" id="communityEventsList"></div>
        <nav aria-label="Page navigation" class="pagination-nav">
            <ul class="pagination justify-content-center" id="communityEventsPagination"></ul>
        </nav>
    </div>

    <div id="tab-members" class="tab-panel d-none">
        <div class="table-card">
            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Role</th>
                            <th>Joined</th>
                            <th id="thMemberActions" style="display:none;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="communityMembersTableBody">
                        <tr><td colspan="4" class="table-empty">Loading...</td></tr>
                    </tbody>
                </table>
            </div>
            <nav aria-label="Page navigation" class="pagination-nav">
                <ul class="pagination justify-content-center" id="communityMembersPagination"></ul>
            </nav>
        </div>
    </div>

    <div id="tab-applications" class="tab-panel d-none">
        <div class="table-card">
            <div class="table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Applicant</th>
                            <th>Message</th>
                            <th>Applied</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="communityApplicationsTableBody">
                        <tr><td colspan="4" class="table-empty">Loading...</td></tr>
                    </tbody>
                </table>
            </div>
            <nav aria-label="Page navigation" class="pagination-nav">
                <ul class="pagination justify-content-center" id="communityApplicationsPagination"></ul>
            </nav>
        </div>
    </div>
</div>

<style>
/* ============================================
   页面切入动画 - 多层级渐进效果
   ============================================ */
#page-community-home {
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
#page-community-home .page-header {
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
#page-community-home .tabs-container {
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

/* 社区横幅入场动画 */
#page-community-home .community-banner {
    animation: bannerFadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1) 0.15s forwards;
    opacity: 0;
}

@keyframes bannerFadeIn {
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
   图标基础样式
   ============================================ */
#page-community-home i.fas,
#page-community-home i.far {
    font-family: 'Font Awesome 6 Free';
    font-weight: 900;
    display: inline-block;
    font-style: normal;
    font-variant: normal;
    text-rendering: auto;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

#page-community-home .btn-back i,
#page-community-home .tab-btn i,
#page-community-home .panel-action i,
#page-community-home .btn-primary i,
#page-community-home .search-box i {
    font-size: 14px;
    color: inherit;
}

/* ============================================
   页面头部样式
   ============================================ */
#page-community-home .page-header {
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

#page-community-home .page-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 50%;
    background: linear-gradient(180deg, rgba(255,255,255,0.06) 0%, transparent 100%);
    pointer-events: none;
}

#page-community-home .page-header::after {
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

/* 返回按钮 */
#page-community-home .btn-back {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 10px;
    background: rgba(255,255,255,0.06);
    color: rgba(255,255,255,0.85);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

#page-community-home .btn-back:hover {
    background: rgba(255,255,255,0.12);
    border-color: rgba(255,255,255,0.25);
    color: rgba(255,255,255,0.95);
    transform: translateX(-4px);
}

#page-community-home .btn-back::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
    transition: left 0.5s ease;
}

#page-community-home .btn-back:hover::before {
    left: 100%;
}

/* 统计区域 */
#page-community-home .page-stats {
    display: flex;
    align-items: center;
    gap: 0;
    padding: 8px 16px;
    background: rgba(255,255,255,0.04);
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);
}

#page-community-home .stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 8px 16px;
}

#page-community-home .stat-value {
    font-size: 20px;
    font-weight: 700;
    color: rgba(255,255,255,0.9);
    line-height: 1.2;
}

#page-community-home .stat-label {
    font-size: 11px;
    color: rgba(255,255,255,0.55);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-top: 2px;
}

#page-community-home .stat-divider {
    width: 1px;
    height: 32px;
    background: rgba(255,255,255,0.1);
}

/* ============================================
   社区横幅
   ============================================ */
#page-community-home .community-banner {
    margin-bottom: 28px;
    padding: 24px;
    background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.04));
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 16px;
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    position: relative;
    overflow: hidden;
}

#page-community-home .community-banner::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle at 30% 30%, rgba(255,255,255,0.08) 0%, transparent 50%);
    animation: bannerGlow 4s ease-in-out infinite;
    pointer-events: none;
}

@keyframes bannerGlow {
    0%, 100% { transform: scale(1); opacity: 0.5; }
    50% { transform: scale(1.1); opacity: 0.8; }
}

#page-community-home .banner-content {
    display: flex;
    align-items: center;
    gap: 20px;
    position: relative;
    z-index: 1;
}

#page-community-home .banner-icon {
    font-size: 52px;
    filter: drop-shadow(0 4px 12px rgba(0,0,0,0.2));
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-home .community-banner:hover .banner-icon {
    transform: scale(1.1) rotate(5deg);
}

#page-community-home .banner-info {
    flex: 1;
}

#page-community-home .community-name {
    font-size: 26px;
    font-weight: 700;
    color: rgba(255,255,255,0.95);
    margin: 0 0 6px 0;
    letter-spacing: -0.3px;
}

#page-community-home .community-desc {
    font-size: 14px;
    color: rgba(255,255,255,0.7);
    margin: 0;
    line-height: 1.5;
}

/* ============================================
   Tab导航
   ============================================ */
#page-community-home .tabs-container {
    display: flex;
    gap: 6px;
    padding: 6px;
    background: rgba(255,255,255,0.04);
    border-radius: 14px;
    border: 1px solid rgba(255,255,255,0.08);
    margin-bottom: 28px;
    backdrop-filter: blur(16px);
}

#page-community-home .tab-btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 12px 16px;
    border: none;
    border-radius: 10px;
    background: transparent;
    color: rgba(255,255,255,0.65);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

#page-community-home .tab-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
    transition: left 0.5s ease;
}

#page-community-home .tab-btn:hover::before {
    left: 100%;
}

#page-community-home .tab-btn:hover {
    color: rgba(255,255,255,0.9);
    background: rgba(255,255,255,0.06);
}

#page-community-home .tab-btn.active {
    background: rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.95);
    box-shadow: 0 4px 20px rgba(255,255,255,0.1);
}

#page-community-home .tab-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    border-radius: 10px;
    background: rgba(232,116,116,0.9);
    color: white;
    font-size: 11px;
    font-weight: 600;
    animation: badgePulse 2s ease-in-out infinite;
}

@keyframes badgePulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

/* ============================================
   Tab面板
   ============================================ */
#page-community-home .tab-panel {
    animation: tabFadeIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes tabFadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

/* ============================================
   Overview网格
   ============================================ */
#page-community-home .overview-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 20px;
}

#page-community-home .panel-card {
    border-radius: 16px;
    background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.04));
    border: 1px solid rgba(255,255,255,0.1);
    overflow: hidden;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-home .panel-card:hover {
    border-color: rgba(255,255,255,0.15);
    box-shadow: 0 6px 20px rgba(0,0,0,0.12);
}

#page-community-home .panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

#page-community-home .panel-title {
    font-size: 15px;
    font-weight: 600;
    color: rgba(255,255,255,0.9);
    margin: 0;
}

#page-community-home .panel-action {
    padding: 6px 14px;
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 8px;
    background: rgba(255,255,255,0.06);
    color: rgba(255,255,255,0.75);
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-home .panel-action:hover {
    background: rgba(255,255,255,0.12);
    color: rgba(255,255,255,0.95);
}

#page-community-home .panel-content {
    padding: 20px;
    max-height: 300px;
    overflow-y: auto;
}

#page-community-home .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 32px;
    color: rgba(255,255,255,0.5);
}

#page-community-home .empty-icon {
    font-size: 40px;
    margin-bottom: 12px;
}

#page-community-home .empty-state p {
    margin: 0;
    font-size: 14px;
}

/* ============================================
   Events页面
   ============================================ */
#page-community-home .events-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 16px;
}

#page-community-home .search-box {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 16px;
    height: 44px;
    border-radius: 12px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.1);
    min-width: 280px;
    max-width: 360px;
    flex: 1;
}

#page-community-home .search-box i {
    color: rgba(255,255,255,0.5);
}

#page-community-home .search-input {
    flex: 1;
    height: 100%;
    background: transparent;
    border: none;
    outline: none;
    color: rgba(255,255,255,0.9);
    font-size: 14px;
}

#page-community-home .search-input::placeholder {
    color: rgba(255,255,255,0.45);
}

#page-community-home .btn-primary {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 20px;
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 10px;
    background: rgba(255,255,255,0.08);
    color: rgba(255,255,255,0.85);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

#page-community-home .btn-primary:hover {
    background: rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.95);
    transform: translateY(-2px);
    box-shadow: 0 6px 24px rgba(0,0,0,0.15);
}

/* ============================================
   Events网格
   ============================================ */
#page-community-home .cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 32px;
}

#page-community-home .cards-grid .event-card {
    display: flex;
    flex-direction: column;
    border-radius: 16px;
    overflow: hidden;
    background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.04));
    border: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-home .cards-grid .event-card:hover {
    transform: translateY(-6px);
    border-color: rgba(255,255,255,0.18);
    box-shadow: 0 12px 32px rgba(0,0,0,0.18);
    background: rgba(255,255,255,0.1);
}

#page-community-home .cards-grid .event-banner {
    height: 110px;
    position: relative;
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

#page-community-home .cards-grid .event-content {
    padding: 18px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

#page-community-home .cards-grid .event-title {
    font-size: 16px;
    font-weight: 600;
    color: rgba(255,255,255,0.95);
    margin: 0;
}

#page-community-home .cards-grid .event-desc {
    font-size: 13px;
    color: rgba(255,255,255,0.6);
    margin: 0;
    line-height: 1.5;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-community-home .cards-grid .event-meta {
    display: flex;
    flex-direction: column;
    gap: 6px;
    font-size: 12px;
    color: rgba(255,255,255,0.55);
}

#page-community-home .cards-grid .event-meta-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

#page-community-home .cards-grid .event-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    padding: 4px 10px;
    border-radius: 16px;
    font-size: 11px;
    font-weight: 600;
}

#page-community-home .cards-grid .event-badge.upcoming {
    background: rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.75);
}

#page-community-home .cards-grid .event-badge.ongoing {
    background: rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.9);
}

#page-community-home .cards-grid .event-badge.ended {
    background: rgba(255,255,255,0.05);
    color: rgba(255,255,255,0.5);
}

#page-community-home .cards-grid .event-actions {
    display: flex;
    gap: 8px;
    padding: 0 18px 18px;
    opacity: 0;
    transform: translateY(8px);
    transition: all 0.25s ease-out;
}

#page-community-home .cards-grid .event-card:hover .event-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-community-home .cards-grid .event-action-btn {
    flex: 1;
    padding: 10px;
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 8px;
    background: rgba(255,255,255,0.06);
    color: rgba(255,255,255,0.8);
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    font-size: 12px;
    position: relative;
    overflow: hidden;
}

#page-community-home .cards-grid .event-action-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
    transition: left 0.4s ease;
}

#page-community-home .cards-grid .event-action-btn:hover::before {
    left: 100%;
}

#page-community-home .cards-grid .event-action-btn:hover {
    background: rgba(255,255,255,0.12);
    border-color: rgba(255,255,255,0.25);
    color: rgba(255,255,255,0.95);
    transform: translateY(-2px);
}

#page-community-home .cards-grid .event-action-btn.danger:hover {
    background: rgba(232,116,116,0.2);
    border-color: rgba(232,116,116,0.4);
    color: rgba(232,116,116,0.95);
}

/* ============================================
   表格卡片
   ============================================ */
#page-community-home .table-card {
    border-radius: 16px;
    background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.04));
    border: 1px solid rgba(255,255,255,0.1);
    overflow: hidden;
}

#page-community-home .table-wrapper {
    overflow-x: auto;
}

#page-community-home .data-table {
    width: 100%;
    border-collapse: collapse;
}

#page-community-home .data-table th,
#page-community-home .data-table td {
    padding: 14px 18px;
    text-align: left;
}

#page-community-home .data-table th {
    font-size: 13px;
    font-weight: 600;
    color: rgba(255,255,255,0.7);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

#page-community-home .data-table td {
    font-size: 14px;
    color: rgba(255,255,255,0.85);
    border-bottom: 1px solid rgba(255,255,255,0.06);
}

#page-community-home .data-table tr:hover td {
    background: rgba(255,255,255,0.04);
}

#page-community-home .table-empty {
    text-align: center !important;
    color: rgba(255,255,255,0.5) !important;
}

/* ============================================
   分页
   ============================================ */
#page-community-home .pagination-nav {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-community-home .pagination {
    display: flex;
    gap: 8px;
    list-style: none;
    padding: 0;
    margin: 0;
}

#page-community-home .pagination li {
    display: flex;
}

#page-community-home .pagination li a,
#page-community-home .pagination li span {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 40px;
    height: 40px;
    padding: 0 12px;
    border-radius: 10px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.75);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    position: relative;
    overflow: hidden;
}

#page-community-home .pagination li a::before,
#page-community-home .pagination li span::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
    transition: left 0.4s ease;
}

#page-community-home .pagination li a:hover::before,
#page-community-home .pagination li.active span::before {
    left: 100%;
}

#page-community-home .pagination li a:hover,
#page-community-home .pagination li.active span {
    background: rgba(255,255,255,0.15);
    border-color: rgba(255,255,255,0.2);
    color: rgba(255,255,255,0.95);
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(255,255,255,0.1);
}

#page-community-home .pagination li.disabled span {
    opacity: 0.4;
    cursor: not-allowed;
}

/* ============================================
   响应式设计
   ============================================ */
@media (max-width: 1024px) {
    #page-community-home {
        padding: 24px 20px;
    }

    #page-community-home .page-header {
        flex-direction: column;
        gap: 16px;
        align-items: flex-start;
    }

    #page-community-home .page-stats {
        width: 100%;
        justify-content: space-around;
    }

    #page-community-home .community-name {
        font-size: 22px;
    }
}

@media (max-width: 768px) {
    #page-community-home {
        padding: 20px 16px;
    }

    #page-community-home .btn-back span {
        display: none;
    }

    #page-community-home .btn-back {
        padding: 10px;
    }

    #page-community-home .banner-content {
        flex-direction: column;
        text-align: center;
        gap: 16px;
    }

    #page-community-home .community-name {
        font-size: 20px;
    }

    #page-community-home .community-desc {
        font-size: 13px;
    }

    #page-community-home .tabs-container {
        flex-wrap: wrap;
        gap: 4px;
        padding: 4px;
    }

    #page-community-home .tab-btn {
        flex: 1;
        min-width: calc(50% - 4px);
        padding: 10px 12px;
        font-size: 13px;
    }

    #page-community-home .tab-btn span {
        display: none;
    }

    #page-community-home .overview-grid {
        grid-template-columns: 1fr;
        gap: 16px;
    }

    #page-community-home .events-header {
        flex-direction: column;
        align-items: stretch;
        gap: 12px;
    }

    #page-community-home .search-box {
        max-width: 100%;
        min-width: 100%;
    }

    #page-community-home .btn-primary {
        justify-content: center;
    }

    #page-community-home .cards-grid {
        grid-template-columns: 1fr;
        gap: 16px;
    }

    #page-community-home .data-table th,
    #page-community-home .data-table td {
        padding: 12px 14px;
        font-size: 13px;
    }
}

@media (max-width: 480px) {
    #page-community-home .page-stats {
        flex-wrap: wrap;
        gap: 8px;
    }

    #page-community-home .stat-item {
        flex: 1;
        min-width: calc(50% - 8px);
    }

    #page-community-home .stat-divider {
        display: none;
    }

    #page-community-home .stat-value {
        font-size: 18px;
    }

    #page-community-home .btn-primary span {
        display: none;
    }

    #page-community-home .btn-primary {
        padding: 12px;
    }
}
</style>