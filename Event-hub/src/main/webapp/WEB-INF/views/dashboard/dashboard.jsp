<div id="page-dashboard" class="page-content d-none">
    <div class="page-header">
        <div class="page-title-section">
            <h1 class="page-title">Admin Dashboard</h1>
            <p class="page-subtitle">View analytics and insights</p>
        </div>
    </div>

    <div class="stats-grid" id="dashboardStats">
        <div class="stat-card">
            <div class="stat-icon" style="background: rgba(99, 102, 241, 0.2);">
                <i class="fas fa-clipboard-list" style="color: #6366f1;"></i>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="dbTotalRegistrations">0</div>
                <div class="stat-label">Total Registrations</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: rgba(16, 185, 129, 0.2);">
                <i class="fas fa-calendar-alt" style="color: #10b981;"></i>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="dbTotalEvents">0</div>
                <div class="stat-label">Total Events</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: rgba(59, 130, 246, 0.2);">
                <i class="fas fa-users" style="color: #3b82f6;"></i>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="dbTotalUsers">0</div>
                <div class="stat-label">Total Users</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background: rgba(245, 158, 11, 0.2);">
                <i class="fas fa-chart-line" style="color: #f59e0b;"></i>
            </div>
            <div class="stat-content">
                <div class="stat-value" id="dbGrowthRate" style="color: #10b981;">+0%</div>
                <div class="stat-label">Growth Rate</div>
            </div>
        </div>
    </div>

    <div class="charts-section">
        <div class="chart-row">
            <div class="chart-card chart-full-width">
                <h3 class="chart-title">Event Registrations Trend</h3>
                <div id="trendChart" class="chart-container"></div>
            </div>
        </div>
        <div class="chart-row chart-row-split">
            <div class="chart-card">
                <h3 class="chart-title">Events by Category</h3>
                <div id="categoryChart" class="chart-container"></div>
            </div>
            <div class="chart-card">
                <h3 class="chart-title">Community Activity</h3>
                <div id="communityChart" class="chart-container"></div>
            </div>
        </div>
        <div class="chart-row chart-row-split">
            <div class="chart-card">
                <h3 class="chart-title">Community Application Status</h3>
                <div id="statusChart" class="chart-container"></div>
            </div>
        </div>
    </div>

    <div class="activity-section">
        <h3 class="section-title">Recent Activities</h3>
        <div class="activity-list" id="recentActivities">
        </div>
    </div>
</div>

<style>
#page-dashboard {
    animation: fadeIn 0.6s ease;
}

#page-dashboard .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 32px;
}

#page-dashboard .page-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0;
}

#page-dashboard .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin-top: 4px;
}

#page-dashboard .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    margin-bottom: 32px;
}

#page-dashboard .stat-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border-radius: 16px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    display: flex;
    align-items: center;
    gap: 16px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

#page-dashboard .stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 30%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.08), transparent);
    pointer-events: none;
}

#page-dashboard .stat-card:hover {
    transform: translateY(-4px) scale(1.02);
    border-color: rgba(255, 255, 255, 0.2);
    box-shadow: 
        0 12px 32px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04);
}

#page-dashboard .stat-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    flex-shrink: 0;
    position: relative;
    z-index: 1;
}

#page-dashboard .stat-content {
    flex: 1;
    position: relative;
    z-index: 1;
}

#page-dashboard .stat-value {
    font-size: 28px;
    font-weight: 700;
    color: var(--white-95);
    line-height: 1.2;
}

#page-dashboard .stat-label {
    font-size: 13px;
    color: var(--white-65);
    margin-top: 4px;
}

#page-dashboard .charts-section {
    display: flex;
    flex-direction: column;
    gap: 24px;
    margin-bottom: 32px;
}

#page-dashboard .chart-row {
    display: flex;
    gap: 24px;
}

#page-dashboard .chart-row-split {
    display: grid;
    grid-template-columns: 1fr 1fr;
}

#page-dashboard .chart-full-width {
    width: 100%;
}

#page-dashboard .chart-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border-radius: 20px;
    padding: 24px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    transition: all 0.3s ease;
    display: flex;
    flex-direction: column;
}

#page-dashboard .chart-card:hover {
    border-color: rgba(255, 255, 255, 0.2);
    box-shadow: 
        0 12px 32px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04);
    transform: translateY(-2px);
}

#page-dashboard .chart-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--white-90);
    margin: 0 0 20px 0;
}

#page-dashboard .chart-container {
    flex: 1;
    width: 100%;
    min-height: 300px;
    position: relative;
}

#page-dashboard .activity-section {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border-radius: 20px;
    padding: 24px;
    border: 1px solid rgba(255, 255, 255, 0.12);
}

#page-dashboard .section-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--white-90);
    margin: 0 0 20px 0;
}

#page-dashboard .activity-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

#page-dashboard .activity-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    background: rgba(255, 255, 255, 0.04);
    border-radius: 12px;
    transition: all 0.2s ease;
}

#page-dashboard .activity-item:hover {
    background: rgba(255, 255, 255, 0.08);
    transform: translateX(4px);
    border-left: 3px solid rgba(96, 165, 250, 0.5);
}

#page-dashboard .activity-icon {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    flex-shrink: 0;
}

#page-dashboard .activity-content {
    flex: 1;
    min-width: 0;
}

#page-dashboard .activity-text {
    font-size: 13px;
    color: var(--white-85);
    line-height: 1.4;
}

#page-dashboard .activity-time {
    font-size: 11px;
    color: var(--white-55);
    margin-top: 2px;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 767px) {
    #page-dashboard .stats-grid {
        grid-template-columns: 1fr;
    }
    
    #page-dashboard .chart-row {
        flex-direction: column;
    }
    
    #page-dashboard .chart-row-split {
        grid-template-columns: 1fr;
    }
    
    #page-dashboard .page-header {
        flex-direction: column;
        align-items: flex-start;
    }
    
    #page-dashboard .chart-container {
        min-height: 250px;
    }
}

@media (min-width: 1400px) {
    #page-dashboard .chart-container {
        min-height: 350px;
    }
}
</style>
