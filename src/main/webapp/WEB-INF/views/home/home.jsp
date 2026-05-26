<div id="page-home" class="page-content">
    <div class="welcome-section mb-8">
        <h1 class="welcome-title">Welcome back</h1>
        <p class="welcome-subtitle">Today has 3 new events waiting for you to discover</p>
    </div>

    <div class="stats-section mb-8">
        <div class="stats-grid">
            <div class="stat-card p-4">
                <div class="stat-icon-bg mb-3" style="background: rgba(37, 184, 166, 0.3);"></div>
                <div class="stat-value" id="statUpcoming">0</div>
                <div class="stat-label">Upcoming Events</div>
            </div>
            <div class="stat-card p-4">
                <div class="stat-icon-bg mb-3" style="background: rgba(126, 217, 87, 0.3);"></div>
                <div class="stat-value" id="statParticipants">0</div>
                <div class="stat-label">Participants</div>
            </div>
            <div class="stat-card p-4">
                <div class="stat-icon-bg mb-3" style="background: rgba(59, 130, 246, 0.3);"></div>
                <div class="stat-value" id="statUsers">0</div>
                <div class="stat-label">Active Users</div>
            </div>
            <div class="stat-card p-4">
                <div class="stat-icon-bg mb-3" style="background: rgba(245, 166, 35, 0.3);"></div>
                <div class="stat-value" id="statCategories">0</div>
                <div class="stat-label">Categories</div>
            </div>
        </div>
    </div>

    <div class="mb-6">
        <div class="d-flex justify-content-between mb-4">
            <h3 class="section-title">Upcoming Events</h3>
            <a href="#events" onclick="showPage('events')" class="section-link">View All &rarr;</a>
        </div>
        <div class="row" id="eventList">
        </div>
    </div>
</div>