<div id="page-dashboard" class="page-content d-none">
    <h2 class="mb-4">Admin Dashboard</h2>
    <div class="row mb-6" id="dashboardStats">
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2"><i class="fas fa-clipboard-list text-primary"></i></div>
                <div class="text-2xl font-bold text-gray-800" id="dbTotalRegistrations">0</div>
                <div class="text-sm text-gray-500">Total Registrations</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2"><i class="fas fa-calendar-alt text-success"></i></div>
                <div class="text-2xl font-bold text-gray-800" id="dbTotalEvents">0</div>
                <div class="text-sm text-gray-500">Total Events</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2"><i class="fas fa-users text-info"></i></div>
                <div class="text-2xl font-bold text-gray-800" id="dbTotalUsers">0</div>
                <div class="text-sm text-gray-500">Total Users</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card p-4 bg-white">
                <div class="text-3xl mb-2"><i class="fas fa-chart-line text-warning"></i></div>
                <div class="text-2xl font-bold text-green-600" id="dbGrowthRate">0</div>
                <div class="text-sm text-gray-500">Growth Rate</div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Event Registrations Trend</h3>
                <div id="trendChart" style="height: 300px;"></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Events by Category</h3>
                <div id="categoryChart" style="height: 300px;"></div>
            </div>
        </div>
    </div>

    <div class="row mt-6">
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Community Activity</h3>
                <div id="communityChart" style="height: 300px;"></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Community Application Status</h3>
                <div id="statusChart" style="height: 300px;"></div>
            </div>
        </div>
    </div>

    <div class="mt-6 bg-white rounded-xl p-4 shadow-sm">
        <h3 class="font-bold mb-4">Recent Activities</h3>
        <div class="space-y-3" id="recentActivities">
        </div>
    </div>
</div>