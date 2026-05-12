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
                <div class="text-2xl font-bold text-green-600">0</div>
                <div class="text-sm text-gray-500">Growth Rate</div>
            </div>
        </div>
    </div>



    <div class="row">
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Event Registrations Trend</h3>
                <div class="h-48 bg-gray-50 rounded-lg flex items-end justify-around p-4">
                    <div class="flex flex-col items-center">
                        <div class="w-10 bg-primary rounded-t" style="height: 100px;"></div>
                        <span class="text-xs mt-2">Jan</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="w-10 bg-primary rounded-t" style="height: 120px;"></div>
                        <span class="text-xs mt-2">Feb</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="w-10 bg-primary rounded-t" style="height: 80px;"></div>
                        <span class="text-xs mt-2">Mar</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="w-10 bg-primary rounded-t" style="height: 150px;"></div>
                        <span class="text-xs mt-2">Apr</span>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="w-10 bg-primary rounded-t" style="height: 180px;"></div>
                        <span class="text-xs mt-2">May</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <h3 class="font-bold mb-4">Events by Category</h3>
                <div class="h-48 flex items-center justify-center">
                    <div class="relative w-32 h-32">
                        <div class="absolute inset-0 rounded-full bg-primary/60" style="clip-path: polygon(50% 50%, 50% 0%, 100% 0%, 100% 100%, 0% 100%, 0% 0%, 30% 0%);"></div>
                        <div class="absolute inset-0 rounded-full bg-orange-500/60" style="clip-path: polygon(50% 50%, 30% 0%, 50% 0%);"></div>
                        <div class="absolute inset-0 rounded-full bg-pink-500/60" style="clip-path: polygon(50% 50%, 50% 0%, 70% 0%);"></div>
                        <div class="absolute inset-0 rounded-full bg-green-500/60" style="clip-path: polygon(50% 50%, 70% 0%, 100% 0%);"></div>
                        <div class="absolute inset-4 rounded-full bg-white flex items-center justify-center">
                            <span class="text-xs text-center">8<br>Categories</span>
                        </div>
                    </div>
                </div>
                <div class="mt-4 space-y-2">
                    <div class="flex items-center"><span class="w-3 h-3 bg-primary rounded mr-2"></span><span class="text-sm">Tech (35%)</span></div>
                    <div class="flex items-center"><span class="w-3 h-3 bg-orange-500 rounded mr-2"></span><span class="text-sm">Sports (25%)</span></div>
                    <div class="flex items-center"><span class="w-3 h-3 bg-pink-500 rounded mr-2"></span><span class="text-sm">Cultural (20%)</span></div>
                    <div class="flex items-center"><span class="w-3 h-3 bg-green-500 rounded mr-2"></span><span class="text-sm">Art (20%)</span></div>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-6 bg-white rounded-xl p-4 shadow-sm">
        <h3 class="font-bold mb-4">Recent Activities</h3>
        <div class="space-y-3" id="recentActivities">
        </div>
    </div>
</div>