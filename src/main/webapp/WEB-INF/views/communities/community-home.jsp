<div id="page-community-home" class="page-content d-none">
    <div class="mb-4">
        <button class="btn btn-outline-primary" onclick="showPage('communities')">
            <i class="fas fa-arrow-left me-2"></i>Back to Communities
        </button>
    </div>

    <div id="communityHomeContent">
        <div class="community-banner p-6 mb-6">
            <div class="d-flex align-items-center">
                <div class="text-5xl mr-4" id="communityLogo">🏘️</div>
                <div>
                    <h1 class="text-white text-3xl font-bold" id="communityName">Community Name</h1>
                    <p class="text-purple-100 mt-2" id="communityDescription">Community description</p>
                </div>
            </div>
        </div>

        <div class="row mb-6" id="communityStatsRow">
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">👥</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityMembers">0</div>
                    <div class="text-sm text-gray-500">Members</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">📅</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityEvents">0</div>
                    <div class="text-sm text-gray-500">Events</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">📝</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityRegistrations">0</div>
                    <div class="text-sm text-gray-500">Registrations</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card p-4 bg-white">
                    <div class="text-3xl mb-2">🔄</div>
                    <div class="text-2xl font-bold text-gray-800" id="statCommunityUpcoming">0</div>
                    <div class="text-sm text-gray-500">Upcoming Events</div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="bg-white rounded-xl p-4 shadow-sm">
                    <div class="d-flex justify-content-between mb-4">
                        <h3 class="font-bold">Recent Events</h3>
                        <button class="btn btn-sm btn-primary" onclick="showCommunityEvents()">View All</button>
                    </div>
                    <div id="communityRecentEvents">
                        <div class="text-center text-gray-500 py-6">
                            <div class="text-3xl mb-2">📅</div>
                            <p>No events yet</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="bg-white rounded-xl p-4 shadow-sm">
                    <div class="d-flex justify-content-between mb-4">
                        <h3 class="font-bold">New Members</h3>
                        <button class="btn btn-sm btn-primary" onclick="showCommunityMembers()">View All</button>
                    </div>
                    <div id="communityNewMembers">
                        <div class="text-center text-gray-500 py-6">
                            <div class="text-3xl mb-2">👥</div>
                            <p>No members yet</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-6 bg-white rounded-xl p-4 shadow-sm">
            <div class="d-flex justify-content-between mb-4">
                <h3 class="font-bold">Quick Actions</h3>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <button class="btn btn-primary" onclick="createCommunityEvent()">
                    <i class="fas fa-calendar-plus"></i>
                    <span>Create Event</span>
                </button>
                <button class="btn btn-outline-primary" onclick="manageCommunityMembers()">
                    <i class="fas fa-users"></i>
                    <span>Manage Members</span>
                </button>
                <button class="btn btn-outline-primary" onclick="viewCommunityRegistrations()">
                    <i class="fas fa-file-alt"></i>
                    <span>View Registrations</span>
                </button>
                <button class="btn btn-outline-primary" onclick="viewCommunityDashboard()">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </button>
            </div>
        </div>
    </div>
</div>