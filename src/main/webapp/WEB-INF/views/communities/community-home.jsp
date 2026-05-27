<div id="page-community-home" class="page-content d-none">
    <div class="mb-4">
        <button class="btn btn-outline-primary" onclick="showPage('communities')">
            <i class="fas fa-arrow-left me-2"></i>Back to Communities
        </button>
    </div>

    <div id="communityHomeContent">
        <div class="community-banner p-6 mb-6">
            <div class="d-flex align-items-center">
                <div class="text-5xl mr-4" id="communityLogo">🏘️</div>
                <div>
                    <h1 class="text-white text-3xl font-bold" id="communityName">Community Name</h1>
                    <p class="text-purple-100 mt-2" id="communityDescription">Community description</p>
                </div>
            </div>
        </div>

        <div class="row mb-6" id="communityStatsRow">
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">👥</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityMembers">0</div>
                    <div class="text-sm text-gray-500">Members</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">📅</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityEvents">0</div>
                    <div class="text-sm text-gray-500">Events</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">📝</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityRegistrations">0</div>
                    <div class="text-sm text-gray-500">Registrations</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">🔄</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityUpcoming">0</div>
                    <div class="text-sm text-gray-500">Upcoming Events</div>
                </div>
            </div>
        </div>

        <div class="community-tabs">
            <button class="tab-btn active" onclick="switchCommunityTab('overview')" data-tab="overview">
                <i class="fas fa-home"></i> Overview
            </button>
            <button class="tab-btn" onclick="switchCommunityTab('events')" data-tab="events">
                <i class="fas fa-calendar"></i> Events
            </button>
            <button class="tab-btn" onclick="switchCommunityTab('members')" data-tab="members">
                <i class="fas fa-users"></i> Members
            </button>
            <button class="tab-btn" id="tabBtnApplications" style="display:none;" onclick="switchCommunityTab('applications')" data-tab="applications">
                <i class="fas fa-clipboard-check"></i> Applications
                <span class="tab-badge" id="pendingAppBadge" style="display:none;">0</span>
            </button>
        </div>

        <div id="tab-overview" class="tab-panel">
            <div class="row">
                <div class="col-md-6">
                    <div class="bg-white rounded-xl p-4 shadow-sm">
                        <div class="d-flex justify-content-between mb-4">
                            <h3 class="font-bold">Recent Events</h3>
                            <button class="btn btn-sm btn-primary" onclick="switchCommunityTab('events')">View All</button>
                        </div>
                        <div id="communityRecentEvents">
                            <div class="text-center text-gray-500 py-6">
                                <div class="text-3xl mb-2">📅</div>
                                <p>No events yet</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="bg-white rounded-xl p-4 shadow-sm">
                        <div class="d-flex justify-content-between mb-4">
                            <h3 class="font-bold">New Members</h3>
                            <button class="btn btn-sm btn-primary" onclick="switchCommunityTab('members')">View All</button>
                        </div>
                        <div id="communityNewMembers">
                            <div class="text-center text-gray-500 py-6">
                                <div class="text-3xl mb-2">👥</div>
                                <p>No members yet</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="tab-events" class="tab-panel d-none">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="search-input-group" style="max-width: 320px;">
                    <i class="fas fa-search" style="color: var(--white-65);"></i>
                    <input type="text" class="form-control" placeholder="Search events..." id="communityEventSearchInput"
                           style="flex:1;background:transparent;border:none;outline:none;color:var(--white-90);font-size:14px;">
                </div>
                <button class="btn btn-primary" id="btnCreateCommunityEvent" style="display:none;" onclick="createCommunityEvent()">
                    <i class="fas fa-plus me-2"></i>Create Event
                </button>
            </div>
            <div class="cards-grid" id="communityEventsList"></div>
            <nav class="pagination-container" aria-label="Community events pagination">
                <ul class="pagination" id="communityEventsPagination"></ul>
            </nav>
        </div>

        <div id="tab-members" class="tab-panel d-none">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th id="thMemberActions" style="display:none;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="communityMembersTableBody">
                            <tr><td colspan="4" class="text-center text-gray-500">Loading...</td></tr>
                        </tbody>
                    </table>
                </div>
                <nav class="pagination-container" aria-label="Community members pagination">
                    <ul class="pagination" id="communityMembersPagination"></ul>
                </nav>
            </div>
        </div>

        <div id="tab-applications" class="tab-panel d-none">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Applicant</th>
                                <th>Message</th>
                                <th>Applied</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="communityApplicationsTableBody">
                            <tr><td colspan="4" class="text-center text-gray-500">Loading...</td></tr>
                        </tbody>
                    </table>
                </div>
                <nav class="pagination-container" aria-label="Applications pagination">
                    <ul class="pagination" id="communityApplicationsPagination"></ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<style>
.community-tabs {
    display: flex;
    gap: 4px;
    padding: 4px;
    background: var(--white-08);
    border-radius: 14px;
    border: 1px solid var(--white-12);
    margin-bottom: 24px;
    backdrop-filter: blur(16px);
}

.tab-btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    padding: 10px 16px;
    border: none;
    border-radius: 10px;
    background: transparent;
    color: var(--white-65);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
}

.tab-btn:hover {
    color: var(--white-90);
    background: var(--white-06);
}

.tab-btn.active {
    background: var(--primary-color);
    color: white;
    box-shadow: 0 2px 8px rgba(37, 184, 166, 0.3);
}

.tab-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    border-radius: 10px;
    background: var(--accent-red);
    color: white;
    font-size: 11px;
    font-weight: 600;
}

.tab-panel {
    animation: tabFadeIn 0.25s ease;
}

@keyframes tabFadeIn {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
}

#page-community-home .cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-community-home .cards-grid .event-card {
    display: flex;
    flex-direction: column;
    border-radius: 16px;
    overflow: hidden;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-community-home .cards-grid .event-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-community-home .cards-grid .event-banner {
    height: 100px;
    position: relative;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

#page-community-home .cards-grid .event-content {
    padding: 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

#page-community-home .cards-grid .event-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-community-home .cards-grid .event-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-community-home .cards-grid .event-meta {
    display: flex;
    flex-direction: column;
    gap: 8px;
    font-size: 13px;
    color: var(--white-65);
}

#page-community-home .cards-grid .event-meta-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

#page-community-home .cards-grid .event-badge {
    position: absolute;
    top: 12px;
    right: 12px;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-community-home .cards-grid .event-badge.upcoming {
    background: rgba(139, 92, 246, 0.25);
    color: #a78bfa;
}

#page-community-home .cards-grid .event-badge.ongoing {
    background: rgba(37, 184, 166, 0.25);
    color: var(--primary-color);
}

#page-community-home .cards-grid .event-badge.ended {
    background: rgba(160, 174, 192, 0.25);
    color: var(--white-65);
}

#page-community-home .cards-grid .event-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-community-home .cards-grid .event-card:hover .event-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-community-home .cards-grid .event-action-btn {
    flex: 1;
    padding: 10px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-community-home .cards-grid .event-action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-community-home .cards-grid .event-action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-community-home .pagination-container {
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
    border-radius: 8px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    color: var(--white-80);
    text-decoration: none;
    transition: all 0.2s;
    cursor: pointer;
}

#page-community-home .pagination li a:hover,
#page-community-home .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-community-home .pagination li.disabled span {
    opacity: 0.5;
    cursor: not-allowed;
}

#page-community-home .search-input-group {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 16px;
    height: 44px;
    border-radius: 12px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
}
</style>
