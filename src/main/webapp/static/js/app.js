let currentUser = null;

const PUBLIC_PAGES = ['login', 'register'];
const PROTECTED_PAGES = ['home', 'events', 'registrations', 'users', 'categories', 'dashboard', 'profile', 'event-detail', 'create-event', 'create-category'];

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
    
    const result = await EventsAPI.createEvent({ 
        name, 
        date: formatDateTimeForApi(date), 
        location, 
        categoryId: categoryId ? parseInt(categoryId) : null, 
        description 
    });
    
    if (result.code === 201) {
        alert('Event created successfully');
        showPage('events');
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

document.addEventListener('DOMContentLoaded', () => {
    setApiBase(API_BASE);
    initAuth();
    
    const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
    if (!savedUser) {
        sessionStorage.setItem('redirect_url', redirectUrl);
        window.location.href = 'login.jsp';
        return;
    }
    
    const hash = window.location.hash.slice(1) || 'home';
    
    showPage(hash);
    
    document.getElementById('createEventForm')?.addEventListener('submit', handleCreateEvent);
    document.getElementById('createCategoryForm')?.addEventListener('submit', handleCreateCategory);
    document.getElementById('profileForm')?.addEventListener('submit', handleUpdateProfile);
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