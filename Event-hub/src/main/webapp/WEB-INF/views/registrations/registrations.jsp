<div id="page-registrations" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Registrations Management</h1>
            <p class="page-subtitle">View and manage all event registrations</p>
        </div>
    </div>

    <div class="search-bar">
        <div class="search-input-group">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="form-control" placeholder="Search registrations..." id="registrationSearchInput">
        </div>
    </div>

    <div class="registration-cards-grid" id="registrationsList">
    </div>
</div>

<style>
#page-registrations .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-registrations .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-registrations .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-registrations .search-bar {
    margin-bottom: 24px;
}

#page-registrations .search-input-group {
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

#page-registrations .search-input-group .search-icon {
    color: var(--white-65);
}

#page-registrations .search-input-group .form-control {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;
    color: var(--white-90);
    font-size: 14px;
}

#page-registrations .search-input-group .form-control::placeholder {
    color: var(--white-65);
}

#page-registrations .registration-cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-registrations .registration-card {
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

#page-registrations .registration-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-registrations .registration-header {
    padding: 16px 20px 0;
    display: flex;
    justify-content: flex-end;
}

#page-registrations .registration-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#page-registrations .registration-status.active,
#page-registrations .registration-status.confirmed {
    background: rgba(37, 184, 166, 0.25);
    color: var(--primary-color);
}

#page-registrations .registration-status.pending {
    background: rgba(245, 166, 35, 0.25);
    color: #fbbf24;
}

#page-registrations .registration-content {
    padding: 16px 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

#page-registrations .registration-user {
    display: flex;
    align-items: center;
    gap: 12px;
}

#page-registrations .user-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    font-weight: 600;
}

#page-registrations .user-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

#page-registrations .user-name {
    font-size: 15px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-registrations .user-email {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
}

#page-registrations .registration-details {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-registrations .detail-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

#page-registrations .detail-label {
    font-size: 13px;
    color: var(--white-65);
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-registrations .detail-value {
    font-size: 13px;
    color: var(--white-80);
}

#page-registrations .registration-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-registrations .registration-card:hover .registration-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-registrations .action-btn {
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

#page-registrations .action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-registrations .action-btn.primary {
    background: rgba(37, 184, 166, 0.3);
    border-color: rgba(37, 184, 166, 0.4);
}

#page-registrations .action-btn.primary:hover {
    background: rgba(37, 184, 166, 0.5);
}

#page-registrations .action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}
</style>
