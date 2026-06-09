<div id="page-applications" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">My Applications</h1>
            <p class="page-subtitle">Track your community applications</p>
        </div>
    </div>

    <div class="tabs-container" id="appTabs">
        <button class="tab-btn active" onclick="switchApplicationTab('join')">Community Join Applications</button>
        <button class="tab-btn" onclick="switchApplicationTab('create')">Community Creation Applications</button>
    </div>

    <div id="tab-applications-join" class="tab-panel">
        <div class="applications-grid" id="joinApplicationsList">
            <div class="text-center text-gray-500 py-8 empty-state">
                <div class="text-4xl mb-3"><i class="fas fa-clipboard-list"></i></div>
                <p>No join applications</p>
            </div>
        </div>
        <nav aria-label="Join applications pagination" class="mt-6">
            <ul class="pagination justify-content-center" id="joinApplicationsPagination"></ul>
        </nav>
    </div>

    <div id="tab-applications-create" class="tab-panel d-none">
        <div class="applications-grid" id="createApplicationsList">
            <div class="text-center text-gray-500 py-8 empty-state">
                <div class="text-4xl mb-3"><i class="fas fa-file-alt"></i></div>
                <p>No creation applications</p>
            </div>
        </div>
        <nav aria-label="Creation applications pagination" class="mt-6">
            <ul class="pagination justify-content-center" id="createApplicationsPagination"></ul>
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

#page-applications .tabs-container {
    display: flex;
    gap: 12px;
    margin-bottom: 24px;
}

#page-applications .tab-btn {
    padding: 12px 24px;
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    color: rgba(255, 255, 255, 0.8);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 
        0 2px 8px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
    position: relative;
    overflow: hidden;
}

#page-applications .tab-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.5s ease;
}

#page-applications .tab-btn:hover::before {
    left: 100%;
}

#page-applications .tab-btn:hover {
    background: rgba(255, 255, 255, 0.12);
    border-color: rgba(255, 255, 255, 0.25);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 4px 16px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    transform: translateY(-2px);
}

#page-applications .tab-btn.active {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 4px 16px rgba(255, 255, 255, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-applications .tab-btn:active {
    transform: translateY(0);
    box-shadow: 
        0 2px 8px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

#page-applications .tab-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none;
}

#page-applications .tab-panel {
    animation: appTabFadeIn 0.25s ease;
}

@keyframes appTabFadeIn {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
}

#page-applications .applications-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 24px;
}

#page-applications .application-card {
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

#page-applications .application-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-applications .app-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 20px;
}

#page-applications .app-icon {
    width: 56px;
    height: 56px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
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

#page-applications .app-content {
    padding: 0 20px 16px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    flex: 1;
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

#page-applications .meta-item {
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-applications .app-actions {
    display: flex;
    gap: 10px;
    padding: 0 20px 20px;
}

#page-applications .action-btn {
    flex: 1;
    padding: 12px 16px;
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.08);
    color: rgba(255, 255, 255, 0.85);
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 13px;
    font-weight: 500;
    box-shadow: 
        0 4px 12px rgba(0, 0, 0, 0.12),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
    position: relative;
    overflow: hidden;
}

#page-applications .action-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.4s ease;
}

#page-applications .action-btn:hover::before {
    left: 100%;
}

#page-applications .action-btn:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.25);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 6px 20px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.12);
    transform: translateY(-2px);
}

#page-applications .action-btn:active {
    transform: translateY(0);
    box-shadow: 
        0 3px 10px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

#page-applications .action-btn.cancel {
    background: rgba(232, 116, 116, 0.1);
    border-color: rgba(232, 116, 116, 0.2);
    color: rgba(232, 116, 116, 0.8);
}

#page-applications .action-btn.cancel:hover {
    background: rgba(232, 116, 116, 0.2);
    border-color: rgba(232, 116, 116, 0.4);
    color: var(--accent-red);
    box-shadow: 
        0 6px 20px rgba(232, 116, 116, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-applications .action-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none;
}

#page-applications .empty-state {
    grid-column: 1 / -1;
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

#page-applications nav[aria-label] {
    margin-top: 24px;
    display: flex;
    justify-content: center;
}

#page-applications .pagination {
    display: flex;
    gap: 10px;
    list-style: none;
    padding: 0;
    margin: 0;
    justify-content: center;
    flex-wrap: wrap;
}

#page-applications .pagination li {
    display: flex;
}

#page-applications .pagination li a,
#page-applications .pagination li span {
    padding: 10px 16px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    min-width: 44px;
    text-align: center;
    box-shadow: 
        0 2px 8px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
    position: relative;
    overflow: hidden;
}

#page-applications .pagination li a::before,
#page-applications .pagination li span::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.4s ease;
}

#page-applications .pagination li a:hover,
#page-applications .pagination li.active span,
#page-applications .pagination li.active a {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 4px 14px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.12);
    transform: translateY(-2px);
}

#page-applications .pagination li a:hover::before,
#page-applications .pagination li.active span::before,
#page-applications .pagination li.active a::before {
    left: 100%;
}

#page-applications .pagination li a:active,
#page-applications .pagination li span:active {
    transform: translateY(0);
    box-shadow: 
        0 2px 6px rgba(255, 255, 255, 0.05),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

#page-applications .pagination li.disabled span,
#page-applications .pagination li.disabled a {
    opacity: 0.4;
    cursor: not-allowed;
    transform: none;
}

@media (max-width: 767px) {
    #page-applications .applications-grid {
        grid-template-columns: 1fr;
    }
}
</style>
