<div id="page-users" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Users Management</h1>
            <p class="page-subtitle">Manage all registered users</p>
        </div>
        <button class="btn btn-primary" onclick="showPage('create-user')">
            <i class="fas fa-plus me-2"></i>New User
        </button>
    </div>

    <div class="search-bar">
        <div class="search-input-group">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="form-control" placeholder="Search users..." id="userSearchInput">
        </div>
    </div>

    <div class="users-grid" id="usersList">
    </div>

    <nav class="pagination-container" aria-label="Page navigation">
        <ul class="pagination" id="usersPagination"></ul>
    </nav>
</div>

<style>
#page-users .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-users .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-users .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-users .search-bar {
    margin-bottom: 24px;
}

#page-users .search-input-group {
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

#page-users .search-input-group .search-icon {
    color: var(--white-65);
}

#page-users .search-input-group .form-control {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;
    color: var(--white-90);
    font-size: 14px;
}

#page-users .search-input-group .form-control::placeholder {
    color: var(--white-65);
}

#page-users .users-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-users .user-card {
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

#page-users .user-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-users .user-card-header {
    padding: 20px 20px 0;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
}

#page-users .user-avatar {
    width: 56px;
    height: 56px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 600;
    position: relative;
    overflow: hidden;
}

#page-users .user-avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

#page-users .user-avatar-text {
    color: white;
    font-size: 20px;
    font-weight: 600;
}

#page-users .user-role-badge {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-users .user-role-badge.admin {
    background: rgba(168, 85, 247, 0.25);
    color: #a78bfa;
}

#page-users .user-role-badge.member {
    background: rgba(37, 184, 166, 0.25);
    color: var(--primary-color);
}

#page-users .user-card-content {
    padding: 16px 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-users .user-name {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-users .user-email {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
}

#page-users .user-stats {
    display: flex;
    gap: 16px;
    font-size: 13px;
    color: var(--white-65);
    margin-top: 8px;
}

#page-users .user-stat {
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-users .user-status {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    margin-top: 8px;
}

#page-users .user-status.active {
    color: #22c55e;
}

#page-users .user-status.inactive {
    color: var(--white-65);
}

#page-users .status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: currentColor;
}

#page-users .user-card-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-users .user-card:hover .user-card-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-users .action-btn {
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

#page-users .action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-users .action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-users .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 32px;
}

#page-users .pagination {
    display: flex;
    gap: 8px;
    list-style: none;
    padding: 0;
    margin: 0;
}

#page-users .pagination li {
    display: flex;
}

#page-users .pagination li a,
#page-users .pagination li span {
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

#page-users .pagination li a:hover,
#page-users .pagination li.active span {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

#page-users .btn-primary {
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

#page-users .btn-primary:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(37, 184, 166, 0.4);
}
</style>
