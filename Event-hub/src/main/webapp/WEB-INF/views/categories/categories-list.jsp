<div id="page-categories" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Categories Management</h1>
            <p class="page-subtitle">Organize events with categories</p>
        </div>
        <button class="btn btn-primary" onclick="showPage('create-category')">
            <i class="fas fa-plus me-2"></i>New Category
        </button>
    </div>

    <div class="search-bar">
        <div class="search-input-group">
            <i class="fas fa-search search-icon"></i>
            <input type="text" class="form-control" placeholder="Search categories..." id="categorySearchInput">
        </div>
    </div>

    <div class="categories-grid" id="categoriesList">
    </div>

    <div class="modal-overlay" id="editCategoryModal">
        <div class="modal-container">
            <div class="modal-header">
                <h3 class="modal-title">Edit Category</h3>
                <button class="modal-close" onclick="closeEditCategoryModal()">&times;</button>
            </div>
            <form onsubmit="handleUpdateCategory(event)">
                <input type="hidden" id="editCategoryId">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editCategoryName">Category Name</label>
                        <input type="text" class="form-control" id="editCategoryName" required maxlength="100">
                    </div>
                    <div class="form-group">
                        <label for="editCategoryDescription">Description</label>
                        <textarea class="form-control" id="editCategoryDescription" rows="3" maxlength="500"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditCategoryModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
#page-categories .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-categories .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-categories .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-categories .search-bar {
    margin-bottom: 24px;
}

#page-categories .search-input-group {
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

#page-categories .search-input-group .search-icon {
    color: var(--white-65);
}

#page-categories .search-input-group .form-control {
    flex: 1;
    background: transparent;
    border: none;
    outline: none;
    color: var(--white-90);
    font-size: 14px;
}

#page-categories .search-input-group .form-control::placeholder {
    color: var(--white-65);
}

#page-categories .categories-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

#page-categories .category-card {
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

#page-categories .category-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
    background: rgba(255, 255, 255, 0.12);
}

#page-categories .category-icon {
    width: 64px;
    height: 64px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    margin: 20px 20px 0;
}

#page-categories .category-content {
    padding: 16px 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-categories .category-name {
    font-size: 16px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-categories .category-desc {
    font-size: 13px;
    color: var(--white-65);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

#page-categories .category-meta {
    display: flex;
    gap: 16px;
    font-size: 13px;
    color: var(--white-65);
    margin-top: 8px;
}

#page-categories .category-stat {
    display: flex;
    align-items: center;
    gap: 6px;
}

#page-categories .category-actions {
    display: flex;
    gap: 8px;
    padding: 0 20px 20px;
    opacity: 0;
    transform: translateY(10px);
    transition: all 0.25s ease-out;
}

#page-categories .category-card:hover .category-actions {
    opacity: 1;
    transform: translateY(0);
}

#page-categories .action-btn {
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

#page-categories .action-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    color: white;
}

#page-categories .action-btn.danger:hover {
    background: rgba(232, 116, 116, 0.25);
    color: var(--accent-red);
}

#page-categories .btn-primary {
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

#page-categories .btn-primary:hover {
    background: var(--primary-dark);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(37, 184, 166, 0.4);
}

@media (max-width: 767px) {
    #page-categories .categories-grid {
        grid-template-columns: 1fr;
    }

    #page-categories .category-actions {
        opacity: 1;
        transform: translateY(0);
    }
}

#page-categories .modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    align-items: center;
    justify-content: center;
}

#page-categories .modal-overlay.active {
    display: flex;
}

#page-categories .modal-container {
    background: rgba(30, 30, 40, 0.98);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 16px;
    width: 480px;
    max-width: 90vw;
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.4);
}

#page-categories .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 24px 0;
}

#page-categories .modal-title {
    font-size: 18px;
    font-weight: 600;
    color: var(--white-95);
    margin: 0;
}

#page-categories .modal-close {
    background: none;
    border: none;
    color: var(--white-65);
    font-size: 24px;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 6px;
    transition: all 0.2s;
}

#page-categories .modal-close:hover {
    color: var(--white-95);
    background: rgba(255, 255, 255, 0.1);
}

#page-categories .modal-body {
    padding: 20px 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

#page-categories .modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    padding: 0 24px 20px;
}

#page-categories .form-group {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

#page-categories .form-group label {
    font-size: 13px;
    font-weight: 500;
    color: var(--white-80);
}

#page-categories .form-control {
    padding: 10px 14px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.15);
    color: var(--white-95);
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s;
}

#page-categories .form-control:focus {
    border-color: var(--primary-color);
}

#page-categories textarea.form-control {
    resize: vertical;
    min-height: 80px;
}

#page-categories .btn {
    display: inline-flex;
    align-items: center;
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    border: none;
}

#page-categories .btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: var(--white-80);
}

#page-categories .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.18);
}

#page-categories .btn-primary {
    background: var(--primary-color);
    color: white;
    box-shadow: 0 4px 12px rgba(37, 184, 166, 0.3);
}

#page-categories .btn-primary:hover {
    background: var(--primary-dark);
    box-shadow: 0 6px 16px rgba(37, 184, 166, 0.4);
}
</style>
