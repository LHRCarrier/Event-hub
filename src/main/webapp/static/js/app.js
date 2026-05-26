let currentUser = null;
let currentCommunityId = null;
let charts = {};

const WALLPAPERS = {
    'linear': 'linear-gradient(to right, #1e88e5, #42a5f5)',
    'gradient2': 'linear-gradient(to right, #a855f7, #ec4899)',
    'gradient3': 'linear-gradient(to right, #14b8a6, #22d3ee)',
    'gradient4': 'linear-gradient(to right, #f97316, #ef4444)',
    'gradient5': 'linear-gradient(to right, #6366f1, #a855f7)',
    'gradient6': 'linear-gradient(to right, #22c55e, #14b8a6)'
};

const PUBLIC_PAGES = ['login', 'register'];
const PROTECTED_PAGES = ['home', 'home-new', 'events', 'registrations', 'users', 'categories', 'dashboard', 'profile', 'event-detail', 'create-event', 'create-category', 'communities', 'community-detail', 'create-community', 'community-members', 'community-home', 'community-dashboard', 'applications', 'community-approvals', 'settings'];

function initAuth() {
    const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
    if (savedUser) {
        try {
            const userData = JSON.parse(savedUser);
            currentUser = {
                userId: userData.userId,
                username: userData.username,
                role: userData.role,
                avatarUrl: userData.avatarUrl
            };
            setToken(userData.token);
            const menuUsername = document.getElementById('menuUsername');
            if (menuUsername) {
                menuUsername.textContent = currentUser.username;
            }
            updateHeaderAvatar(currentUser.avatarUrl, currentUser.username);
        } catch (e) {
            clearAuth();
        }
    }
}

function isLoggedIn() {
    return currentUser !== null;
}

function clearAuth() {
    currentUser = null;
    localStorage.removeItem('eventhub_user');
    sessionStorage.removeItem('eventhub_user');
}

function handleLogout() {
    clearAuth();
    sessionStorage.setItem('redirect_url', 'index.jsp');
    window.location.href = 'login.jsp';
}

function redirectToLogin() {
    sessionStorage.setItem('redirect_url', window.location.href);
    window.location.href = 'login.jsp';
}

function redirectToRegister() {
    sessionStorage.setItem('redirect_url', window.location.href);
    window.location.href = 'register.jsp';
}

function showPage(pageName) {
    if (!isLoggedIn() && PROTECTED_PAGES.includes(pageName)) {
        sessionStorage.setItem('redirect_url', 'index.jsp#' + pageName);
        window.location.href = 'login.jsp';
        return;
    }

    document.querySelectorAll('.modal').forEach(modalEl => {
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) {
            modal.hide();
        }
    });
    
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
        backdrop.remove();
    });
    
    document.body.classList.remove('modal-open');

    document.querySelectorAll('.page-content').forEach(el => el.classList.add('d-none'));
    document.querySelectorAll('.nav-link').forEach(el => el.classList.remove('active'));
    
    const page = document.getElementById('page-' + pageName);
    if (page) {
        page.classList.remove('d-none');
    }
    
    const navLink = document.querySelector(`[href="#${pageName}"]`);
    if (navLink) {
        navLink.classList.add('active');
    }
    
    if (window.location.hash !== '#' + pageName) {
        window.location.hash = pageName;
    }
    
    if (pageName === 'home') {
        loadHomePage();
    } else if (pageName === 'home-new') {
        loadHomeNewPage();
    } else if (pageName === 'events') {
        loadEvents(1);
    } else if (pageName === 'users') {
        loadUsers(1);
    } else if (pageName === 'categories') {
        loadCategories();
    } else if (pageName === 'dashboard') {
        loadDashboard();
    } else if (pageName === 'registrations') {
        loadRegistrations();
    } else if (pageName === 'create-event') {
        loadCategoriesForSelect();
    } else if (pageName === 'profile') {
        loadProfile();
    } else if (pageName === 'communities') {
        loadCommunities(1);
    } else if (pageName === 'community-members') {
        loadCommunityMembers(1);
    } else if (pageName === 'applications') {
        loadMyApplications();
    } else if (pageName === 'community-approvals') {
        loadCommunityCreationApplications('PENDING');
    } else if (pageName === 'settings') {
        initWallpaperSettings();
    }
}

async function loadHomePage() {
    const statsResult = await DashboardAPI.getStats();
    if (statsResult.code === 200) {
        document.getElementById('statUpcoming').textContent = statsResult.data.upcomingEvents;
        document.getElementById('statParticipants').textContent = statsResult.data.totalRegistrations;
        document.getElementById('statUsers').textContent = statsResult.data.activeUsers;
        document.getElementById('statCategories').textContent = statsResult.data.totalCategories;
    }
    
    loadUpcomingEvents();
}

async function loadHomeNewPage() {
    document.getElementById('statCommunities').textContent = '0';
    document.getElementById('statTotalEvents').textContent = '0';
    document.getElementById('statParticipants').textContent = '0';
    document.getElementById('statPendingApps').textContent = '0';
    
    loadMyCommunities();
    loadMyApplicationsForHome();
}

async function loadMyCommunities() {
    if (!currentUser) return;
    
    const result = await CommunitiesAPI.getUserCommunities(currentUser.userId);
    if (result.code === 200 && result.data.length > 0) {
        const container = document.getElementById('myCommunitiesList');
        container.innerHTML = '';
        
        const colors = [
            'linear-gradient(135deg, #673ab7, #9575cd)',
            'linear-gradient(135deg, #1e88e5, #42a5f5)',
            'linear-gradient(135deg, #ff9800, #ffb74d)',
            'linear-gradient(135deg, #e91e63, #f48fb1)'
        ];
        
        result.data.forEach((community, index) => {
            const col = document.createElement('div');
            col.className = 'col-md-3 mb-4';
            col.innerHTML = `
                <div class="community-card bg-white">
                    <div class="community-banner" style="background: ${colors[index % colors.length]};"></div>
                    <div class="p-4">
                        <h5 class="font-bold">${community.name}</h5>
                        <p class="text-sm text-gray-500 mb-2">${community.description || ''}</p>
                        <div class="d-flex items-center justify-between mb-3">
                            <span class="text-xs text-gray-500">${community.memberCount || 0} members</span>
                            <span class="badge ${community.role === 'ADMIN' ? 'badge-admin' : 'badge-member'}">${community.role}</span>
                        </div>
                        <button class="btn btn-sm btn-primary w-full" onclick="viewCommunityHome(${community.communityId})">Enter Community</button>
                    </div>
                </div>
            `;
            container.appendChild(col);
        });
    }
}

async function loadMyApplicationsForHome() {
    if (!currentUser) return;
    
    const result = await CommunityApplicationsAPI.getUserApplications(currentUser.userId);
    if (result.code === 200 && result.data.length > 0) {
        const container = document.getElementById('myApplicationsList');
        container.innerHTML = '';
        
        result.data.forEach(application => {
            const div = document.createElement('div');
            div.className = 'p-3 bg-gray-50 rounded-lg mb-2';
            div.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <p class="font-medium">${application.communityName}</p>
                        <p class="text-sm text-gray-500">${formatDate(application.applyTime)}</p>
                    </div>
                    <span class="badge ${application.status === 'PENDING' ? 'badge-warning' : application.status === 'APPROVED' ? 'badge-success' : 'badge-danger'}">${application.status}</span>
                </div>
            `;
            container.appendChild(div);
        });
    }
}

function loadHomeUpcomingEvents(events) {
    const container = document.getElementById('homeUpcomingEvents');
    container.innerHTML = '';
    
    if (!events || events.length === 0) {
        container.innerHTML = '<div class="col-md-12 text-center text-gray-500 py-8"><div class="text-4xl mb-3">📅</div><p>No upcoming events</p></div>';
        return;
    }
    
    const colors = [
        'linear-gradient(135deg, #1e88e5, #42a5f5)',
        'linear-gradient(135deg, #ff9800, #ffb74d)',
        'linear-gradient(135deg, #e91e63, #f48fb1)',
        'linear-gradient(135deg, #4caf50, #81c784)'
    ];
    
    events.forEach((event, index) => {
        const col = document.createElement('div');
        col.className = 'col-md-3 mb-4';
        col.innerHTML = `
            <div class="event-card bg-white">
                <div class="event-banner" style="background: ${colors[index % colors.length]};"></div>
                <div class="p-4">
                    <h5 class="font-bold">${event.name}</h5>
                    <p class="text-sm text-gray-500">${formatDate(event.date)}</p>
                    <p class="text-sm text-gray-500">${event.location}</p>
                    <button class="btn btn-primary w-full mt-3" onclick="viewEvent(${event.eventId})">Register</button>
                </div>
            </div>
        `;
        container.appendChild(col);
    });
}

async function loadUpcomingEvents() {
    const result = await EventsAPI.getEvents(1, 4, 'UPCOMING');
    if (result.code === 200) {
        const eventList = document.getElementById('eventList');
        eventList.innerHTML = '';
        
        result.data.list.forEach(event => {
            const card = createEventCard(event);
            eventList.appendChild(card);
        });
    }
}

function createEventCard(event) {
    const colors = [
        'linear-gradient(135deg, #1e88e5, #42a5f5)',
        'linear-gradient(135deg, #ff9800, #ffb74d)',
        'linear-gradient(135deg, #e91e63, #f48fb1)',
        'linear-gradient(135deg, #4caf50, #81c784)'
    ];
    const colorIndex = Math.floor(Math.random() * colors.length);
    
    const col = document.createElement('div');
    col.className = 'col-md-3 mb-4';
    col.innerHTML = `
        <div class="event-card bg-white">
            <div class="event-banner" style="background: ${colors[colorIndex]};"></div>
            <div class="p-4">
                <h5 class="font-bold">${event.name}</h5>
                <p class="text-sm text-gray-500">${formatDate(event.date)}</p>
                <p class="text-sm text-gray-500">${event.location}</p>
                <button class="btn btn-primary w-full mt-3" onclick="viewEvent(${event.eventId})">Register</button>
            </div>
        </div>
    `;
    return col;
}

function formatDate(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'short', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

async function loadEvents(page) {
    const result = await EventsAPI.getEvents(page, 10);
    if (result.code === 200) {
        const container = document.getElementById('eventsList');
        container.innerHTML = '';
        
        const colors = [
            'linear-gradient(135deg, #1e88e5, #42a5f5)',
            'linear-gradient(135deg, #ff9800, #ffb74d)',
            'linear-gradient(135deg, #e91e63, #f48fb1)',
            'linear-gradient(135deg, #4caf50, #81c784)'
        ];
        
        result.data.list.forEach((event, index) => {
            const card = document.createElement('div');
            card.className = 'event-card';
            card.innerHTML = `
                <div class="event-banner" style="background: ${colors[index % colors.length]};"></div>
                <div class="event-content">
                    <div class="event-header">
                        <h3 class="event-title">${event.name}</h3>
                        <span class="event-badge ${event.status === 'UPCOMING' ? 'active' : ''}">${event.status}</span>
                    </div>
                    <p class="event-description">${event.description || ''}</p>
                    <div class="event-meta">
                        <span class="event-meta-item"><i class="fas fa-calendar"></i> ${formatDate(event.date)}</span>
                        <span class="event-meta-item"><i class="fas fa-map-marker-alt"></i> ${event.location || '-'}</span>
                    </div>
                    <div class="event-footer">
                        <span class="event-participants"><i class="fas fa-users"></i> ${event.participantCount || 0} participants</span>
                        <div class="event-actions">
                            <button class="action-btn secondary" onclick="viewEvent(${event.eventId})"><i class="fas fa-eye"></i></button>
                            <button class="action-btn secondary" onclick="editEvent(${event.eventId})"><i class="fas fa-edit"></i></button>
                            <button class="action-btn danger" onclick="deleteEvent(${event.eventId})"><i class="fas fa-trash"></i></button>
                        </div>
                    </div>
                </div>
            `;
            container.appendChild(card);
        });
        
        renderPagination(result.data, 'eventsPagination', loadEvents);
    }
}

async function viewEvent(eventId) {
    const result = await EventsAPI.getEvent(eventId);
    if (result.code === 200) {
        const event = result.data;
        
        let isRegistered = false;
        if (currentUser) {
            const registerResult = await RegistrationsAPI.checkRegistration(eventId, currentUser.userId);
            if (registerResult.code === 200) {
                isRegistered = registerResult.data;
            }
        }
        
        const registerButton = isRegistered 
            ? `<button class="btn btn-success ms-auto" disabled><i class="fas fa-check-circle"></i> 已注册</button>`
            : `<button class="btn btn-primary ms-auto" onclick="registerForEvent(${event.eventId})"><i class="fas fa-calendar-plus"></i> Register Now</button>`;
        
        const detail = document.getElementById('eventDetail');
        detail.innerHTML = `
            <div class="event-banner p-6">
                <h1 class="text-white text-3xl font-bold">${event.name}</h1>
                <p class="text-blue-100 mt-2">${event.description || ''}</p>
            </div>
            <div class="p-6">
                <div class="row mb-6">
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">📅</div>
                            <div class="font-medium">${formatDate(event.date)}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">📍</div>
                            <div class="font-medium">${event.location}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">🏷️</div>
                            <div class="font-medium">${event.categoryName || '-'}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">👥</div>
                            <div class="font-medium">${event.participantCount} Participants</div>
                        </div>
                    </div>
                </div>
                <div class="d-flex gap-3">
                        <button class="btn btn-warning" onclick="editEvent(${event.eventId})">Edit Event</button>
                        <button class="btn btn-danger" onclick="deleteEvent(${event.eventId})">Delete Event</button>
                        ${registerButton}
                    </div>
            </div>
        `;
        showPage('event-detail');
    }
}

async function deleteEvent(eventId) {
    if (!confirm('Are you sure you want to delete this event?')) return;
    
    const result = await EventsAPI.deleteEvent(eventId);
    if (result.code === 200) {
        alert('Event deleted successfully');
        loadEvents(1);
        showPage('events');
    } else {
        alert(result.message);
    }
}

async function loadCategoriesForSelect() {
    const result = await CategoriesAPI.getCategories();
    if (result.code === 200) {
        const select = document.getElementById('eventCategory');
        select.innerHTML = '<option value="">Select category</option>';
        result.data.forEach(cat => {
            select.innerHTML += `<option value="${cat.categoryId}">${cat.name}</option>`;
        });
    }
}

function formatDateTimeForApi(dateStr) {
    if (!dateStr) return null;
    const date = new Date(dateStr);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
}

async function handleCreateEvent(e) {
    e.preventDefault();
    const name = document.getElementById('eventName').value;
    const date = document.getElementById('eventDate').value;
    const location = document.getElementById('eventLocation').value;
    const categoryId = document.getElementById('eventCategory').value;
    const description = document.getElementById('eventDescription').value;
    
    const communityId = sessionStorage.getItem('createEventCommunityId');
    let result;
    
    if (communityId) {
        result = await CommunitiesAPI.createCommunityEvent(communityId, { 
            name, 
            date: formatDateTimeForApi(date), 
            location, 
            categoryId: categoryId ? parseInt(categoryId) : null, 
            description 
        });
        sessionStorage.removeItem('createEventCommunityId');
    } else {
        result = await EventsAPI.createEvent({ 
            name, 
            date: formatDateTimeForApi(date), 
            location, 
            categoryId: categoryId ? parseInt(categoryId) : null, 
            description 
        });
    }
    
    if (result.code === 201) {
        alert('Event created successfully');
        if (communityId) {
            viewCommunityHome(communityId);
        } else {
            showPage('events');
        }
    } else {
        alert(result.message);
    }
}

async function loadUsers(page) {
    const result = await UsersAPI.getUsers(page, 10);
    if (result.code === 200) {
        const container = document.getElementById('usersList');
        container.innerHTML = '';
        
        const statusColors = {
            'ACTIVE': 'active',
            'DISABLED': 'inactive'
        };
        
        result.data.list.forEach(user => {
            const card = document.createElement('div');
            card.className = 'user-card';
            const userStatus = user.status || 'ACTIVE';
            const initial = (user.username || 'U').charAt(0).toUpperCase();
            card.innerHTML = `
                <div class="user-card-header">
                    <div class="user-avatar" style="background: var(--primary-color);">
                        ${user.avatarUrl ? `<img src="${user.avatarUrl}" alt="${user.username}" class="user-avatar-img">` : `<span class="user-avatar-text">${initial}</span>`}
                    </div>
                    <span class="user-role-badge ${user.role === 'ADMIN' ? 'admin' : 'member'}">${user.role}</span>
                </div>
                <div class="user-card-content">
                    <h3 class="user-name">${user.username}</h3>
                    <p class="user-email">${user.email || ''}</p>
                    <div class="user-status ${statusColors[userStatus] || 'active'}">
                        <span class="status-dot"></span>
                        ${userStatus === 'ACTIVE' ? 'Active' : 'Inactive'}
                    </div>
                </div>
                <div class="user-card-actions">
                    <button class="action-btn"><i class="fas fa-eye"></i></button>
                    ${userStatus === 'ACTIVE' ? 
                        `<button class="action-btn danger" onclick="disableUser(${user.userId})"><i class="fas fa-ban"></i></button>` :
                        `<button class="action-btn" onclick="enableUser(${user.userId})"><i class="fas fa-check"></i></button>`
                    }
                </div>
            `;
            container.appendChild(card);
        });
        
        renderPagination(result.data, 'usersPagination', loadUsers);
    }
}

async function disableUser(userId) {
    if (!confirm('Are you sure you want to disable this user?')) return;
    
    const result = await UsersAPI.disableUser(userId);
    if (result.code === 200) {
        alert('User disabled successfully');
        loadUsers(1);
    } else {
        alert(result.message);
    }
}

async function enableUser(userId) {
    if (!confirm('Are you sure you want to enable this user?')) return;
    
    const result = await UsersAPI.enableUser(userId);
    if (result.code === 200) {
        alert('User enabled successfully');
        loadUsers(1);
    } else {
        alert(result.message);
    }
}

async function loadCategories() {
    const result = await CategoriesAPI.getCategories();
    if (result.code === 200) {
        const container = document.getElementById('categoriesList');
        container.innerHTML = '';
        
        const icons = [
            { icon: 'fa-code', color: 'rgba(37, 184, 166, 0.3)' },
            { icon: 'fa-palette', color: 'rgba(139, 92, 246, 0.3)' },
            { icon: 'fa-briefcase', color: 'rgba(59, 130, 246, 0.3)' },
            { icon: 'fa-robot', color: 'rgba(245, 166, 35, 0.3)' },
            { icon: 'fa-music', color: 'rgba(232, 116, 116, 0.3)' },
            { icon: 'fa-running', color: 'rgba(126, 217, 87, 0.3)' },
            { icon: 'fa-book', color: 'rgba(107, 179, 217, 0.3)' },
            { icon: 'fa-utensils', color: 'rgba(255, 193, 7, 0.3)' }
        ];
        
        result.data.forEach((cat, index) => {
            const card = document.createElement('div');
            card.className = 'category-card';
            const iconData = icons[index % icons.length];
            card.innerHTML = `
                <div class="category-icon" style="background: ${iconData.color};">
                    <i class="fas ${iconData.icon}" style="color: var(--primary-color);"></i>
                </div>
                <div class="category-content">
                    <h3 class="category-name">${cat.name}</h3>
                    <p class="category-desc">${cat.description || ''}</p>
                    <div class="category-meta">
                        <span class="category-stat"><i class="fas fa-calendar"></i> ${cat.eventCount || 0} events</span>
                    </div>
                </div>
                <div class="category-actions">
                    <button class="action-btn secondary"><i class="fas fa-edit"></i></button>
                    <button class="action-btn danger" onclick="deleteCategory(${cat.categoryId})"><i class="fas fa-trash"></i></button>
                </div>
            `;
            container.appendChild(card);
        });
    }
}

async function deleteCategory(categoryId) {
    if (!confirm('Are you sure you want to delete this category?')) return;
    
    const result = await CategoriesAPI.deleteCategory(categoryId);
    if (result.code === 200) {
        alert('Category deleted successfully');
        loadCategories();
    } else {
        alert(result.message);
    }
}

async function handleCreateCategory(e) {
    e.preventDefault();
    const name = document.getElementById('categoryName').value;
    const description = document.getElementById('categoryDescription').value;
    
    const result = await CategoriesAPI.createCategory({ name, description });
    
    if (result.code === 201) {
        alert('Category created successfully');
        showPage('categories');
    } else {
        alert(result.message);
    }
}

async function loadDashboard() {
    const statsResult = await DashboardAPI.getStats();
    if (statsResult.code === 200) {
        const data = statsResult.data;
        document.getElementById('dbTotalRegistrations').textContent = formatNumber(data.totalRegistrations);
        document.getElementById('dbTotalEvents').textContent = formatNumber(data.totalEvents);
        document.getElementById('dbTotalUsers').textContent = formatNumber(data.totalUsers);
        
        const growthRate = calculateGrowthRate(data.totalRegistrations || 0, data.totalEvents || 0);
        document.getElementById('dbGrowthRate').textContent = '+' + growthRate + '%';
    }
    
    initDashboardCharts();
    
    const activities = document.getElementById('recentActivities');
    activities.innerHTML = `
        <div class="d-flex items-center p-3 bg-gray-50 rounded-lg">
            <div class="flex-shrink-0 w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center mr-3">
                <i class="fas fa-user-plus text-primary"></i>
            </div>
            <div class="flex-grow-1 min-w-0">
                <p class="font-medium mb-0">New user registered</p>
                <p class="text-sm text-gray-500 mb-0">John Doe joined EventHub</p>
            </div>
            <div class="flex-shrink-0 ml-3">
                <span class="text-xs text-gray-400">2 minutes ago</span>
            </div>
        </div>
        <div class="d-flex items-center p-3 bg-gray-50 rounded-lg">
            <div class="flex-shrink-0 w-10 h-10 bg-success/10 rounded-full flex items-center justify-center mr-3">
                <i class="fas fa-calendar-plus text-success"></i>
            </div>
            <div class="flex-grow-1 min-w-0">
                <p class="font-medium mb-0">New event created</p>
                <p class="text-sm text-gray-500 mb-0">Tech Conference 2024</p>
            </div>
            <div class="flex-shrink-0 ml-3">
                <span class="text-xs text-gray-400">15 minutes ago</span>
            </div>
        </div>
        <div class="d-flex items-center p-3 bg-gray-50 rounded-lg">
            <div class="flex-shrink-0 w-10 h-10 bg-info/10 rounded-full flex items-center justify-center mr-3">
                <i class="fas fa-file-check text-info"></i>
            </div>
            <div class="flex-grow-1 min-w-0">
                <p class="font-medium mb-0">Registration approved</p>
                <p class="text-sm text-gray-500 mb-0">Approved for Summer Festival</p>
            </div>
            <div class="flex-shrink-0 ml-3">
                <span class="text-xs text-gray-400">30 minutes ago</span>
            </div>
        </div>
        <div class="d-flex items-center p-3 bg-gray-50 rounded-lg">
            <div class="flex-shrink-0 w-10 h-10 bg-warning/10 rounded-full flex items-center justify-center mr-3">
                <i class="fas fa-users text-warning"></i>
            </div>
            <div class="flex-grow-1 min-w-0">
                <p class="font-medium mb-0">New community created</p>
                <p class="text-sm text-gray-500 mb-0">Photography Club</p>
            </div>
            <div class="flex-shrink-0 ml-3">
                <span class="text-xs text-gray-400">1 hour ago</span>
            </div>
        </div>
    `;
}

function formatNumber(num) {
    if (!num) return '0';
    if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'K';
    }
    return num.toString();
}

function calculateGrowthRate(registrations, events) {
    return ((registrations / Math.max(events, 1)) * 10).toFixed(1);
}

function initDashboardCharts() {
    initTrendChart();
    initCategoryChart();
    initCommunityChart();
    initStatusChart();
    
    window.addEventListener('resize', function() {
        Object.keys(charts).forEach(key => {
            charts[key]?.resize();
        });
    });
}

function initTrendChart() {
    const chartDom = document.getElementById('trendChart');
    if (!chartDom) return;
    
    if (charts['trendChart']) {
        charts['trendChart'].dispose();
    }
    
    charts['trendChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'axis',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '10%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' }
        },
        yAxis: {
            type: 'value',
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' },
            splitLine: { lineStyle: { color: '#f0f0f0' } }
        },
        series: [
            {
                name: 'Registrations',
                type: 'line',
                smooth: true,
                data: [180, 220, 150, 320, 450, 580, 620, 550, 480, 380, 320, 410],
                lineStyle: { color: '#4f46e5', width: 3 },
                itemStyle: { color: '#4f46e5' },
                areaStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: 'rgba(79, 70, 229, 0.3)' },
                        { offset: 1, color: 'rgba(79, 70, 229, 0.05)' }
                    ])
                },
                symbol: 'circle',
                symbolSize: 6
            }
        ]
    };
    
    charts['trendChart'].setOption(option);
}

function initCategoryChart() {
    const chartDom = document.getElementById('categoryChart');
    if (!chartDom) return;
    
    if (charts['categoryChart']) {
        charts['categoryChart'].dispose();
    }
    
    charts['categoryChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'item',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            formatter: '{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            bottom: '5%',
            textStyle: { color: '#666' }
        },
        series: [
            {
                name: 'Events',
                type: 'pie',
                radius: ['45%', '70%'],
                center: ['50%', '45%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 8,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 18,
                        fontWeight: 'bold'
                    }
                },
                labelLine: { show: false },
                data: [
                    { value: 55, name: 'Technology', itemStyle: { color: '#4f46e5' } },
                    { value: 38, name: 'Sports', itemStyle: { color: '#f97316' } },
                    { value: 30, name: 'Cultural', itemStyle: { color: '#ec4899' } },
                    { value: 25, name: 'Art', itemStyle: { color: '#22c55e' } },
                    { value: 18, name: 'Business', itemStyle: { color: '#06b6d4' } },
                    { value: 15, name: 'Education', itemStyle: { color: '#a855f7' } },
                    { value: 12, name: 'Music', itemStyle: { color: '#f59e0b' } },
                    { value: 8, name: 'Other', itemStyle: { color: '#6b7280' } }
                ]
            }
        ]
    };
    
    charts['categoryChart'].setOption(option);
}

function initCommunityChart() {
    const chartDom = document.getElementById('communityChart');
    if (!chartDom) return;
    
    if (charts['communityChart']) {
        charts['communityChart'].dispose();
    }
    
    charts['communityChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'axis',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            axisPointer: { type: 'shadow' }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '10%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: ['Tech Club', 'Photography', 'Music', 'Sports', 'Book Club', 'Art'],
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666', interval: 0, rotate: 15 }
        },
        yAxis: {
            type: 'value',
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' },
            splitLine: { lineStyle: { color: '#f0f0f0' } }
        },
        series: [
            {
                name: 'Active Members',
                type: 'bar',
                barWidth: '50%',
                data: [156, 89, 124, 145, 67, 78],
                itemStyle: {
                    borderRadius: [6, 6, 0, 0],
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#3b82f6' },
                        { offset: 1, color: '#1d4ed8' }
                    ])
                }
            }
        ]
    };
    
    charts['communityChart'].setOption(option);
}

function initStatusChart() {
    const chartDom = document.getElementById('statusChart');
    if (!chartDom) return;
    
    if (charts['statusChart']) {
        charts['statusChart'].dispose();
    }
    
    charts['statusChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'item',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
            {
                name: 'Status',
                type: 'pie',
                radius: '65%',
                center: ['50%', '50%'],
                label: {
                    show: true,
                    formatter: '{b}\n{c} ({d}%)',
                    fontSize: 12
                },
                labelLine: { show: true },
                data: [
                    { value: 1850, name: 'Approved', itemStyle: { color: '#22c55e' } },
                    { value: 620, name: 'Pending', itemStyle: { color: '#f59e0b' } },
                    { value: 280, name: 'Cancelled', itemStyle: { color: '#ef4444' } },
                    { value: 97, name: 'Rejected', itemStyle: { color: '#6b7280' } }
                ]
            }
        ]
    };
    
    charts['statusChart'].setOption(option);
}

async function loadRegistrations() {
    if (!currentUser) return;
    
    const result = await RegistrationsAPI.getRegistrationsByUser(currentUser.userId);
    if (result.code === 200) {
        const container = document.getElementById('registrationsList');
        container.innerHTML = '';
        
        if (!result.data || result.data.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📋</div>
                    <p class="empty-state-text">No registrations yet</p>
                </div>
            `;
            return;
        }
        
        const colors = [
            'rgba(37, 184, 166, 0.3)',
            'rgba(139, 92, 246, 0.3)',
            'rgba(59, 130, 246, 0.3)',
            'rgba(245, 166, 35, 0.3)'
        ];
        
        result.data.forEach((reg, index) => {
            const card = document.createElement('div');
            card.className = 'registration-card';
            card.innerHTML = `
                <div class="registration-icon" style="background: ${colors[index % colors.length]};">
                    <i class="fas fa-calendar-check" style="color: var(--primary-color);"></i>
                </div>
                <div class="registration-content">
                    <h3 class="registration-title">${reg.eventName || 'Event'}</h3>
                    <p class="registration-user">
                        <span class="user-avatar-small">${(currentUser.username || 'U').charAt(0).toUpperCase()}</span>
                        ${currentUser.username}
                    </p>
                    <div class="registration-meta">
                        <span class="registration-date"><i class="fas fa-clock"></i> ${formatDate(reg.registerTime)}</span>
                        <span class="registration-status confirmed">Confirmed</span>
                    </div>
                </div>
                <div class="registration-actions">
                    <button class="action-btn danger" onclick="cancelRegistration(${reg.registrationId})"><i class="fas fa-times"></i></button>
                </div>
            `;
            container.appendChild(card);
        });
    }
}

async function cancelRegistration(registrationId) {
    if (!confirm('Are you sure you want to cancel this registration?')) return;
    
    const result = await RegistrationsAPI.cancelRegistration(registrationId);
    if (result.code === 200) {
        alert('Registration cancelled');
        loadRegistrations();
    } else {
        alert(result.message);
    }
}

async function loadProfile() {
    if (!currentUser) return;
    
    const result = await UsersAPI.getUser(currentUser.userId);
    if (result.code === 200) {
        const user = result.data;
        document.getElementById('profileUsername').value = user.username;
        document.getElementById('profileEmail').value = user.email || '';
        document.getElementById('profilePhone').value = user.phone || '';
        document.getElementById('profileRealName').value = user.realName || '';
        
        loadAvatar(user.avatarUrl, user.username);
        
        if (user.avatarUrl) {
            updateHeaderAvatar(user.avatarUrl, user.username);
            if (currentUser) {
                currentUser.avatarUrl = user.avatarUrl;
                const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
                if (savedUser) {
                    const userData = JSON.parse(savedUser);
                    userData.avatarUrl = user.avatarUrl;
                    if (localStorage.getItem('eventhub_user')) {
                        localStorage.setItem('eventhub_user', JSON.stringify(userData));
                    } else {
                        sessionStorage.setItem('eventhub_user', JSON.stringify(userData));
                    }
                }
            }
        }
    }
}

function loadAvatar(avatarUrl, username) {
    const avatarImage = document.getElementById('avatarImage');
    const avatarInitial = document.getElementById('avatarInitial');
    
    if (avatarUrl && avatarUrl.trim()) {
        avatarImage.src = avatarUrl;
        avatarImage.style.display = 'block';
        avatarInitial.style.display = 'none';
    } else {
        avatarImage.style.display = 'none';
        avatarInitial.style.display = 'block';
        avatarInitial.textContent = (username || 'U').charAt(0).toUpperCase();
    }
}

function updateHeaderAvatar(avatarUrl, username) {
    const headerAvatar = document.getElementById('headerAvatar');
    const headerAvatarInitial = document.getElementById('headerAvatarInitial');
    const previewAvatarImg = document.getElementById('previewAvatarImg');
    const menuAvatar = document.getElementById('menuAvatar');
    const menuAvatarInitial = document.getElementById('menuAvatarInitial');
    if (!headerAvatar) return;
    
    const initial = (username || 'U').charAt(0).toUpperCase();
    
    if (avatarUrl && avatarUrl.trim()) {
        headerAvatar.src = avatarUrl;
        headerAvatar.style.display = 'block';
        if (headerAvatarInitial) {
            headerAvatarInitial.style.display = 'none';
        }
        if (menuAvatar) {
            menuAvatar.src = avatarUrl;
            menuAvatar.style.display = 'block';
        }
        if (menuAvatarInitial) {
            menuAvatarInitial.style.display = 'none';
        }
    } else {
        headerAvatar.style.display = 'none';
        if (headerAvatarInitial) {
            headerAvatarInitial.style.display = 'flex';
            headerAvatarInitial.textContent = initial;
        }
        if (menuAvatar) {
            menuAvatar.style.display = 'none';
        }
        if (menuAvatarInitial) {
            menuAvatarInitial.style.display = 'flex';
            menuAvatarInitial.textContent = initial;
        }
    }
    
    if (previewAvatarImg) {
        previewAvatarImg.src = avatarUrl || `https://ui-avatars.com/api/?name=${encodeURIComponent(initial)}&background=random&size=64`;
    }
}

function initUserMenu() {
    const container = document.getElementById('userMenuContainer');
    const avatarWrapper = document.getElementById('avatarWrapper');
    const menu = document.getElementById('userMenu');
    const headerAvatar = document.getElementById('headerAvatar');
    const headerAvatarInitial = document.getElementById('headerAvatarInitial');
    
    if (!container || !avatarWrapper || !menu) return;
    
    avatarWrapper.addEventListener('mouseenter', () => {
        // 隐藏小头像，显示大菜单
        if (headerAvatar) {
            headerAvatar.style.opacity = '0';
        }
        if (headerAvatarInitial) {
            headerAvatarInitial.style.opacity = '0';
        }
        
        menu.classList.remove('opacity-0', 'invisible', 'pointer-events-none');
        menu.classList.add('opacity-100', 'visible', 'pointer-events-auto');
        menu.style.transform = 'translate(0, 0) scale(1)';
    });
    
    menu.addEventListener('mouseleave', () => {
        // 隐藏大菜单，显示小头像
        menu.style.transform = 'translate(-24px, -64px) scale(0.4)';
        setTimeout(() => {
            menu.classList.remove('opacity-100', 'visible', 'pointer-events-auto');
            menu.classList.add('opacity-0', 'invisible', 'pointer-events-none');
            if (headerAvatar) {
                headerAvatar.style.opacity = '1';
            }
            if (headerAvatarInitial) {
                headerAvatarInitial.style.opacity = '1';
            }
        }, 250);
    });
    
    container.addEventListener('mouseleave', () => {
        // 隐藏大菜单，显示小头像
        menu.style.transform = 'translate(-24px, -64px) scale(0.4)';
        setTimeout(() => {
            const menuRect = menu.getBoundingClientRect();
            const containerRect = container.getBoundingClientRect();
            const mouseX = window.lastMouseX || 0;
            const mouseY = window.lastMouseY || 0;
            if (!(mouseX >= menuRect.left && mouseX <= menuRect.right && mouseY >= menuRect.top && mouseY <= menuRect.bottom)) {
                if (!(mouseX >= containerRect.left && mouseX <= containerRect.right && mouseY >= containerRect.top && mouseY <= containerRect.bottom)) {
                    menu.classList.remove('opacity-100', 'visible', 'pointer-events-auto');
                    menu.classList.add('opacity-0', 'invisible', 'pointer-events-none');
                    if (headerAvatar) {
                        headerAvatar.style.opacity = '1';
                    }
                    if (headerAvatarInitial) {
                        headerAvatarInitial.style.opacity = '1';
                    }
                }
            }
        }, 250);
    });
    
    document.addEventListener('mousemove', (e) => {
        window.lastMouseX = e.clientX;
        window.lastMouseY = e.clientY;
    });
}

function closeUserMenu() {
    const menu = document.getElementById('userMenu');
    const headerAvatar = document.getElementById('headerAvatar');
    const headerAvatarInitial = document.getElementById('headerAvatarInitial');
    if (menu) {
        menu.style.transform = 'translate(-24px, -64px) scale(0.4)';
        setTimeout(() => {
            menu.classList.remove('opacity-100', 'visible', 'pointer-events-auto');
            menu.classList.add('opacity-0', 'invisible', 'pointer-events-none');
            if (headerAvatar) {
                headerAvatar.style.opacity = '1';
            }
            if (headerAvatarInitial) {
                headerAvatarInitial.style.opacity = '1';
            }
        }, 250);
    }
}

let selectedAvatarFile = null;

function initAvatarUpload() {
    const avatarContainer = document.getElementById('avatarContainer');
    const avatarFileInput = document.getElementById('avatarFileInput');
    const confirmUploadBtn = document.getElementById('confirmUploadBtn');
    
    avatarContainer.addEventListener('click', () => {
        avatarFileInput.click();
    });
    
    avatarContainer.addEventListener('dragover', (e) => {
        e.preventDefault();
        avatarContainer.classList.add('border-dashed', 'border-2', 'border-primary');
    });
    
    avatarContainer.addEventListener('dragleave', () => {
        avatarContainer.classList.remove('border-dashed', 'border-2', 'border-primary');
    });
    
    avatarContainer.addEventListener('drop', (e) => {
        e.preventDefault();
        avatarContainer.classList.remove('border-dashed', 'border-2', 'border-primary');
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleAvatarFile(files[0]);
        }
    });
    
    avatarFileInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            handleAvatarFile(file);
        }
    });
    
    confirmUploadBtn.addEventListener('click', () => {
        uploadAvatar();
    });
}

function handleAvatarFile(file) {
    const maxSize = 2 * 1024 * 1024;
    
    if (!file.type.startsWith('image/')) {
        showAvatarStatus('Please select an image file (JPG/PNG)', 'error');
        return;
    }
    
    if (!file.type.includes('jpeg') && !file.type.includes('png')) {
        showAvatarStatus('Only JPG and PNG formats are supported', 'error');
        return;
    }
    
    if (file.size > maxSize) {
        showAvatarStatus('File size exceeds 2MB limit', 'error');
        return;
    }
    
    selectedAvatarFile = file;
    
    const reader = new FileReader();
        reader.onload = (e) => {
            document.getElementById('previewImage').src = e.target.result;
            document.getElementById('previewFileName').textContent = `File: ${file.name}`;
            document.getElementById('previewFileSize').textContent = `Size: ${formatFileSize(file.size)}`;
            
            cleanupModalBackdrops();
            
            const modalElement = document.getElementById('avatarPreviewModal');
            const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
            modal.show();
        };
        reader.readAsDataURL(file);
}

function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

function showAvatarStatus(message, type = 'info') {
    const statusElement = document.getElementById('avatarUploadStatus');
    statusElement.textContent = message;
    
    if (type === 'error') {
        statusElement.className = 'mt-2 text-sm text-red-500';
    } else if (type === 'success') {
        statusElement.className = 'mt-2 text-sm text-green-500';
    } else if (type === 'loading') {
        statusElement.className = 'mt-2 text-sm text-blue-500';
    } else {
        statusElement.className = 'mt-2 text-sm text-gray-500';
    }
    
    if (type !== 'loading') {
        setTimeout(() => {
            statusElement.textContent = '';
        }, 3000);
    }
}

async function uploadAvatar() {
    if (!selectedAvatarFile || !currentUser) return;
    
    showAvatarStatus('Uploading...', 'loading');
    const modalElement = document.getElementById('avatarPreviewModal');
    const modal = bootstrap.Modal.getInstance(modalElement);
    
    if (modal) {
        await new Promise(resolve => {
            modal.hide();
            modalElement.addEventListener('hidden.bs.modal', resolve, { once: true });
        });
    }
    
    cleanupModalBackdrops();
    
    const result = await UsersAPI.uploadAvatar(currentUser.userId, selectedAvatarFile);
    
    if (result.code === 200) {
        showAvatarStatus('Avatar uploaded successfully!', 'success');
        const newAvatarUrl = result.data.avatarUrl;
        loadAvatar(newAvatarUrl, currentUser.username);
        updateHeaderAvatar(newAvatarUrl, currentUser.username);
        
        currentUser.avatarUrl = newAvatarUrl;
        const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
        if (savedUser) {
            const userData = JSON.parse(savedUser);
            userData.avatarUrl = newAvatarUrl;
            if (localStorage.getItem('eventhub_user')) {
                localStorage.setItem('eventhub_user', JSON.stringify(userData));
            } else {
                sessionStorage.setItem('eventhub_user', JSON.stringify(userData));
            }
        }
    } else {
        showAvatarStatus(result.message || 'Upload failed', 'error');
    }
    
    selectedAvatarFile = null;
}

async function handleUpdateProfile(e) {
    e.preventDefault();
    const email = document.getElementById('profileEmail').value;
    const phone = document.getElementById('profilePhone').value;
    const realName = document.getElementById('profileRealName').value;
    
    const result = await UsersAPI.updateUser(currentUser.userId, { email, phone, realName });
    
    if (result.code === 200) {
        alert('Profile updated successfully');
        showPage('home');
    } else {
        alert(result.message);
    }
}

function searchEvents() {
    const keyword = document.getElementById('searchInput').value;
    if (!keyword.trim()) return;
    
    EventsAPI.searchEvents(keyword).then(result => {
        if (result.code === 200 && result.data.length > 0) {
            const eventList = document.getElementById('eventList');
            eventList.innerHTML = '';
            result.data.forEach(event => {
                const card = createEventCard(event);
                eventList.appendChild(card);
            });
            showPage('home');
        }
    });
}

function searchHomeCommunities() {
    const keyword = document.getElementById('homeCommunitySearchInput').value;
    loadCommunities(1, keyword);
    showPage('communities');
}

function filterHomeCommunities(category) {
    loadCommunities(1);
    showPage('communities');
}

async function registerForEvent(eventId) {
    if (!currentUser) {
        sessionStorage.setItem('redirect_url', window.location.href);
        window.location.href = 'login.jsp';
        return;
    }
    
    const result = await RegistrationsAPI.createRegistration({ eventId, userId: currentUser.userId });
    
    if (result.code === 201) {
        alert('Registration successful');
        viewEvent(eventId);
    } else {
        alert(result.message);
    }
}

function renderPagination(data, containerId, loadFunction) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';
    
    const totalPages = Math.ceil(data.total / data.size);
    const currentPage = data.page;
    
    if (currentPage > 1) {
        const li = document.createElement('li');
        li.className = 'page-item';
        const a = document.createElement('a');
        a.className = 'page-link';
        a.href = '#';
        a.textContent = 'Previous';
        a.addEventListener('click', (e) => {
            e.preventDefault();
            loadFunction(currentPage - 1);
        });
        li.appendChild(a);
        container.appendChild(li);
    }
    
    for (let i = 1; i <= totalPages; i++) {
        const li = document.createElement('li');
        li.className = 'page-item' + (i === currentPage ? ' active' : '');
        const a = document.createElement('a');
        a.className = 'page-link';
        a.href = '#';
        a.textContent = i;
        a.addEventListener('click', (e) => {
            e.preventDefault();
            loadFunction(i);
        });
        li.appendChild(a);
        container.appendChild(li);
    }
    
    if (currentPage < totalPages) {
        const li = document.createElement('li');
        li.className = 'page-item';
        const a = document.createElement('a');
        a.className = 'page-link';
        a.href = '#';
        a.textContent = 'Next';
        a.addEventListener('click', (e) => {
            e.preventDefault();
            loadFunction(currentPage + 1);
        });
        li.appendChild(a);
        container.appendChild(li);
    }
}

async function loadMyApplications() {
    if (!currentUser) return;
    
    await loadJoinApplications();
    await loadCreateApplications();
}

async function loadJoinApplications(page = 1) {
    const result = await CommunityApplicationsAPI.getUserApplications(currentUser.userId, page, 10);
    if (result.code === 200) {
        const container = document.getElementById('joinApplicationsList');
        
        if (!result.data.list || result.data.list.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📋</div>
                    <p class="empty-state-text">No join applications</p>
                </div>
            `;
            return;
        }
        
        container.innerHTML = '';
        const colors = [
            'rgba(37, 184, 166, 0.3)',
            'rgba(126, 217, 87, 0.3)',
            'rgba(59, 130, 246, 0.3)'
        ];
        
        result.data.list.forEach((app, index) => {
            const card = document.createElement('div');
            card.className = 'application-card';
            card.innerHTML = `
                <div class="application-icon" style="background: ${colors[index % colors.length]};">
                    <i class="fas fa-users" style="color: var(--primary-color);"></i>
                </div>
                <div class="application-content">
                    <h3 class="application-title">${app.communityName || 'Community'}</h3>
                    <p class="application-desc">Applying to join this community</p>
                    <div class="application-meta">
                        <span class="meta-item"><i class="fas fa-calendar"></i> ${formatDate(app.applyTime)}</span>
                        <span class="application-status ${app.status.toLowerCase()}">${app.status}</span>
                    </div>
                </div>
                ${app.status === 'PENDING' ? `
                <div class="application-actions">
                    <button class="action-btn cancel"><i class="fas fa-times"></i></button>
                </div>
                ` : ''}
            `;
            container.appendChild(card);
        });
    }
}

async function loadCreateApplications() {
    const result = await CommunityApplicationsAPI.getUserCommunityApplications(currentUser.userId);
    if (result.code === 200) {
        const container = document.getElementById('createApplicationsList');
        
        if (!result.data || result.data.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📝</div>
                    <p class="empty-state-text">No creation applications</p>
                </div>
            `;
            return;
        }
        
        container.innerHTML = '';
        const colors = [
            'rgba(139, 92, 246, 0.3)',
            'rgba(245, 166, 35, 0.3)',
            'rgba(232, 116, 116, 0.3)'
        ];
        
        result.data.forEach((app, index) => {
            const card = document.createElement('div');
            card.className = 'application-card';
            card.innerHTML = `
                <div class="application-icon" style="background: ${colors[index % colors.length]};">
                    <i class="fas fa-plus-circle" style="color: #a78bfa;"></i>
                </div>
                <div class="application-content">
                    <h3 class="application-title">${app.name || 'Community'}</h3>
                    <p class="application-desc">Creating a new community</p>
                    <div class="application-meta">
                        <span class="meta-item"><i class="fas fa-calendar"></i> ${formatDate(app.applyTime)}</span>
                        <span class="application-status ${app.status.toLowerCase()}">${app.status}</span>
                    </div>
                </div>
                ${app.status === 'PENDING' ? `
                <div class="application-actions">
                    <button class="action-btn cancel"><i class="fas fa-times"></i></button>
                </div>
                ` : ''}
            `;
            container.appendChild(card);
        });
    }
}

async function loadAdminApplications(status = 'PENDING', page = 1) {
    const communityId = currentCommunityId || 1;
    const result = await CommunityApplicationsAPI.getCommunityApplications(communityId, page, 10, status);
    if (result.code === 200) {
        const container = document.getElementById('adminApplicationsList');
        container.innerHTML = '';
        
        if (!result.data.list || result.data.list.length === 0) {
            container.innerHTML = `
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <div class="empty-state-icon">📋</div>
                    <p class="empty-state-text">No applications</p>
                </div>
            `;
            return;
        }
        
        const colors = [
            'rgba(245, 166, 35, 0.3)',
            'rgba(37, 184, 166, 0.3)',
            'rgba(126, 217, 87, 0.3)'
        ];
        
        result.data.list.forEach((app, index) => {
            const card = document.createElement('div');
            card.className = 'admin-application-card';
            card.innerHTML = `
                <div class="admin-app-header">
                    <div class="app-icon" style="background: ${colors[index % colors.length]};">
                        <i class="fas fa-building" style="color: #fbbf24;"></i>
                    </div>
                    <span class="app-status ${app.status.toLowerCase()}">${app.status}</span>
                </div>
                <div class="admin-app-content">
                    <h3 class="app-title">${app.communityName || 'Community'}</h3>
                    <p class="app-desc">${app.message || 'Application to join'}</p>
                    <div class="app-meta">
                        <span class="meta-item"><i class="fas fa-user"></i> ${app.username || 'User'}</span>
                        <span class="meta-item"><i class="fas fa-calendar"></i> ${formatDate(app.applyTime)}</span>
                    </div>
                </div>
                ${app.status === 'PENDING' ? `
                <div class="admin-app-actions">
                    <button class="action-btn approve" onclick="approveCommunityApplication(${app.applicationId}, 'APPROVED')"><i class="fas fa-check"></i> Approve</button>
                    <button class="action-btn reject" onclick="showRejectModal(${app.applicationId})"><i class="fas fa-times"></i> Reject</button>
                </div>
                ` : ''}
            `;
            container.appendChild(card);
        });
        
        renderPagination(result.data, 'adminApplicationsPagination', (p) => loadAdminApplications(status, p));
    }
}

async function loadCommunityCreationApplications(status = 'PENDING', page = 1) {
    const result = await CommunityApplicationsAPI.getAllCommunityApplications(page, 10, status);
    if (result.code === 200) {
        const container = document.getElementById('communityCreationApplicationsList');
        container.innerHTML = '';
        
        if (!result.data.list || result.data.list.length === 0) {
            container.innerHTML = `
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <div class="empty-state-icon">📋</div>
                    <p class="empty-state-text">No applications</p>
                </div>
            `;
            renderPagination(result.data, 'communityCreationApplicationsPagination', (p) => loadCommunityCreationApplications(status, p));
            return;
        }
        
        const colors = [
            'rgba(245, 166, 35, 0.3)',
            'rgba(139, 92, 246, 0.3)',
            'rgba(126, 217, 87, 0.3)',
            'rgba(232, 116, 116, 0.3)'
        ];
        const icons = ['fa-building', 'fa-music', 'fa-book', 'fa-gamepad'];
        
        result.data.list.forEach((app, index) => {
            const card = document.createElement('div');
            card.className = 'approval-card';
            card.innerHTML = `
                <div class="approval-header">
                    <div class="approval-icon" style="background: ${colors[index % colors.length]};">
                        <i class="fas ${icons[index % icons.length]}" style="color: #fbbf24;"></i>
                    </div>
                    <span class="approval-status ${app.status.toLowerCase()}">${app.status}</span>
                </div>
                <div class="approval-content">
                    <h3 class="approval-name">${app.name || 'Community'}</h3>
                    <p class="approval-desc">${app.description || 'Community creation request'}</p>
                    <div class="approval-meta">
                        <span class="meta-item"><i class="fas fa-user"></i> ${app.applicantName || 'User'}</span>
                        <span class="meta-item"><i class="fas fa-calendar"></i> ${formatDate(app.applyTime)}</span>
                    </div>
                </div>
                ${app.status === 'PENDING' ? `
                <div class="approval-actions">
                    <button class="action-btn approve" onclick="approveCreateCommunityApplication(${app.applicationId}, 'APPROVED')"><i class="fas fa-check"></i> Approve</button>
                    <button class="action-btn reject" onclick="showRejectCreateModal(${app.applicationId})"><i class="fas fa-times"></i> Reject</button>
                </div>
                ` : `
                <div class="approval-actions">
                    <button class="action-btn secondary"><i class="fas fa-eye"></i> View</button>
                </div>
                `}
            `;
            container.appendChild(card);
        });
        
        renderPagination(result.data, 'communityCreationApplicationsPagination', (p) => loadCommunityCreationApplications(status, p));
    }
}

function selectApprovalTab(status) {
    const tabs = document.querySelectorAll('#approvalTabs .tab-btn');
    tabs.forEach(tab => tab.classList.remove('active'));
    
    const activeTab = Array.from(tabs).find(tab => 
        tab.textContent.trim().toUpperCase() === status
    );
    if (activeTab) {
        activeTab.classList.add('active');
    }
    
    loadCommunityCreationApplications(status);
}

async function approveCommunityApplication(applicationId, status) {
    const result = await CommunityApplicationsAPI.approveCommunityApplication(applicationId, { status });
    if (result.code === 200) {
        alert('Application approved successfully');
        loadAdminApplications('PENDING');
    } else {
        alert(result.message);
    }
}

function showRejectModal(applicationId) {
    const reason = prompt('Enter rejection reason:');
    if (reason !== null) {
        rejectCommunityApplication(applicationId, reason);
    }
}

async function rejectCommunityApplication(applicationId, reason) {
    const result = await CommunityApplicationsAPI.approveCommunityApplication(applicationId, { status: 'REJECTED', rejectReason: reason });
    if (result.code === 200) {
        alert('Application rejected');
        loadAdminApplications('PENDING');
    } else {
        alert(result.message);
    }
}

async function approveCreateCommunityApplication(applicationId, status) {
    const result = await CommunityApplicationsAPI.approveCommunityApplication(applicationId, { status });
    if (result.code === 200) {
        alert('Community creation approved successfully');
        loadCommunityCreationApplications('PENDING');
    } else {
        alert(result.message);
    }
}

function showRejectCreateModal(applicationId) {
    const reason = prompt('Enter rejection reason:');
    if (reason !== null) {
        rejectCreateCommunityApplication(applicationId, reason);
    }
}

async function rejectCreateCommunityApplication(applicationId, reason) {
    const result = await CommunityApplicationsAPI.approveCommunityApplication(applicationId, { status: 'REJECTED', rejectReason: reason });
    if (result.code === 200) {
        alert('Community creation rejected');
        loadCommunityCreationApplications('PENDING');
    } else {
        alert(result.message);
    }
}

async function viewCommunityHome(communityId) {
    currentCommunityId = communityId;
    const result = await CommunitiesAPI.getCommunityHome(communityId);
    if (result.code === 200) {
        const data = result.data;
        const community = data.community;
        
        document.getElementById('communityName').textContent = community.name;
        document.getElementById('communityDescription').textContent = community.description || '';
        
        if (data.stats) {
            document.getElementById('statCommunityMembers').textContent = data.stats.totalMembers || 0;
            document.getElementById('statCommunityEvents').textContent = data.stats.totalEvents || 0;
            document.getElementById('statCommunityRegistrations').textContent = data.stats.totalRegistrations || 0;
            document.getElementById('statCommunityUpcoming').textContent = data.stats.upcomingEvents || 0;
        }
        
        if (data.recentEvents && data.recentEvents.length > 0) {
            const container = document.getElementById('communityRecentEvents');
            container.innerHTML = '';
            data.recentEvents.forEach(event => {
                const div = document.createElement('div');
                div.className = 'p-3 bg-gray-50 rounded-lg mb-2';
                div.innerHTML = `<h5 class="font-medium">${event.name}</h5><p class="text-sm text-gray-500">${formatDate(event.date)}</p>`;
                container.appendChild(div);
            });
        }
        
        if (data.recentMembers && data.recentMembers.length > 0) {
            const container = document.getElementById('communityNewMembers');
            container.innerHTML = '';
            data.recentMembers.forEach(member => {
                const div = document.createElement('div');
                div.className = 'flex items-center p-2';
                div.innerHTML = `
                    <div class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center text-white text-sm">${(member.username || 'U').charAt(0).toUpperCase()}</div>
                    <span class="ml-2 text-sm">${member.username}</span>
                `;
                container.appendChild(div);
            });
        }
        
        showPage('community-home');
    } else if (result.code === 403) {
        alert('You need to join this community first');
    }
}

function goBackToCommunityHome() {
    if (currentCommunityId) {
        viewCommunityHome(currentCommunityId);
    } else {
        showPage('communities');
    }
}

async function viewCommunityDashboard() {
    if (!currentCommunityId) return;
    
    const [statsResult, appsResult] = await Promise.all([
        CommunitiesAPI.getCommunityDashboardStats(currentCommunityId),
        CommunityApplicationsAPI.getCommunityApplications(currentCommunityId, 1, 5, 'PENDING')
    ]);
    
    if (statsResult.code === 200) {
        const stats = statsResult.data;
        document.getElementById('dbTotalMembers').textContent = stats.totalMembers || 0;
        document.getElementById('dbTotalEvents').textContent = stats.totalEvents || 0;
        document.getElementById('dbTotalRegistrations').textContent = stats.totalRegistrations || 0;
        document.getElementById('dbUpcomingEvents').textContent = stats.upcomingEvents || 0;
        document.getElementById('dbPastEvents').textContent = stats.pastEvents || 0;
        document.getElementById('dbCurrentEvents').textContent = stats.upcomingEvents || 0;
        document.getElementById('dbFutureEvents').textContent = stats.upcomingEvents || 0;
        
        if (stats.recentRegistrations && stats.recentRegistrations.length > 0) {
            const container = document.getElementById('recentRegistrationsList');
            container.innerHTML = '';
            stats.recentRegistrations.forEach(reg => {
                const div = document.createElement('div');
                div.className = 'p-2 bg-gray-50 rounded-lg mb-2';
                div.innerHTML = `<p class="text-sm">${reg.username} registered for ${reg.eventName}</p>`;
                container.appendChild(div);
            });
        }
        
        if (appsResult.code === 200 && appsResult.data.list && appsResult.data.list.length > 0) {
            const container = document.getElementById('pendingApplicationsList');
            container.innerHTML = '';
            appsResult.data.list.forEach(app => {
                const div = document.createElement('div');
                div.className = 'p-2 bg-gray-50 rounded-lg mb-2';
                div.innerHTML = `<p class="text-sm"><strong>${app.username}</strong> 申请加入社区</p>
                    <p class="text-xs text-gray-500 mt-1">申请时间: ${app.applyTime}</p>`;
                container.appendChild(div);
            });
        } else {
            document.getElementById('pendingApplicationsList').innerHTML = '<p class="text-sm text-gray-500">暂无待处理申请</p>';
        }
        
        showPage('community-dashboard');
    }
}

function showCommunityEvents() {
    showPage('events');
}

function showCommunityMembers() {
    showPage('community-members');
}

function viewCommunityRegistrations() {
    showPage('registrations');
}

function createCommunityEvent() {
    if (currentCommunityId) {
        sessionStorage.setItem('createEventCommunityId', currentCommunityId);
    }
    showPage('create-event');
}

function manageCommunityMembers() {
    showPage('community-members');
}

async function loadCommunities(page, keyword = '') {
    const result = await CommunitiesAPI.getCommunities(page, 10, keyword);
    if (result.code === 200) {
        const container = document.getElementById('communitiesList');
        container.innerHTML = '';
        
        const colors = [
            'linear-gradient(135deg, #673ab7, #9575cd)',
            'linear-gradient(135deg, #1e88e5, #42a5f5)',
            'linear-gradient(135deg, #ff9800, #ffb74d)',
            'linear-gradient(135deg, #e91e63, #f48fb1)',
            'linear-gradient(135deg, #4caf50, #81c784)',
            'linear-gradient(135deg, #00bcd4, #4dd0e1)'
        ];
        
        result.data.list.forEach((community, index) => {
            const card = document.createElement('div');
            card.className = 'community-card';
            card.innerHTML = `
                <div class="community-banner" style="background: ${colors[index % colors.length]};"></div>
                <div class="community-logo">
                    <span class="community-logo-text">${(community.name || 'C').charAt(0).toUpperCase()}</span>
                </div>
                <div class="community-content">
                    <h3 class="community-name">${community.name}</h3>
                    <p class="community-desc">${community.description || ''}</p>
                    <div class="community-stats">
                        <span class="community-stat"><i class="fas fa-users"></i> ${community.memberCount || 0} members</span>
                        <span class="community-stat"><i class="fas fa-calendar"></i> ${community.eventCount || 0} events</span>
                    </div>
                </div>
                <div class="community-actions">
                    <button class="community-action-btn view" onclick="viewCommunity(${community.communityId})"><i class="fas fa-eye"></i> View</button>
                    <button class="community-action-btn join" onclick="applyToCommunityBtn(${community.communityId}, '${community.name}')"><i class="fas fa-paper-plane"></i> Apply</button>
                </div>
            `;
            container.appendChild(card);
        });
        
        renderPagination(result.data, 'communitiesPagination', loadCommunities);
    }
}

function searchCommunities() {
    const keyword = document.getElementById('communitySearchInput').value;
    loadCommunities(1, keyword);
}

async function viewCommunity(communityId) {
    currentCommunityId = communityId;
    const result = await CommunitiesAPI.getCommunity(communityId);
    if (result.code === 200) {
        const community = result.data;
        const content = document.getElementById('communityDetailContent');

        const colors = [
            'linear-gradient(135deg, #673ab7, #9575cd)',
            'linear-gradient(135deg, #1e88e5, #42a5f5)',
            'linear-gradient(135deg, #ff9800, #ffb74d)',
            'linear-gradient(135deg, #e91e63, #f48fb1)'
        ];
        const colorIndex = communityId % colors.length;

        content.innerHTML = `
            <div class="community-banner p-6" style="background: ${colors[colorIndex]};">
                <h1 class="text-white text-3xl font-bold">${community.name}</h1>
                <p class="text-purple-100 mt-2">${community.description || ''}</p>
            </div>
            <div class="p-6">
                <div class="row mb-6">
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">👥</div>
                            <div class="font-medium">${community.memberCount || 0} Members</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">📅</div>
                            <div class="font-medium">${community.eventCount || 0} Events</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">📊</div>
                            <div class="font-medium">${community.status || 'ACTIVE'}</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="text-center p-3 bg-gray-50 rounded-lg">
                            <div class="text-2xl mb-2">📅</div>
                            <div class="font-medium">${formatDate(community.createTime)}</div>
                        </div>
                    </div>
                </div>
                <div class="d-flex gap-3 mb-6">
                    <button class="btn btn-primary" onclick="showPage('create-event')">Create Event</button>
                    <button class="btn btn-warning" onclick="editCommunity(${community.communityId})">Edit Community</button>
                    <button class="btn btn-danger" onclick="leaveCommunity(${community.communityId})">Leave Community</button>
                    <button class="btn btn-community ms-auto" onclick="applyToCommunityBtn(${community.communityId}, '${community.name}')">Apply to Join</button>
                </div>
            </div>
        `;

        loadCommunityMembersPreview(communityId);
        showPage('community-detail');
    }
}

function applyToCommunityBtn(communityId, communityName) {
    const message = prompt('Enter a message for the community admin (optional):');
    applyToCommunity(communityId, { message: message || '' });
}

async function applyToCommunity(communityId, data = {}) {
    const result = await CommunityApplicationsAPI.applyToCommunity(communityId, data);
    if (result.code === 201) {
        alert('Application submitted successfully. Please wait for approval.');
    } else if (result.code === 409) {
        alert('You have already applied to this community.');
    } else {
        alert(result.message);
    }
}

async function loadCommunityMembersPreview(communityId) {
    const result = await CommunitiesAPI.getCommunityMembers(communityId, 1, 5);
    if (result.code === 200) {
        const container = document.getElementById('communityMembersPreview');
        container.innerHTML = '';

        result.data.list.forEach(member => {
            const div = document.createElement('div');
            div.className = 'flex items-center p-3 bg-gray-50 rounded-lg mb-2';
            div.innerHTML = `
                <div class="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center text-white">
                    ${(member.username || 'U').charAt(0).toUpperCase()}
                </div>
                <div class="ml-3 flex-1">
                    <p class="font-medium">${member.username}</p>
                    <p class="text-xs text-gray-500">${member.realName || ''}</p>
                </div>
                <span class="badge ${member.role === 'ADMIN' ? 'badge-admin' : 'badge-member'}">${member.role}</span>
            `;
            container.appendChild(div);
        });

        if (result.data.list.length === 0) {
            container.innerHTML = '<p class="text-gray-500">No members yet</p>';
        }
    }
}

async function loadCommunityMembers(page) {
    if (!currentCommunityId) {
        showPage('communities');
        return;
    }

    const result = await CommunitiesAPI.getCommunityMembers(currentCommunityId, page, 10);
    if (result.code === 200) {
        const tbody = document.getElementById('communityMembersTableBody');
        tbody.innerHTML = '';

        result.data.list.forEach(member => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${member.username}</td>
                <td>${member.realName || '-'}</td>
                <td>${member.email || '-'}</td>
                <td><span class="badge ${member.role === 'ADMIN' ? 'badge-admin' : 'badge-member'}">${member.role}</span></td>
                <td>${formatDate(member.joinTime)}</td>
                <td>
                    ${member.role !== 'ADMIN' ? `
                    <button class="btn btn-sm btn-warning" onclick="promoteMember(${member.memberId})">Promote</button>
                    <button class="btn btn-sm btn-danger ms-2" onclick="removeMember(${member.memberId})">Remove</button>
                    ` : ''}
                </td>
            `;
            tbody.appendChild(row);
        });

        renderPagination(result.data, 'communityMembersPagination', loadCommunityMembers);
    }
}

function goBackToCommunityDetail() {
    if (currentCommunityId) {
        viewCommunity(currentCommunityId);
    } else {
        showPage('communities');
    }
}

async function createCommunity() {
    const name = document.getElementById('communityName').value;
    const description = document.getElementById('communityDescription').value;
    const logoUrl = document.getElementById('communityLogo').value;

    const result = await CommunityApplicationsAPI.createCommunityApplication({
        name,
        description,
        logoUrl
    });

    if (result.code === 201) {
        alert('Community creation application submitted! Please wait for admin approval.');
        showPage('communities');
    } else {
        alert(result.message);
    }
}

async function joinCommunity(communityId) {
    const result = await CommunitiesAPI.joinCommunity(communityId);
    if (result.code === 201) {
        alert('Successfully joined the community!');
        viewCommunity(communityId);
    } else {
        alert(result.message);
    }
}

async function leaveCommunity(communityId) {
    if (!confirm('Are you sure you want to leave this community?')) return;

    const result = await CommunitiesAPI.leaveCommunity(communityId);
    if (result.code === 200) {
        alert('Successfully left the community');
        showPage('communities');
    } else {
        alert(result.message);
    }
}

async function removeMember(memberId) {
    if (!confirm('Are you sure you want to remove this member?')) return;

    const result = await CommunitiesAPI.removeMember(currentCommunityId, memberId);
    if (result.code === 200) {
        alert('Member removed successfully');
        loadCommunityMembers(1);
    } else {
        alert(result.message);
    }
}

async function promoteMember(memberId) {
    if (!confirm('Promote this member to admin?')) return;

    const result = await CommunitiesAPI.updateMemberRole(currentCommunityId, memberId, 'ADMIN');
    if (result.code === 200) {
        alert('Member promoted successfully');
        loadCommunityMembers(1);
    } else {
        alert(result.message);
    }
}

async function editCommunity(communityId) {
    const result = await CommunitiesAPI.getCommunity(communityId);
    if (result.code === 200) {
        const community = result.data;
        const newName = prompt('Enter new community name:', community.name);
        const newDescription = prompt('Enter new description:', community.description || '');

        if (newName !== null) {
            const updateResult = await CommunitiesAPI.updateCommunity(communityId, {
                name: newName || community.name,
                description: newDescription !== null ? newDescription : community.description
            });

            if (updateResult.code === 200) {
                alert('Community updated successfully');
                viewCommunity(communityId);
            } else {
                alert(updateResult.message);
            }
        }
    }
}

function cleanupModalBackdrops() {
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
        backdrop.remove();
    });
    document.body.classList.remove('modal-open');
}

function initBackdropCleanupObserver() {
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            mutation.addedNodes.forEach((node) => {
                if (node.nodeType === Node.ELEMENT_NODE) {
                    const el = node;
                    if (el.classList && el.classList.contains('modal-backdrop')) {
                        const modals = document.querySelectorAll('.modal.show');
                        if (modals.length === 0) {
                            el.remove();
                            document.body.classList.remove('modal-open');
                        }
                    }
                }
            });
        });
    });

    observer.observe(document.body, {
        childList: true,
        subtree: false
    });
}

document.addEventListener('DOMContentLoaded', async () => {
    cleanupModalBackdrops();
    initBackdropCleanupObserver();
    
    setApiBase(window.API_BASE);
    initAuth();
    initWallpaper();
    initUserMenu();
    
    const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
    if (!savedUser) {
        sessionStorage.setItem('redirect_url', window.redirectUrl);
        window.location.href = 'login.jsp';
        return;
    }
    
    if (typeof PermissionInit !== 'undefined') {
        await PermissionInit.initialize();
    }
    
    if (typeof RouterGuard !== 'undefined') {
        RouterGuard.updateNavigationUI();
    }
    
    const hash = window.location.hash.slice(1) || 'home';
    
    showPage(hash);
    
    document.getElementById('createEventForm')?.addEventListener('submit', handleCreateEvent);
    document.getElementById('createCategoryForm')?.addEventListener('submit', handleCreateCategory);
    document.getElementById('profileForm')?.addEventListener('submit', handleUpdateProfile);
    initAvatarUpload();
    document.getElementById('createCommunityForm')?.addEventListener('submit', (e) => {
        e.preventDefault();
        createCommunity();
    });
});

function initWallpaper() {
    const savedWallpaper = localStorage.getItem('eventhub_wallpaper') || 'linear';
    const savedWallpaperImage = localStorage.getItem('eventhub_wallpaper_image');
    
    if (savedWallpaperImage) {
        setWallpaperImage(savedWallpaperImage);
    } else {
        setWallpaper(savedWallpaper);
    }
    
    initWallpaperSettings();
}

function initWallpaperSettings() {
    const uploadArea = document.getElementById('wallpaperUploadArea');
    const fileInput = document.getElementById('wallpaperFileInput');
    const resetBtn = document.getElementById('resetWallpaperBtn');
    
    if (!uploadArea || !fileInput) {
        console.warn('Wallpaper upload elements not found');
        return;
    }
    
    uploadArea.onclick = function() {
        console.log('Upload area clicked');
        fileInput.click();
    };
    
    uploadArea.ondragover = function(e) {
        e.preventDefault();
        uploadArea.style.borderColor = '#1e88e5';
        uploadArea.style.backgroundColor = '#f0f7ff';
    };
    
    uploadArea.ondragleave = function() {
        uploadArea.style.borderColor = '#dee2e6';
        uploadArea.style.backgroundColor = '';
    };
    
    uploadArea.ondrop = function(e) {
        e.preventDefault();
        uploadArea.style.borderColor = '#dee2e6';
        uploadArea.style.backgroundColor = '';
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleWallpaperUpload(files[0]);
        }
    };
    
    fileInput.onchange = function(e) {
        const file = e.target.files?.[0];
        if (file) {
            handleWallpaperUpload(file);
        }
    };
    
    const wallpaperItems = document.querySelectorAll('.wallpaper-item');
    wallpaperItems.forEach(function(item) {
        item.onclick = function() {
            const wallpaperId = this.dataset.wallpaper;
            if (!wallpaperId) {
                console.warn('Wallpaper item missing data-wallpaper attribute');
                return;
            }
            setWallpaper(wallpaperId);
            localStorage.setItem('eventhub_wallpaper', wallpaperId);
            localStorage.removeItem('eventhub_wallpaper_image');
            updateWallpaperPreview();
        };
    });
    
    if (resetBtn) {
        resetBtn.onclick = function() {
            localStorage.removeItem('eventhub_wallpaper');
            localStorage.removeItem('eventhub_wallpaper_image');
            setWallpaper('linear');
            updateWallpaperPreview();
        };
    }
    
    updateWallpaperPreview();
}

function setWallpaper(wallpaperId) {
    const headerBanner = document.getElementById('headerBanner');
    if (!headerBanner) return;
    
    const wallpaper = WALLPAPERS[wallpaperId];
    if (wallpaper) {
        headerBanner.style.backgroundImage = 'none';
        headerBanner.style.background = wallpaper;
    }
}

function setWallpaperImage(imageDataUrl) {
    const headerBanner = document.getElementById('headerBanner');
    if (!headerBanner) return;
    
    headerBanner.style.background = `url(${imageDataUrl})`;
    headerBanner.style.backgroundSize = 'cover';
    headerBanner.style.backgroundPosition = 'center';
}

function handleWallpaperUpload(file) {
    if (!file.type.startsWith('image/')) {
        alert('Please upload an image file');
        return;
    }
    
    const reader = new FileReader();
    reader.onload = (e) => {
        const imageDataUrl = e.target.result;
        setWallpaperImage(imageDataUrl);
        localStorage.setItem('eventhub_wallpaper_image', imageDataUrl);
        localStorage.removeItem('eventhub_wallpaper');
        updateWallpaperPreview();
    };
    reader.readAsDataURL(file);
}

function updateWallpaperPreview() {
    const preview = document.getElementById('wallpaperPreview');
    const previewContainer = document.getElementById('currentWallpaperPreview');
    const resetBtn = document.getElementById('resetWallpaperBtn');
    
    if (!preview || !previewContainer) return;
    
    const savedImage = localStorage.getItem('eventhub_wallpaper_image');
    const savedWallpaper = localStorage.getItem('eventhub_wallpaper');
    
    if (savedImage) {
        preview.style.backgroundImage = `url(${savedImage})`;
        preview.style.backgroundSize = 'cover';
        preview.style.backgroundPosition = 'center';
        preview.style.background = '';
        previewContainer.style.display = 'block';
    } else if (savedWallpaper) {
        preview.style.background = WALLPAPERS[savedWallpaper] || WALLPAPERS['linear'];
        preview.style.backgroundImage = 'none';
        previewContainer.style.display = 'block';
    } else {
        previewContainer.style.display = 'none';
    }
}

window.addEventListener('hashchange', () => {
    if (!isLoggedIn()) return;
    const hash = window.location.hash.slice(1) || 'home';
    showPage(hash);
});

window.addEventListener('storage', (e) => {
    if (e.key === 'eventhub_user') {
        initAuth();
        if (!isLoggedIn()) {
            window.location.href = 'login.jsp';
        }
    }
});