let currentToken = '';

function setApiBase(base) {
    window.__API_BASE__ = base;
}

function getApiBase() {
    return window.__API_BASE__ || window.API_BASE || '';
}

function setToken(token) {
    currentToken = token;
}

async function fetchApi(url, options = {}) {
    const defaultOptions = {
        headers: {
            'Content-Type': 'application/json',
        }
    };
    if (currentToken) {
        defaultOptions.headers['Authorization'] = 'Bearer ' + currentToken;
    }
    
    try {
        const response = await fetch(getApiBase() + url, { ...defaultOptions, ...options });
        
        if (response.status === 401) {
            clearAuth();
            sessionStorage.setItem('redirect_url', window.location.href);
            window.location.href = 'login.jsp';
            return { code: 401, message: 'Unauthorized' };
        }
        
        return await response.json();
    } catch (error) {
        console.error('API error:', error);
        return { code: 500, message: 'Network error' };
    }
}

function clearAuth() {
    currentToken = '';
    localStorage.removeItem('eventhub_user');
    sessionStorage.removeItem('eventhub_user');
}