let currentUser = null;
let currentCommunityId = null;

const PUBLIC_PAGES = ['login', 'register'];
const PROTECTED_PAGES = ['home', 'home-new', 'events', 'registrations', 'users', 'categories', 'dashboard', 'profile', 'event-detail', 'create-event', 'create-category', 'communities', 'community-detail', 'create-community', 'community-members', 'community-home', 'community-dashboard', 'applications', 'community-approvals'];

function initAuth() {
    const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
    if (savedUser) {
        try {
            const userData = JSON.parse(savedUser);
            currentUser = {
                userId: userData.userId,
                username: userData.username,
                role: userData.role
            };
            setToken(userData.token);
            document.getElementById('currentUsername').textContent = currentUser.username;
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
    const result = await fetchApi('/home');
    if (result.code === 200) {
        const data = result.data;
        
        if (data.stats) {
            document.getElementById('statCommunities').textContent = data.stats.totalCommunities || 0;
            document.getElementById('statTotalEvents').textContent = data.stats.totalEvents || 0;
            document.getElementById('statParticipants').textContent = data.stats.totalParticipants || 0;
            document.getElementById('statPendingApps').textContent = data.stats.pendingApplications || 0;
        }
        
        loadMyCommunities();
        loadMyApplicationsForHome();
        loadHomeUpcomingEvents(data.upcomingEvents);
    }
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
        const tbody = document.querySelector('#eventsTable tbody');
        tbody.innerHTML = '';
        
        result.data.list.forEach(event => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${event.name}</td>
                <td>${formatDate(event.date)}</td>
                <td>${event.location}</td>
                <td>${event.categoryName || '-'}</td>
                <td><span class="badge ${event.status === 'UPCOMING' ? 'badge-success' : 'badge-warning'}">${event.status}</span></td>
                <td>${event.participantCount}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="viewEvent(${event.eventId})">View</button>
                    <button class="btn btn-sm btn-warning ms-2" onclick="editEvent(${event.eventId})">Edit</button>
                    <button class="btn btn-sm btn-danger ms-2" onclick="deleteEvent(${event.eventId})">Delete</button>
                </td>
            `;
            tbody.appendChild(row);
        });
        
        renderPagination(result.data, 'eventsPagination', loadEvents);
    }
}

async function viewEvent(eventId) {
    const result = await EventsAPI.getEvent(eventId);
    if (result.code === 200) {
        const event = result.data;
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
                        <button class="btn btn-primary ms-auto" onclick="registerForEvent(${event.eventId})">Register Now</button>
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
        const tbody = document.querySelector('#usersTable tbody');
        tbody.innerHTML = '';
        
        result.data.list.forEach(user => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${user.username}</td>
                <td>${user.email}</td>
                <td>${user.role}</td>
                <td><span class="badge badge-success">${user.status || 'ACTIVE'}</span></td>
                <td>
                    <button class="btn btn-sm btn-primary">View</button>
                    <button class="btn btn-sm btn-warning ms-2">Edit</button>
                    <button class="btn btn-sm btn-danger ms-2" onclick="deleteUser(${user.userId})">Delete</button>
                </td>
            `;
            tbody.appendChild(row);
        });
        
        renderPagination(result.data, 'usersPagination', loadUsers);
    }
}

async function deleteUser(userId) {
    if (!confirm('Are you sure you want to delete this user?')) return;
    
    const result = await UsersAPI.deleteUser(userId);
    if (result.code === 200) {
        alert('User deleted successfully');
        loadUsers(1);
    } else {
        alert(result.message);
    }
}

async function loadCategories() {
    const result = await CategoriesAPI.getCategories();
    if (result.code === 200) {
        const list = document.getElementById('categoriesList');
        list.innerHTML = '';
        
        const icons = ['💻', '⚽', '🎭', '🎨', '📚', '🎵', '🍔', '👥'];
        
        result.data.forEach((cat, index) => {
            const col = document.createElement('div');
            col.className = 'col-md-3 mb-4';
            col.innerHTML = `
                <div class="bg-white rounded-xl p-4 shadow-sm">
                    <div class="text-4xl mb-3">${icons[index % icons.length]}</div>
                    <h5 class="font-bold">${cat.name}</h5>
                    <p class="text-sm text-gray-500">${cat.description}</p>
                    <div class="text-sm text-gray-500 mt-2">${cat.eventCount} events</div>
                    <div class="d-flex gap-2 mt-3">
                        <button class="btn btn-sm btn-warning">Edit</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteCategory(${cat.categoryId})">Delete</button>
                    </div>
                </div>
            `;
            list.appendChild(col);
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
        document.getElementById('dbTotalRegistrations').textContent = statsResult.data.totalRegistrations;
        document.getElementById('dbTotalEvents').textContent = statsResult.data.totalEvents;
        document.getElementById('dbTotalUsers').textContent = statsResult.data.totalUsers;
    }
    
    const activities = document.getElementById('recentActivities');
    activities.innerHTML = `
        <div class="flex items-center p-3 bg-gray-50 rounded-lg">
            <span class="text-xl mr-3">📝</span>
            <div class="flex-1">
                <p class="text-sm">User 'john_smith' registered for 'Tech Workshop'</p>
                <p class="text-xs text-gray-500">5 minutes ago</p>
            </div>
        </div>
        <div class="flex items-center p-3 bg-gray-50 rounded-lg">
            <span class="text-xl mr-3">➕</span>
            <div class="flex-1">
                <p class="text-sm">New event 'Art Exhibition' created by admin</p>
                <p class="text-xs text-gray-500">15 minutes ago</p>
            </div>
        </div>
        <div class="flex items-center p-3 bg-gray-50 rounded-lg">
            <span class="text-xl mr-3">👤</span>
            <div class="flex-1">
                <p class="text-sm">New user 'jane_doe' registered</p>
                <p class="text-xs text-gray-500">30 minutes ago</p>
            </div>
        </div>
    `;
}

async function loadRegistrations() {
    if (!currentUser) return;
    
    const result = await RegistrationsAPI.getRegistrationsByUser(currentUser.userId);
    if (result.code === 200) {
        const tbody = document.querySelector('#registrationsTable tbody');
        tbody.innerHTML = '';
        
        result.data.forEach(reg => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${reg.eventName}</td>
                <td>${currentUser.username}</td>
                <td>-</td>
                <td>${formatDate(reg.registerTime)}</td>
                <td><button class="btn btn-sm btn-danger" onclick="cancelRegistration(${reg.registrationId})">Cancel</button></td>
            `;
            tbody.appendChild(row);
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
    }
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
            container.innerHTML = '<div class="text-center text-gray-500 py-8"><div class="text-4xl mb-3">📋</div><p>No join applications</p></div>';
            return;
        }
        
        container.innerHTML = '';
        result.data.list.forEach(app => {
            const div = document.createElement('div');
            div.className = 'p-3 bg-gray-50 rounded-lg mb-2';
            div.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <p class="font-medium">${app.communityName}</p>
                        <p class="text-sm text-gray-500">Applied: ${formatDate(app.applyTime)}</p>
                    </div>
                    <span class="badge ${app.status === 'PENDING' ? 'badge-warning' : app.status === 'APPROVED' ? 'badge-success' : 'badge-danger'}">${app.status}</span>
                </div>
            `;
            container.appendChild(div);
        });
    }
}

async function loadCreateApplications() {
    const result = await CommunityApplicationsAPI.getUserCommunityApplications(currentUser.userId);
    if (result.code === 200) {
        const container = document.getElementById('createApplicationsList');
        
        if (result.data.length === 0) {
            container.innerHTML = '<div class="text-center text-gray-500 py-8"><div class="text-4xl mb-3">📝</div><p>No creation applications</p></div>';
            return;
        }
        
        container.innerHTML = '';
        result.data.forEach(app => {
            const div = document.createElement('div');
            div.className = 'p-3 bg-gray-50 rounded-lg mb-2';
            div.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <p class="font-medium">${app.name}</p>
                        <p class="text-sm text-gray-500">Applied: ${formatDate(app.applyTime)}</p>
                    </div>
                    <span class="badge ${app.status === 'PENDING' ? 'badge-warning' : app.status === 'APPROVED' ? 'badge-success' : 'badge-danger'}">${app.status}</span>
                </div>
            `;
            container.appendChild(div);
        });
    }
}

async function loadAdminApplications(status = 'PENDING', page = 1) {
    const communityId = currentCommunityId || 1;
    const result = await CommunityApplicationsAPI.getCommunityApplications(communityId, page, 10, status);
    if (result.code === 200) {
        const tbody = document.getElementById('adminApplicationsTableBody');
        tbody.innerHTML = '';
        
        if (!result.data.list || result.data.list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-gray-500">No applications</td></tr>';
            return;
        }
        
        result.data.list.forEach(app => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${app.communityName || '-'}</td>
                <td>${app.username || '-'}</td>
                <td>${formatDate(app.applyTime) || '-'}</td>
                <td><span class="badge ${app.status === 'PENDING' ? 'badge-warning' : app.status === 'APPROVED' ? 'badge-success' : 'badge-danger'}">${app.status}</span></td>
                <td>
                    ${app.status === 'PENDING' ? `
                    <button class="btn btn-sm btn-success" onclick="approveCommunityApplication(${app.applicationId}, 'APPROVED')">Approve</button>
                    <button class="btn btn-sm btn-danger ms-2" onclick="showRejectModal(${app.applicationId})">Reject</button>
                    ` : ''}
                </td>
            `;
            tbody.appendChild(row);
        });
        
        renderPagination(result.data, 'adminApplicationsPagination', (p) => loadAdminApplications(status, p));
    }
}

async function loadCommunityCreationApplications(status = 'PENDING', page = 1) {
    const result = await CommunityApplicationsAPI.getAllCommunityApplications(page, 10, status);
    console.log('Community creation applications response:', result);
    if (result.code === 200) {
        console.log('Data list:', result.data?.list);
        const tbody = document.getElementById('communityCreationApplicationsTableBody');
        tbody.innerHTML = '';
        
        result.data.list.forEach(app => {
            console.log('App item:', app);
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${app.name || '-'}</td>
                <td>${app.description || '-'}</td>
                <td>${app.applicantName || '-'}</td>
                <td>${formatDate(app.applyTime) || '-'}</td>
                <td><span class="badge ${app.status === 'PENDING' ? 'badge-warning' : app.status === 'APPROVED' ? 'badge-success' : 'badge-danger'}">${app.status}</span></td>
                <td>
                    ${app.status === 'PENDING' ? `
                    <button class="btn btn-sm btn-success" onclick="approveCreateCommunityApplication(${app.applicationId}, 'APPROVED')">Approve</button>
                    <button class="btn btn-sm btn-danger ms-2" onclick="showRejectCreateModal(${app.applicationId})">Reject</button>
                    ` : ''}
                </td>
            `;
            tbody.appendChild(row);
        });
        
        renderPagination(result.data, 'communityCreationApplicationsPagination', (p) => loadCommunityCreationApplications(status, p));
    }
}

function selectApprovalTab(status) {
    const tabs = document.querySelectorAll('#approvalTabs .btn');
    tabs.forEach(tab => {
        tab.classList.remove('btn-primary', 'active');
        tab.classList.add('btn-outline-primary');
    });
    
    event.target.classList.remove('btn-outline-primary');
    event.target.classList.add('btn-primary', 'active');
    
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
    const result = await CommunitiesAPI.getCommunities(page, 12, keyword);
    if (result.code === 200) {
        const list = document.getElementById('communitiesList');
        list.innerHTML = '';

        const colors = [
            'linear-gradient(135deg, #673ab7, #9575cd)',
            'linear-gradient(135deg, #1e88e5, #42a5f5)',
            'linear-gradient(135deg, #ff9800, #ffb74d)',
            'linear-gradient(135deg, #e91e63, #f48fb1)',
            'linear-gradient(135deg, #4caf50, #81c784)',
            'linear-gradient(135deg, #00bcd4, #4dd0e1)'
        ];

        result.data.list.forEach((community, index) => {
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
                            <span class="text-xs text-gray-500">${community.eventCount || 0} events</span>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-primary" onclick="viewCommunity(${community.communityId})">View</button>
                            <button class="btn btn-sm btn-community" onclick="applyToCommunityBtn(${community.communityId}, '${community.name}')">Apply</button>
                        </div>
                    </div>
                </div>
            `;
            list.appendChild(col);
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

document.addEventListener('DOMContentLoaded', () => {
    setApiBase(window.API_BASE);
    initAuth();
    
    const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
    if (!savedUser) {
        sessionStorage.setItem('redirect_url', window.redirectUrl);
        window.location.href = 'login.jsp';
        return;
    }
    
    const hash = window.location.hash.slice(1) || 'home';
    
    showPage(hash);
    
    document.getElementById('createEventForm')?.addEventListener('submit', handleCreateEvent);
    document.getElementById('createCategoryForm')?.addEventListener('submit', handleCreateCategory);
    document.getElementById('profileForm')?.addEventListener('submit', handleUpdateProfile);
    document.getElementById('createCommunityForm')?.addEventListener('submit', (e) => {
        e.preventDefault();
        createCommunity();
    });
});

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