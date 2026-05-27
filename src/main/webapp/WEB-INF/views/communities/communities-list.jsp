<div id="page-communities" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Communities</h1>
            <p class="page-subtitle">Discover and join communities</p>
        </div>
        <button class="btn btn-primary" onclick="showPage('create-community')">
            <i class="fas fa-plus me-2"></i>Create Community
        </button>
    </div>

    <div class="search-bar">
        <div class="search-input-group">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="form-control" placeholder="Search communities..." id="communitySearchInput">
        </div>
    </div>

    <div class="communities-grid" id="communitiesList">
    </div>

    <nav class="pagination-container" aria-label="Page navigation">
        <ul class="pagination" id="communitiesPagination"></ul>
    </nav>
</div>

<style>
#page-communities .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-communities .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-communities .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-communities .search-bar {
    margin-bottom: 24px;
}

#page-communities .search-input-group {
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

#page-communities .search-input-group .search-icon {
    color: var(--white-65);
}

#page-communities .search-input-group .form-control {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;
    color: var(--white-90);
    font-size: 14px;
}

#page-communities .search-input-group .form-control::placeholder {
    color: var(--white-65);
}

#page-communities .communities-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-communities .communities-grid .community-card {
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
    position: relative;
}

#page-communities .communities-grid .community-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-communities .communities-grid .community-banner {
    height: 80px;
    position: relative;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

#page-communities .communities-grid .community-logo {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    border: 4px solid rgba(255, 255, 255, 0.3);
    position: absolute;
    top: 44px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.75rem;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    background: var(--primary-color);
}

#page-communities .communities-grid .community-logo-text {
    color: white;
    font-weight: 700;
}

#page-communities .communities-grid .community-content {
    padding: 48px 20px 16px;
    text-align: center;
    flex: 1;
}

#page-communities .communities-grid .community-name {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0 0 8px 0;
}

#page-communities .communities-grid .community-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0 0 12px 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-communities .communities-grid .community-stats {
    display: flex;
    justify-content: center;
    gap: 16px;
    font-size: 13px;
    color: var(--white-65);
}

#page-communities .communities-grid .community-stat {
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-communities .communities-grid .community-tags {
    display: flex;
    justify-content: center;
    gap: 8px;
    padding: 0 20px 12px;
    flex-wrap: wrap;
}

#page-communities .communities-grid .tag {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 8px;
    background: var(--white-10);
    color: var(--white-80);
    font-size: 11px;
    font-weight: 500;
}

#page-communities .communities-grid .community-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-communities .communities-grid .community-card:hover .community-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-communities .communities-grid .community-action-btn {
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

#page-communities .communities-grid .community-action-btn.view {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-communities .communities-grid .community-action-btn.view:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-communities .communities-grid .community-action-btn.join {
    background: rgba(37, 184, 166, 0.3);
    color: white;
    border: 1px solid rgba(37, 184, 166, 0.4);
    box-shadow: 0 2px 8px rgba(37, 184, 166, 0.3);
}

#page-communities .communities-grid .community-action-btn.join:hover {
    background: rgba(37, 184, 166, 0.5);
}

#page-communities .communities-grid .community-action-btn.enter {
    background: rgba(37, 184, 166, 0.4);
    color: white;
    border: 1px solid rgba(37, 184, 166, 0.5);
    box-shadow: 0 2px 8px rgba(37, 184, 166, 0.35);
    font-weight: 600;
}

#page-communities .communities-grid .community-action-btn.enter:hover {
    background: rgba(37, 184, 166, 0.6);
    box-shadow: 0 4px 12px rgba(37, 184, 166, 0.5);
}

#page-communities .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-communities .pagination {
    display: flex;
    gap: 8px;
    list-style: none;
    padding: 0;
    margin: 0;
}

#page-communities .pagination li {
    display: flex;
}

#page-communities .pagination li a,
#page-communities .pagination li span {
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

#page-communities .pagination li a:hover,
#page-communities .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-communities .btn-primary {
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

#page-communities .btn-primary:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(37, 184, 166, 0.4);
}
</style>
