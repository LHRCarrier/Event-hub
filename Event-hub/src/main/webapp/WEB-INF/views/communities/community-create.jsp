<div id="page-create-community" class="page-content d-none">
    <div class="page-header">
        <button class="btn btn-outline-primary back-btn" onclick="showPage('communities')">
            <i class="fas fa-arrow-left me-2"></i>Back
        </button>
        <div class="page-title-section">
            <h1 class="page-title">Create Community</h1>
            <p class="page-subtitle">Create a new community for your events</p>
        </div>
        <div></div>
    </div>

    <div class="create-community-container">
        <div class="create-community-card">
            <form id="createCommunityForm" class="create-community-form">
                <div class="form-group">
                    <label class="form-label">Community Name *</label>
                    <input type="text" class="form-input" id="communityName" required placeholder="Enter community name">
                </div>

                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea class="form-input" id="communityDescription" rows="4" placeholder="Enter community description"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Logo URL (Optional)</label>
                    <input type="text" class="form-input" id="communityLogo" placeholder="Enter logo URL">
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="showPage('communities')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Community</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
#page-create-community .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-create-community .back-btn {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: rgba(255, 255, 255, 0.9);
    border-radius: 12px;
    padding: 10px 16px;
    transition: all 0.3s ease;
}

#page-create-community .back-btn:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
}

#page-create-community .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-create-community .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-create-community .create-community-container {
    display: flex;
    justify-content: center;
}

#page-create-community .create-community-card {
    width: 100%;
    max-width: 600px;
    border-radius: 28px;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border: 1px solid rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(0px);
    -webkit-backdrop-filter: blur(0px);
    box-shadow:
        0 8px 32px rgba(255, 255, 255, 0.08),
        0 0 40px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    padding: 40px;
    transition: all 0.4s ease;
    position: relative;
    overflow: hidden;
}

#page-create-community .create-community-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
    pointer-events: none;
    border-radius: 28px 28px 0 0;
}

#page-create-community .create-community-card::after {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transform: rotate(45deg);
    transition: all 0.5s ease;
    opacity: 0;
    pointer-events: none;
}

#page-create-community .create-community-card:hover::after {
    animation: shimmer 0.6s ease-out;
}

#page-create-community .create-community-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow:
        0 20px 50px rgba(255, 255, 255, 0.12),
        0 0 40px rgba(255, 255, 255, 0.06),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-create-community .create-community-form {
    display: flex;
    flex-direction: column;
    gap: 20px;
    position: relative;
    z-index: 1;
}

#page-create-community .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-create-community .form-label {
    font-size: 14px;
    font-weight: 500;
    color: var(--white-90);
}

#page-create-community .form-input {
    padding: 12px 16px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--white-95);
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, background 0.2s;
    resize: vertical;
}

#page-create-community .form-input:focus {
    border-color: rgba(255, 255, 255, 0.4);
    background: rgba(255, 255, 255, 0.08);
    box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.08);
}

#page-create-community .form-input::placeholder {
    color: var(--white-50);
}

#page-create-community .form-actions {
    display: flex;
    gap: 12px;
    margin-top: 12px;
}

#page-create-community .form-actions .btn {
    flex: 1;
    padding: 12px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
}

#page-create-community .btn-primary {
    background: rgba(255, 255, 255, 0.1) !important;
    color: rgba(255, 255, 255, 0.9) !important;
    border: 1px solid rgba(255, 255, 255, 0.15) !important;
    box-shadow:
        0 4px 16px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-create-community .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15) !important;
    transform: translateY(-2px);
    box-shadow:
        0 8px 24px rgba(255, 255, 255, 0.12),
        0 0 30px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-create-community .btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
}

#page-create-community .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
}

@media (max-width: 767px) {
    #page-create-community .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }

    #page-create-community .create-community-card {
        padding: 24px;
        margin: 0 16px;
    }

    #page-create-community .form-actions {
        flex-direction: column;
    }
}
</style>