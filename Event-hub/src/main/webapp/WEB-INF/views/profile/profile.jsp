<div id="page-profile" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Profile Settings</h1>
            <p class="page-subtitle">Manage your personal information</p>
        </div>
    </div>

    <div class="profile-container">
        <div class="profile-card">
            <div class="avatar-section">
                <div class="avatar-container">
                    <img id="avatarImage" alt="Avatar" class="avatar-img" style="display: none;">
                    <span id="avatarInitial" class="avatar-initial">U</span>
                </div>
                <input type="file" id="avatarFileInput" accept="image/jpeg,image/png" class="d-none">
                <p class="upload-hint">Click to upload</p>
                <div id="avatarUploadStatus" class="upload-status"></div>
            </div>

            <form id="profileForm" class="profile-form">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-input" id="profileUsername" readonly>
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-input" id="profileEmail">
                </div>
                <div class="form-group">
                    <label class="form-label">Phone</label>
                    <input type="text" class="form-input" id="profilePhone" placeholder="Enter phone number">
                </div>
                <div class="form-group">
                    <label class="form-label">Real Name</label>
                    <input type="text" class="form-input" id="profileRealName" placeholder="Enter real name">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="showPage('home')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="avatarPreviewModal" class="modal fade" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content glass-modal">
            <div class="modal-header">
                <h5 class="modal-title">Preview Avatar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="preview-container">
                    <img id="previewImage" src="" alt="Preview" class="preview-img">
                </div>
                <div class="preview-info">
                    <p id="previewFileName"></p>
                    <p id="previewFileSize"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirmUploadBtn">Upload Avatar</button>
            </div>
        </div>
    </div>
</div>

<style>
#page-profile .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-profile .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-profile .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-profile .profile-container {
    display: flex;
    justify-content: center;
}

#page-profile .profile-card {
    width: 100%;
    max-width: 500px;
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

#page-profile .profile-card::before {
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

#page-profile .profile-card::after {
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

#page-profile .profile-card:hover::after {
    animation: shimmer 0.6s ease-out;
}

#page-profile .profile-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow:
        0 20px 50px rgba(255, 255, 255, 0.12),
        0 0 40px rgba(255, 255, 255, 0.06),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-profile .avatar-section {
    text-align: center;
    margin-bottom: 32px;
}

#page-profile .avatar-container {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    margin: 0 auto;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.15);
    border: 4px solid rgba(255, 255, 255, 0.2);
    position: relative;
    overflow: hidden;
    box-shadow: 
        0 8px 24px rgba(255, 255, 255, 0.1),
        0 0 30px rgba(255, 255, 255, 0.05);
    transition: transform 0.3s, box-shadow 0.3s;
}

#page-profile .avatar-container:hover {
    transform: scale(1.05);
    box-shadow: 
        0 12px 35px rgba(255, 255, 255, 0.15),
        0 0 40px rgba(255, 255, 255, 0.08);
}

#page-profile .avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    position: absolute;
    top: 0;
    left: 0;
}

#page-profile .avatar-initial {
    font-size: 48px;
    font-weight: 700;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
}

#page-profile .upload-hint {
    font-size: 13px;
    color: var(--white-65);
    margin: 12px 0 4px 0;
}

#page-profile .upload-status {
    font-size: 12px;
    color: var(--primary-color);
    min-height: 18px;
}

#page-profile .profile-form {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

#page-profile .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-profile .form-label {
    font-size: 14px;
    font-weight: 500;
    color: var(--white-90);
}

#page-profile .form-input {
    padding: 12px 16px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--white-95);
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, background 0.2s;
}

#page-profile .form-input:focus {
    border-color: var(--primary-color);
    background: rgba(255, 255, 255, 0.08);
}

#page-profile .form-input::placeholder {
    color: var(--white-50);
}

#page-profile .form-input:read-only {
    opacity: 0.7;
    cursor: not-allowed;
}

#page-profile .form-actions {
    display: flex;
    gap: 12px;
    margin-top: 12px;
}

#page-profile .form-actions .btn {
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

#page-profile .btn-primary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.9);
    border: 1px solid rgba(255, 255, 255, 0.15);
    box-shadow: 
        0 4px 16px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-profile .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15);
    transform: translateY(-2px);
    box-shadow: 
        0 8px 24px rgba(255, 255, 255, 0.12),
        0 0 30px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-profile .btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
}

#page-profile .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
}

#page-profile .glass-modal {
    background: rgba(30, 41, 59, 0.95) !important;
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1);
}

#page-profile .modal-header,
#page-profile .modal-footer {
    border-color: rgba(255, 255, 255, 0.1);
}

#page-profile .modal-title {
    color: var(--white-95);
}

#page-profile .modal-body {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
}

#page-profile .preview-container {
    width: 192px;
    height: 192px;
    border-radius: 16px;
    overflow: hidden;
    border: 2px solid rgba(255, 255, 255, 0.2);
}

#page-profile .preview-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

#page-profile .preview-info {
    text-align: center;
}

#page-profile .preview-info p {
    font-size: 13px;
    color: var(--white-65);
    margin: 4px 0;
}

#page-profile .modal-footer .btn {
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    border: none;
}

#page-profile .modal-footer .btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
}

#page-profile .modal-footer .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
}

#page-profile .modal-footer .btn-primary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.9);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

#page-profile .modal-footer .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15);
}

#page-profile .btn-close {
    filter: invert(1);
}

@media (max-width: 767px) {
    #page-profile .profile-card {
        padding: 24px;
        margin: 0 16px;
    }
}
</style>
