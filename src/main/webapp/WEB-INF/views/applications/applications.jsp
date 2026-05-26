<div id="page-applications" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">My Applications</h1>
            <p class="page-subtitle">Track your community applications</p>
        </div>
    </div>

    <div class="applications-layout">
        <div class="applications-column">
            <div class="section-header">
                <h2 class="section-title">Community Join Applications</h2>
            </div>
            <div id="joinApplicationsList" class="applications-list">
                <div class="text-center text-gray-500 py-8 empty-state">
                    <div class="text-4xl mb-3">📋</div>
                    <p>No join applications</p>
                </div>
            </div>
        </div>

        <div class="applications-column">
            <div class="section-header">
                <h2 class="section-title">Community Creation Applications</h2>
            </div>
            <div id="createApplicationsList" class="applications-list">
                <div class="text-center text-gray-500 py-8 empty-state">
                    <div class="text-4xl mb-3">📝</div>
                    <p>No creation applications</p>
                </div>
            </div>
        </div>
    </div>

    <div id="adminApplicationsSection" style="display: none; margin-top: 32px;">
        <div class="page-header">
            <div class="page-title-section">
                <h2 class="page-title">Admin - Community Applications</h2>
            </div>
            <div class="tabs-container">
                <button class="tab-btn active" onclick="loadAdminApplications('PENDING')">Pending</button>
                <button class="tab-btn" onclick="loadAdminApplications('APPROVED')">Approved</button>
                <button class="tab-btn" onclick="loadAdminApplications('REJECTED')">Rejected</button>
            </div>
        </div>
        <div id="adminApplicationsList" class="admin-applications-grid">
        </div>
        <nav aria-label="Page navigation" class="mt-6">
            <ul class="pagination justify-content-center" id="adminApplicationsPagination">
            </ul>
        </nav>
    </div>
</div>

<style>
#page-applications .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-applications .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-applications .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-applications .section-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--white-90);
    margin: 0;
}

#page-applications .section-header {
    margin-bottom: 12px;
}

#page-applications .applications-layout {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
}

#page-applications .applications-column {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

#page-applications .applications-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

#page-applications .empty-state {
    padding: 40px 20px;
    border-radius: 16px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
}

#page-applications .empty-state .text-4xl {
    font-size: 48px;
}

#page-applications .empty-state p {
    color: var(--white-65);
    margin: 0;
    font-size: 14px;
}

#page-applications .application-card {
    display: flex;
    gap: 16px;
    padding: 16px;
    border-radius: 16px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-applications .application-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
}

#page-applications .application-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    flex-shrink: 0;
}

#page-applications .application-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
    min-width: 0;
}

#page-applications .application-name {
    font-size: 15px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

#page-applications .application-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
}

#page-applications .application-meta {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 12px;
    color: var(--white-65);
}

#page-applications .meta-item {
    display: flex;
    align-items: center;
    gap: 4px;
}

#page-applications .application-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-applications .application-status.pending {
    background: rgba(245, 166, 35, 0.25);
    color: #fbbf24;
}

#page-applications .application-status.approved {
    background: rgba(126, 217, 87, 0.25);
    color: #4ade80;
}

#page-applications .application-status.rejected {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-applications .application-actions {
    display: flex;
    align-items: center;
}

#page-applications .action-btn {
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

#page-applications .action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-applications .action-btn.cancel:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-applications .action-btn.approve {
    background: rgba(37, 184, 166, 0.3);
    border-color: rgba(37, 184, 166, 0.4);
    color: white;
}

#page-applications .action-btn.approve:hover {
    background: rgba(37, 184, 166, 0.5);
}

#page-applications .action-btn.reject:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-applications .tabs-container {
    display: flex;
    gap: 8px;
}

#page-applications .tab-btn {
    padding: 8px 16px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    background: transparent;
    color: rgba(255, 255, 255, 0.8);
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

#page-applications .tab-btn.active,
#page-applications .tab-btn:hover {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-applications .admin-applications-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 24px;
}

#page-applications .admin-application-card {
    display: flex;
    flex-direction: column;
    border-radius: 16px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
}

#page-applications .admin-application-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
}

#page-applications .admin-app-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 16px;
}

#page-applications .app-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
}

#page-applications .app-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-applications .app-status.pending {
    background: rgba(245, 166, 35, 0.25);
    color: #fbbf24;
}

#page-applications .app-status.approved {
    background: rgba(126, 217, 87, 0.25);
    color: #4ade80;
}

#page-applications .app-status.rejected {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-applications .admin-app-content {
    padding: 0 16px 16px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-applications .app-name {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-applications .app-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-applications .app-meta {
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-size: 12px;
    color: var(--white-65);
    margin-top: 8px;
}

#page-applications .admin-app-actions {
    display: flex;
    gap: 8px;
    padding: 0 16px 16px;
}

#page-applications .admin-app-actions .action-btn {
    flex: 1;
}

#page-applications .pagination {
    display: flex;
    gap: 8px;
    list-style: none;
    padding: 0;
    margin: 0;
    justify-content: center;
}

#page-applications .pagination li {
    display: flex;
}

#page-applications .pagination li a,
#page-applications .pagination li span {
    padding: 8px 12px;
    border-radius: 8px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    color: var(--white-80);
    text-decoration: none;
    font-size: 13px;
    transition: all 0.2s;
}

#page-applications .pagination li a:hover,
#page-applications .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

@media (max-width: 767px) {
    #page-applications .applications-layout {
        grid-template-columns: 1fr;
    }
    
    #page-applications .admin-applications-grid {
        grid-template-columns: 1fr;
    }
}
</style>
