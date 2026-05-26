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
    border-radius: 16px;
    overflow: hidden;
    background: var(--white-08);
    border: 1px solid var(--white-12);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

#page-events .cards-grid .event-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
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
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-events .cards-grid .event-card:hover .event-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-events .cards-grid .event-action-btn {
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

#page-events .cards-grid .event-action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-events .cards-grid .event-action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-events .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-events .pagination {
    display: flex;
    gap: 8px;
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

#page-events .pagination li a:hover,
#page-events .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-events .pagination li.disabled span {
    opacity: 0.5;
    cursor: not-allowed;
}

#page-events .btn-primary {
    display: inline-flex;
    align-items: center;
    padding: 10px 20px;
    background: var(--primary-color);
    border: none;
    border-radius: 12px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 12px rgba(37, 184, 166, 0.3);
}

#page-events .btn-primary:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(37, 184, 166, 0.4);
}
</style>
