let currentToken = '';

function setApiBase(base) {
    window.__API_BASE__ = base;
}

function getApiBase() {
    const ctxPath = window.location.pathname.split('/')[1] || '';
    return `/${ctxPath}/api`;
}

function setToken(token) {
    currentToken = token;
}

async function fetchApi(url, options = {}) {
    const defaultOptions = {
        headers: {}
    };
    
    if (!options.body || !(options.body instanceof FormData)) {
        defaultOptions.headers['Content-Type'] = 'application/json';
    }
    
    if (currentToken) {
        defaultOptions.headers['Authorization'] = 'Bearer ' + currentToken;
    }
    
    try {
        const fullUrl = getApiBase() + url;
        console.log('Fetching API:', fullUrl);
        
        const response = await fetch(fullUrl, { ...defaultOptions, ...options });
        
        if (response.status === 401) {
            clearAuth();
            sessionStorage.setItem('redirect_url', window.location.href);
            window.location.href = 'login.jsp';
            return { code: 401, message: 'Session expired, please log in again' };
        }
        
        if (response.status === 403) {
            return { code: 403, message: 'Access denied' };
        }
        
        if (!response.ok) {
            try {
                const errorData = await response.json();
                return { code: errorData.code || response.status, message: errorData.message || 'Request failed' };
            } catch {
                return { code: response.status, message: `Request failed (${response.status})` };
            }
        }
        
        return await response.json();
    } catch (error) {
        console.error('API error:', url, error);
        return { code: 500, message: 'Network error, please try again later' };
    }
}

function showApiError(result) {
    if (result.code !== 200 && result.code !== 201) {
        alert(result.message || 'Operation failed');
    }
}

function handleApiError(result, successCallback, errorCallback) {
    if (result.code === 200 || result.code === 201) {
        if (successCallback) successCallback(result);
    } else {
        if (errorCallback) {
            errorCallback(result);
        } else {
            showApiError(result);
        }
    }
}

function clearAuth() {
    currentToken = '';
    localStorage.removeItem('eventhub_user');
    sessionStorage.removeItem('eventhub_user');
}
