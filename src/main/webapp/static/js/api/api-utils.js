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
        headers: {}
    };
    
    // 如果不是 FormData，才设置默认 Content-Type
    if (!options.body || !(options.body instanceof FormData)) {
        defaultOptions.headers['Content-Type'] = 'application/json';
    }
    
    if (currentToken) {
        defaultOptions.headers['Authorization'] = 'Bearer ' + currentToken;
    }
    
    try {
        const response = await fetch(getApiBase() + url, { ...defaultOptions, ...options });
        
        if (response.status === 401) {
            clearAuth();
            sessionStorage.setItem('redirect_url', window.location.href);
            window.location.href = 'login.jsp';
            return { code: 401, message: '登录已过期，请重新登录' };
        }
        
        if (response.status === 403) {
            return { code: 403, message: '无权限访问此资源' };
        }
        
        if (!response.ok) {
            try {
                const errorData = await response.json();
                return { code: errorData.code || response.status, message: errorData.message || '请求失败' };
            } catch {
                return { code: response.status, message: `请求失败 (${response.status})` };
            }
        }
        
        return await response.json();
    } catch (error) {
        console.error('API error:', url, error);
        return { code: 500, message: '网络错误，请稍后重试' };
    }
}

function showApiError(result) {
    if (result.code !== 200 && result.code !== 201) {
        alert(result.message || '操作失败');
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