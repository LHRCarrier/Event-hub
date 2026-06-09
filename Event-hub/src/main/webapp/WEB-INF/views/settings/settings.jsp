<div id="page-settings" class="page-content d-none">
    <div class="settings-header">
        <h2 class="settings-title">Settings</h2>
        <p class="settings-subtitle">Customize your EventHub experience</p>
    </div>
    
    <div class="settings-cards">
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="header-content">
                    <h3 class="card-title">Profile</h3>
                    <p class="card-description">Manage your personal information</p>
                </div>
            </div>
            
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label">Display Name</label>
                    <input type="text" id="profileName" class="form-input" placeholder="Enter your display name">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" id="profileEmail" class="form-input" placeholder="Enter your email" readonly>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Bio</label>
                    <textarea id="profileBio" class="form-textarea" rows="3" placeholder="Tell us about yourself"></textarea>
                </div>
            </div>
            
            <div class="card-footer">
                <button id="saveProfileBtn" class="btn-save">
                    <i class="fas fa-save"></i>
                    <span>Save Changes</span>
                </button>
            </div>
        </div>
        
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div class="header-content">
                    <h3 class="card-title">Notifications</h3>
                    <p class="card-description">Manage how you receive updates</p>
                </div>
            </div>
            
            <div class="card-body">
                <div class="notification-item">
                    <div class="notification-info">
                        <h4 class="notification-title">Event Reminders</h4>
                        <p class="notification-desc">Receive reminders for upcoming events</p>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="notifEventReminders" checked>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                
                <div class="notification-item">
                    <div class="notification-info">
                        <h4 class="notification-title">Community Updates</h4>
                        <p class="notification-desc">Get notified when new events are created</p>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="notifCommunityUpdates" checked>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                
                <div class="notification-item">
                    <div class="notification-info">
                        <h4 class="notification-title">Member Requests</h4>
                        <p class="notification-desc">Receive alerts for new member applications</p>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="notifMemberRequests">
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                
                <div class="notification-item">
                    <div class="notification-info">
                        <h4 class="notification-title">Email Notifications</h4>
                        <p class="notification-desc">Receive important updates via email</p>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="notifEmail" checked>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                
                <div class="notification-item">
                    <div class="notification-info">
                        <h4 class="notification-title">Push Notifications</h4>
                        <p class="notification-desc">Receive browser push notifications</p>
                    </div>
                    <label class="toggle-switch">
                        <input type="checkbox" id="notifPush">
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </div>
            
            <div class="card-footer">
                <button id="saveNotificationsBtn" class="btn-save">
                    <i class="fas fa-save"></i>
                    <span>Save Preferences</span>
                </button>
            </div>
        </div>
        
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon">
                    <i class="fas fa-lock"></i>
                </div>
                <div class="header-content">
                    <h3 class="card-title">Security</h3>
                    <p class="card-description">Manage your account security</p>
                </div>
            </div>
            
            <div class="card-body">
                <div class="security-item">
                    <button id="changePasswordBtn" class="security-btn">
                        <i class="fas fa-key"></i>
                        <span>Change Password</span>
                    </button>
                </div>
                
                <div class="security-item">
                    <button id="manageSessionsBtn" class="security-btn">
                        <i class="fas fa-desktop"></i>
                        <span>Manage Active Sessions</span>
                    </button>
                </div>
                
                <div class="security-item">
                    <button id="twoFactorBtn" class="security-btn">
                        <i class="fas fa-shield-alt"></i>
                        <span>Enable Two-Factor Authentication</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* ============================================
   Settings 页面样式
   ============================================ */

/* 页面头部 */
#page-settings .settings-header {
    margin-bottom: 32px;
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

#page-settings .settings-title {
    font-size: 28px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.95);
    margin: 0 0 8px 0;
    letter-spacing: -0.3px;
}

#page-settings .settings-subtitle {
    font-size: 16px;
    color: rgba(255, 255, 255, 0.65);
    margin: 0;
}

/* 卡片容器 */
#page-settings .settings-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 24px;
}

/* 设置卡片 */
#page-settings .settings-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    box-shadow:
        0 8px 32px rgba(0, 0, 0, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    overflow: hidden;
    animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    opacity: 0;
    position: relative;
}

#page-settings .settings-card:nth-child(1) { animation-delay: 0.1s; }
#page-settings .settings-card:nth-child(2) { animation-delay: 0.2s; }
#page-settings .settings-card:nth-child(3) { animation-delay: 0.3s; }

#page-settings .settings-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.08) 0%, transparent 100%);
    pointer-events: none;
}

/* 卡片头部 */
#page-settings .card-header {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    position: relative;
    z-index: 1;
}

#page-settings .header-icon {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: rgba(255, 255, 255, 0.85);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-settings .header-content {
    flex: 1;
}

#page-settings .card-title {
    font-size: 18px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.95);
    margin: 0 0 4px 0;
}

#page-settings .card-description {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.55);
    margin: 0;
}

/* 卡片内容 */
#page-settings .card-body {
    padding: 24px;
    position: relative;
    z-index: 1;
}

/* 表单组 */
#page-settings .form-group {
    margin-bottom: 20px;
}

#page-settings .form-group:last-child {
    margin-bottom: 0;
}

#page-settings .form-label {
    display: block;
    font-size: 13px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

#page-settings .form-input,
#page-settings .form-textarea {
    width: 100%;
    padding: 12px 16px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    color: rgba(255, 255, 255, 0.9);
    font-size: 14px;
    transition: all 0.3s ease;
    box-sizing: border-box;
}

#page-settings .form-input:focus,
#page-settings .form-textarea:focus {
    outline: none;
    border-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.06);
    background: rgba(255, 255, 255, 0.08);
}

#page-settings .form-input::placeholder,
#page-settings .form-textarea::placeholder {
    color: rgba(255, 255, 255, 0.4);
}

#page-settings .form-input:read-only {
    opacity: 0.6;
    cursor: not-allowed;
}

#page-settings .form-textarea {
    resize: vertical;
    min-height: 80px;
}

/* 通知项 */
#page-settings .notification-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    transition: background 0.2s ease;
}

#page-settings .notification-item:last-child {
    border-bottom: none;
}

#page-settings .notification-item:hover {
    background: rgba(255, 255, 255, 0.04);
    margin: 0 -24px;
    padding: 16px 24px;
    border-radius: 8px;
}

#page-settings .notification-info {
    flex: 1;
}

#page-settings .notification-title {
    font-size: 15px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    margin: 0 0 4px 0;
}

#page-settings .notification-desc {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.5);
    margin: 0;
}

/* 开关切换 */
#page-settings .toggle-switch {
    position: relative;
    display: inline-block;
    width: 48px;
    height: 26px;
    cursor: pointer;
}

#page-settings .toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

#page-settings .toggle-slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.1);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 26px;
}

#page-settings .toggle-slider::before {
    position: absolute;
    content: '';
    height: 20px;
    width: 20px;
    left: 3px;
    bottom: 3px;
    background: rgba(255, 255, 255, 0.7);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 50%;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

#page-settings .toggle-switch input:checked + .toggle-slider {
    background: rgba(107, 179, 217, 0.6);
}

#page-settings .toggle-switch input:checked + .toggle-slider::before {
    transform: translateX(22px);
    background: white;
}

/* 安全项 */
#page-settings .security-item {
    margin-bottom: 12px;
}

#page-settings .security-item:last-child {
    margin-bottom: 0;
}

#page-settings .security-btn {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 16px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.04);
    color: rgba(255, 255, 255, 0.85);
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    text-align: left;
    position: relative;
    overflow: hidden;
}

#page-settings .security-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.08), transparent);
    transition: left 0.5s ease;
}

#page-settings .security-btn:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.18);
    transform: translateX(4px);
}

#page-settings .security-btn:hover::before {
    left: 100%;
}

#page-settings .security-btn i {
    color: rgba(255, 255, 255, 0.6);
    width: 20px;
    text-align: center;
}

/* 卡片底部 */
#page-settings .card-footer {
    padding: 20px 24px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    justify-content: flex-end;
    position: relative;
    z-index: 1;
}

/* 保存按钮 */
#page-settings .btn-save {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    border: 1px solid rgba(107, 179, 217, 0.4);
    border-radius: 10px;
    background: rgba(107, 179, 217, 0.15);
    color: rgba(107, 179, 217, 0.95);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

#page-settings .btn-save::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
    transition: left 0.5s ease;
}

#page-settings .btn-save:hover {
    background: rgba(107, 179, 217, 0.25);
    border-color: rgba(107, 179, 217, 0.6);
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(107, 179, 217, 0.2);
}

#page-settings .btn-save:hover::before {
    left: 100%;
}

#page-settings .btn-save:active {
    transform: translateY(0);
}

/* 入场动画 */
@keyframes fadeInUp {
    0% {
        opacity: 0;
        transform: translateY(20px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 响应式设计 */
@media (max-width: 992px) {
    #page-settings .settings-cards {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    #page-settings {
        padding: 20px 16px;
    }
    
    #page-settings .settings-title {
        font-size: 24px;
    }
    
    #page-settings .card-header {
        padding: 20px;
    }
    
    #page-settings .card-body {
        padding: 20px;
    }
    
    #page-settings .card-footer {
        padding: 16px 20px;
    }
    
    #page-settings .btn-save span {
        display: none;
    }
    
    #page-settings .btn-save {
        padding: 12px;
    }
}

@media (max-width: 480px) {
    #page-settings .header-icon {
        width: 40px;
        height: 40px;
        font-size: 18px;
    }
    
    #page-settings .card-title {
        font-size: 16px;
    }
    
    #page-settings .notification-title {
        font-size: 14px;
    }
}
</style>