<div id="page-home" class="page-content">
    <h2 class="mb-4">Welcome to EventHub</h2>
    <div class="row mb-6" id="statsRow">
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">📅</div>
                <div class="text-2xl font-bold text-gray-800" id="statUpcoming">24</div>
                <div class="text-sm text-gray-500">Upcoming Events</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">👥</div>
                <div class="text-2xl font-bold text-gray-800" id="statParticipants">156</div>
                <div class="text-sm text-gray-500">Participants</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">👤</div>
                <div class="text-2xl font-bold text-gray-800" id="statUsers">89</div>
                <div class="text-sm text-gray-500">Active Users</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">🏷️</div>
                <div class="text-2xl font-bold text-gray-800" id="statCategories">8</div>
                <div class="text-sm text-gray-500">Categories</div>
            </div>
        </div>
    </div>

    <div class="mb-4 d-flex justify-content-between">
        <h3>Upcoming Events</h3>
        <a href="#events" onclick="showPage('events')" class="text-primary">View All →</a>
    </div>
    <div class="row" id="eventList">
    </div>
</div>