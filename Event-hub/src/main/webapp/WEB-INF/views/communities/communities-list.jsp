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

#page-communities .communities-grid .community-card::before {
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

#page-communities .communities-grid .community-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 
        0 20px 50px rgba(255, 255, 255, 0.1),
        0 0 30px rgba(255, 255, 255, 0.05),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.06));
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
    border: 3px solid rgba(255, 255, 255, 0.2);
    position: absolute;
    top: 44px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.75rem;
    box-shadow: 
        0 4px 20px rgba(255, 255, 255, 0.15),
        0 0 30px rgba(255, 255, 255, 0.08);
    background: rgba(255, 255, 255, 0.1);
    z-index: 1;
}

#page-communities .communities-grid .community-logo-text {
    color: rgba(255, 255, 255, 0.9);
    font-weight: 700;
}

#page-communities .communities-grid .community-content {
    padding: 48px 20px 16px;
    text-align: center;
    flex: 1;
    position: relative;
    z-index: 1;
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
    background: rgba(255, 255, 255, 0.08);
    color: rgba(255, 255, 255, 0.8);
    font-size: 11px;
    font-weight: 500;
}

#page-communities .communities-grid .community-actions {
    display: flex;
    gap: 10px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    z-index: 1;
}

#page-communities .communities-grid .community-card:hover .community-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-communities .communities-grid .community-action-btn {
    flex: 1;
    padding: 10px;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

#page-communities .communities-grid .community-action-btn.view {
    background: rgba(255, 255, 255, 0.08);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

#page-communities .communities-grid .community-action-btn.view:hover {
    background: rgba(255, 255, 255, 0.15);
    color: rgba(255, 255, 255, 0.95);
    transform: translateY(-2px);
}

#page-communities .communities-grid .community-action-btn.join {
    background: rgba(255, 255, 255, 0.08);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

#page-communities .communities-grid .community-action-btn.join:hover {
    background: rgba(255, 255, 255, 0.15);
    color: rgba(255, 255, 255, 0.95);
    transform: translateY(-2px);
}

#page-communities .communities-grid .community-action-btn.enter {
    background: rgba(255, 255, 255, 0.12);
    color: rgba(255, 255, 255, 0.9);
    border: 1px solid rgba(255, 255, 255, 0.2);
    font-weight: 600;
}

#page-communities .communities-grid .community-action-btn.enter:hover {
    background: rgba(255, 255, 255, 0.18);
    color: rgba(255, 255, 255, 0.95);
    transform: translateY(-2px);
}

#page-communities .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-communities .pagination {
    display: flex;
    gap: 10px;
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

#page-communities .pagination li a::before,
#page-communities .pagination li span::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.4s ease;
}

#page-communities .pagination li a:hover,
#page-communities .pagination li.active span,
#page-communities .pagination li.active a {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    color: rgba(255, 255, 255, 0.95);
    box-shadow: 
        0 4px 14px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.12);
    transform: translateY(-2px);
}

#page-communities .pagination li a:hover::before,
#page-communities .pagination li.active span::before,
#page-communities .pagination li.active a::before {
    left: 100%;
}

#page-communities .pagination li.disabled span,
#page-communities .pagination li.disabled a {
    opacity: 0.4;
    cursor: not-allowed;
    transform: none;
}

#page-communities .btn-primary {
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

#page-communities .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.5s ease;
}

#page-communities .btn-primary:hover::before {
    left: 100%;
}

#page-communities .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15) !important;
    border-color: rgba(255, 255, 255, 0.25) !important;
    transform: translateY(-2px);
    box-shadow: 
        0 8px 24px rgba(255, 255, 255, 0.12),
        0 0 30px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-communities .btn-primary:active {
    transform: translateY(0);
    box-shadow: 
        0 4px 12px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

@media (max-width: 767px) {
    #page-communities .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }
    
    #page-communities .communities-grid {
        grid-template-columns: 1fr;
    }
}
</style>