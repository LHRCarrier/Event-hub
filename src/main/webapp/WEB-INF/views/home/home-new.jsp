<div id="page-home-new" class="page-content">
    <div class="mb-6">
        <h2 class="text-2xl font-bold">Welcome to EventHub</h2>
        <p class="text-gray-500 mt-2">Discover communities, join events, and connect with like-minded people.</p>
    </div>

    <div class="row mb-6" id="homeStatsRow">
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">🏘️</div>
                <div class="text-2xl font-bold text-gray-800" id="statCommunities">0</div>
                <div class="text-sm text-gray-500">Communities</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">📅</div>
                <div class="text-2xl font-bold text-gray-800" id="statTotalEvents">0</div>
                <div class="text-sm text-gray-500">Events</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">👥</div>
                <div class="text-2xl font-bold text-gray-800" id="statParticipants">0</div>
                <div class="text-sm text-gray-500">Participants</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2">📝</div>
                <div class="text-2xl font-bold text-gray-800" id="statPendingApps">0</div>
                <div class="text-sm text-gray-500">Pending Applications</div>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-xl p-4 shadow-sm mb-6">
        <div class="d-flex justify-content-between mb-4">
            <h3 class="font-bold">Discover Communities</h3>
            <button class="btn btn-community" onclick="showModal('create-community-application-modal')">
                <i class="fas fa-plus me-2"></i>Apply to Create Community
            </button>
        </div>
        <div class="input-group mb-4" style="max-width: 600px;">
            <input type="text" class="form-control" placeholder="Search communities..." id="homeCommunitySearchInput">
            <button class="btn btn-outline-primary" type="button" onclick="searchHomeCommunities()">
                <i class="fas fa-search"></i>
            </button>
        </div>
        <div class="flex gap-2 flex-wrap">
            <button class="btn btn-sm btn-outline-secondary" onclick="filterHomeCommunities('all')">All</button>
            <button class="btn btn-sm btn-outline-secondary" onclick="filterHomeCommunities('tech')">Technology</button>
            <button class="btn btn-sm btn-outline-secondary" onclick="filterHomeCommunities('sports')">Sports</button>
            <button class="btn btn-sm btn-outline-secondary" onclick="filterHomeCommunities('art')">Art</button>
            <button class="btn btn-sm btn-outline-secondary" onclick="filterHomeCommunities('music')">Music</button>
        </div>
    </div>

    <div class="mb-4 d-flex justify-content-between">
        <h3 class="font-bold">My Communities</h3>
        <a href="#communities" onclick="showPage('communities')" class="text-primary">View All &rarr;</a>
    </div>
    <div class="row" id="myCommunitiesList">
        <div class="col-md-12 text-center text-gray-500 py-8">
            <div class="text-4xl mb-3">🔍</div>
            <p>You haven't joined any communities yet</p>
            <p class="text-sm">Search and apply to join communities above</p>
        </div>
    </div>

    <div class="mb-4 mt-8 d-flex justify-content-between">
        <h3 class="font-bold">My Applications</h3>
        <a href="#applications" onclick="showPage('applications')" class="text-primary">Manage &rarr;</a>
    </div>
    <div class="row" id="myApplicationsList">
        <div class="col-md-12 text-center text-gray-500 py-8">
            <div class="text-4xl mb-3">📋</div>
            <p>No pending applications</p>
        </div>
    </div>

    <div class="mb-4 mt-8 d-flex justify-content-between">
        <h3 class="font-bold">Upcoming Events</h3>
        <a href="#events" onclick="showPage('events')" class="text-primary">View All &rarr;</a>
    </div>
    <div class="row" id="homeUpcomingEvents">
    </div>
</div>