<div id="page-community-approvals" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Community Creation Approvals</h1>
            <p class="page-subtitle">Review and manage community creation requests</p>
        </div>
    </div>

    <div class="tabs-container" id="approvalTabs">
        <button class="tab-btn active" onclick="selectApprovalTab('PENDING')">Pending</button>
        <button class="tab-btn" onclick="selectApprovalTab('APPROVED')">Approved</button>
        <button class="tab-btn" onclick="selectApprovalTab('REJECTED')">Rejected</button>
    </div>

    <div class="approvals-grid" id="communityCreationApplicationsList">
    </div>
    
    <nav aria-label="Page navigation" class="mt-6">
        <ul class="pagination justify-content-center" id="communityCreationApplicationsPagination">
        </ul>
    </nav>
</div>

<style>
#page-community-approvals .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-community-approvals .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-community-approvals .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-community-approvals .tabs-container {
    display: flex;
    gap: 8px;
    margin-bottom: 24px;
}

#page-community-approvals .tab-btn {
    padding: 10px 20px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    background: transparent;
    color: rgba(255, 255, 255, 0.8);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

#page-community-approvals .tab-btn.active,
#page-community-approvals .tab-btn:hover {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-community-approvals .approvals-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 24px;
}

#page-community-approvals .approval-card {
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

#page-community-approvals .approval-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
}

#page-community-approvals .approval-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 20px;
}

#page-community-approvals .approval-icon {
    width: 56px;
    height: 56px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}

#page-community-approvals .approval-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-community-approvals .approval-status.pending {
    background: rgba(245, 166, 35, 0.25);
    color: #fbbf24;
}

#page-community-approvals .approval-status.approved {
    background: rgba(126, 217, 87, 0.25);
    color: #4ade80;
}

#page-community-approvals .approval-status.rejected {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-community-approvals .approval-content {
    padding: 0 20px 16px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex: 1;
}

#page-community-approvals .approval-name {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-community-approvals .approval-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-community-approvals .approval-meta {
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-size: 12px;
    color: var(--white-65);
    margin-top: 8px;
}

#page-community-approvals .meta-item {
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-community-approvals .approval-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
}

#page-community-approvals .action-btn {
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
    gap: 6px;
    font-size: 13px;
    font-weight: 500;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-community-approvals .action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-community-approvals .action-btn.approve {
    background: rgba(37, 184, 166, 0.3);
    border-color: rgba(37, 184, 166, 0.4);
    color: white;
}

#page-community-approvals .action-btn.approve:hover {
    background: rgba(37, 184, 166, 0.5);
}

#page-community-approvals .action-btn.reject:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-community-approvals .pagination {
    display: flex;
    gap: 8px;
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
    padding: 8px 12px;
    border-radius: 8px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    color: var(--white-80);
    text-decoration: none;
    font-size: 13px;
    transition: all 0.2s;
}

#page-community-approvals .pagination li a:hover,
#page-community-approvals .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

@media (max-width: 767px) {
    #page-community-approvals .approvals-grid {
        grid-template-columns: 1fr;
    }
}
</style>
