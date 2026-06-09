<div id="page-events" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Events Management</h1>
            <p class="page-subtitle">Browse and manage all events</p>
        </div>
        <button class="btn btn-primary" onclick="showPage('create-event')">
            <i class="fas fa-plus me-2"></i>New Event
        </button>
    </div>

    <div class="search-bar">
        <div class="search-input-group">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="form-control" placeholder="Search events..." id="eventSearchInput">
        </div>
    </div>

    <div class="cards-grid" id="eventsList">
    </div>

    <nav class="pagination-container" aria-label="Page navigation">
        <ul class="pagination" id="eventsPagination"></ul>
    </nav>
</div>

<style>
#page-events .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-events .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-events .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-events .search-bar {
    margin-bottom: 24px;
}

#page-events .search-input-group {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 16px;
    width: 100%;
    max-width: 400px;
    height: 44px;
    border-radius: 12px;
    background: var(--white-08);
    border: 1px solid var(--white-12);
}

#page-events .search-input-group .search-icon {
    color: var(--white-65);
}

#page-events .search-input-group .form-control {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;
    color: var(--white-90);
    font-size: 14px;
}

#page-events .search-input-group .form-control::placeholder {
    color: var(--white-65);
}

#page-events .cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-events .cards-grid .event-card {
    display: flex;
    flex-direction: column;
    border-radius: 20px;
    overflow: hidden;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border: 1px solid rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 
        0 8px 32px rgba(255, 255, 255, 0.06),
        0 0 20px rgba(255, 255, 255, 0.03),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
}

#page-events .cards-grid .event-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.08) 0%, transparent 100%);
    pointer-events: none;
    z-index: 0;
}

#page-events .cards-grid .event-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 
        0 20px 50px rgba(255, 255, 255, 0.1),
        0 0 30px rgba(255, 255, 255, 0.05),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.06));
}

#page-events .cards-grid .event-banner {
    height: 100px;
    position: relative;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

#page-events .cards-grid .event-content {
    padding: 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

#page-events .cards-grid .event-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-events .cards-grid .event-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-events .cards-grid .event-meta {
    display: flex;
    flex-direction: column;
    gap: 8px;
    font-size: 13px;
    color: var(--white-65);
}

#page-events .cards-grid .event-meta-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

#page-events .cards-grid .event-category {
    margin-top: auto;
}

#page-events .cards-grid .category-tag {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 8px;
    background: var(--white-10);
    color: var(--white-80);
    font-size: 12px;
    font-weight: 500;
}

#page-events .cards-grid .event-badge {
    position: absolute;
    top: 12px;
    right: 12px;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-events .cards-grid .event-badge.active {
    background: rgba(37, 184, 166, 0.25);
    color: var(--primary-color);
}

#page-events .cards-grid .event-badge.upcoming {
    background: rgba(139, 92, 246, 0.25);
    color: #a78bfa;
}

#page-events .cards-grid .event-badge.past {
    background: rgba(160, 174, 192, 0.25);
    color: var(--white-65);
}

#page-events .cards-grid .event-actions {
    display: flex;
    gap: 10px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    z-index: 1;
}

#page-events .cards-grid .event-card:hover .event-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-events .cards-grid .event-action-btn {
    flex: 1;
    padding: 10px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

#page-events .cards-grid .event-action-btn.view {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-events .cards-grid .event-action-btn.view:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-events .cards-grid .event-action-btn.write {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-events .cards-grid .event-action-btn.write:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-events .cards-grid .event-action-btn.delete {
    background: rgba(232, 116, 116, 0.2);
    color: rgba(232, 116, 116, 0.9);
    border: 1px solid rgba(232, 116, 116, 0.3);
    box-shadow: 0 2px 8px rgba(232, 116, 116, 0.2);
}

#page-events .cards-grid .event-action-btn.delete:hover {
    background: rgba(232, 116, 116, 0.3);
}

#page-events .cards-grid .event-action-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

#page-events .cards-grid .action-btn {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: rgba(255, 255, 255, 0.8);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
    font-size: 14px;
}

#page-events .cards-grid .action-btn:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.25);
    color: rgba(255, 255, 255, 0.95);
    transform: scale(1.1);
}

#page-events .cards-grid .action-btn:active {
    transform: scale(0.95);
}

#page-events .cards-grid .action-btn.secondary {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.15);
    color: rgba(255, 255, 255, 0.8);
}

#page-events .cards-grid .action-btn.danger {
    background: rgba(232, 116, 116, 0.15);
    border-color: rgba(232, 116, 116, 0.3);
    color: rgba(232, 116, 116, 0.9);
}

#page-events .cards-grid .action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    border-color: rgba(232, 116, 116, 0.4);
    color: var(--accent-red);
}

#page-events .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-events .pagination {
    display: flex;
    gap: 10px;
    list-style: none;
    padding: 0;
    margin: 0;
}

#page-events .pagination li {
    display: flex;
}

#page-events .pagination li a,
#page-events .pagination li span {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 44px;
    height: 44px;
    padding: 0 14px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
    font-size: 13px;
    font-weight: 500;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    box-shadow: 
        0 2px 8px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
    position: relative;
    overflow: hidden;
}

#page-events .pagination li a::before,
#page-events .pagination li span::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.4s ease;
}

#page-events .pagination li a:hover,
#page-events .pagination li.active span,
#page-events .pagination li.active a {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 4px 14px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.12);
    transform: translateY(-2px);
}

#page-events .pagination li a:hover::before,
#page-events .pagination li.active span::before,
#page-events .pagination li.active a::before {
    left: 100%;
}

#page-events .pagination li a:active,
#page-events .pagination li span:active {
    transform: translateY(0);
    box-shadow: 
        0 2px 6px rgba(255, 255, 255, 0.05),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

#page-events .pagination li.disabled span,
#page-events .pagination li.disabled a {
    opacity: 0.4;
    cursor: not-allowed;
    transform: none;
}

#page-events .btn-primary {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 12px 24px;
    background: rgba(255, 255, 255, 0.1) !important;
    border: 1px solid rgba(255, 255, 255, 0.15) !important;
    border-radius: 12px;
    color: rgba(255, 255, 255, 0.9) !important;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 
        0 4px 16px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    position: relative;
    overflow: hidden;
}

#page-events .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.5s ease;
}

#page-events .btn-primary:hover::before {
    left: 100%;
}

#page-events .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15) !important;
    border-color: rgba(255, 255, 255, 0.25) !important;
    transform: translateY(-2px);
    box-shadow: 
        0 8px 24px rgba(255, 255, 255, 0.12),
        0 0 30px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-events .btn-primary:active {
    transform: translateY(0);
    box-shadow: 
        0 4px 12px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

#page-events .btn-primary:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none;
}
</style>
