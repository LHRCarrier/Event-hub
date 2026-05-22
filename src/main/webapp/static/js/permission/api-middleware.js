const ApiPermissionMiddleware = (function() {
    const ADMIN_API_PREFIX = '/api/admin/';
    const COMMUNITY_API_PREFIX = '/api/c/';
    
    const METHOD_PERMISSIONS = {
        'GET': 'read',
        'POST': 'create',
        'PUT': 'update',
        'DELETE': 'delete',
        'PATCH': 'update'
    };

    const API_ENDPOINT_PERMISSIONS = {
        '/api/events': {
            'POST': 'create_event',
            'PUT': 'edit_event',
            'DELETE': 'delete_event'
        },
        '/api/categories': {
            'POST': 'create_category',
            'PUT': 'edit_category',
            'DELETE': 'delete_category'
        },
        '/api/users': {
            'PUT': 'edit_user'
        }
    };

    let requestInterceptors = [];
    let responseInterceptors = [];

    function initialize() {
        interceptFetch();
    }

    function interceptFetch() {
        const originalFetch = window.fetch;
        
        window.fetch = async function(url, options = {}) {
            const requestConfig = {
                url: typeof url === 'string' ? url : url.url,
                method: options.method || 'GET',
                headers: options.headers || {},
                body: options.body
            };
            
            const permissionCheck = checkApiPermission(requestConfig);
            
            if (!permissionCheck.allowed) {
                console.warn(`API permission denied: ${requestConfig.method} ${requestConfig.url}`);
                return createForbiddenResponse(permissionCheck.message);
            }
            
            for (const interceptor of requestInterceptors) {
                try {
                    const result = await interceptor(requestConfig);
                    if (result.modified) {
                        options = { ...options, ...result.modifications };
                    }
                    if (result.cancelled) {
                        return createCancelledResponse(result.reason);
                    }
                } catch (error) {
                    console.error('Request interceptor error:', error);
                }
            }
            
            try {
                const response = await originalFetch(url, options);
                
                for (const interceptor of responseInterceptors) {
                    try {
                        await interceptor(response.clone(), requestConfig);
                    } catch (error) {
                        console.error('Response interceptor error:', error);
                    }
                }
                
                return handleResponse(response);
            } catch (error) {
                return handleNetworkError(error, requestConfig);
            }
        };
    }

    function checkApiPermission(request) {
        const { url, method } = request;
        
        if (url.startsWith(ADMIN_API_PREFIX)) {
            if (!PermissionSystem.isAdmin()) {
                return {
                    allowed: false,
                    message: '需要管理员权限'
                };
            }
        }
        
        if (url.startsWith(COMMUNITY_API_PREFIX)) {
            const match = url.match(/\/api\/c\/(\d+)/);
            if (match) {
                const communityId = parseInt(match[1]);
                
                if (method !== 'GET') {
                    if (!PermissionSystem.isCommunityAdmin(communityId)) {
                        return {
                            allowed: false,
                            message: '需要社区管理员权限'
                        };
                    }
                }
            }
        }
        
        const endpointPermission = checkEndpointPermission(url, method);
        if (endpointPermission && !PermissionSystem.hasPermission(endpointPermission)) {
            return {
                allowed: false,
                message: '您没有执行此操作的权限'
            };
        }
        
        return { allowed: true };
    }

    function checkEndpointPermission(url, method) {
        for (const [endpoint, permissions] of Object.entries(API_ENDPOINT_PERMISSIONS)) {
            if (url.startsWith(endpoint)) {
                return permissions[method] || null;
            }
        }
        return null;
    }

    function createForbiddenResponse(message) {
        return new Response(JSON.stringify({
            code: 403,
            message: message || '权限不足',
            data: null
        }), {
            status: 403,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }

    function createCancelledResponse(reason) {
        return new Response(JSON.stringify({
            code: 0,
            message: reason || '请求已取消',
            data: null
        }), {
            status: 0,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }

    async function handleResponse(response) {
        if (response.status === 401) {
            handleUnauthorized();
        } else if (response.status === 403) {
            handleForbidden(response);
        }
        
        return response;
    }

    function handleNetworkError(error, requestConfig) {
        console.error('Network error:', error);
        
        return new Response(JSON.stringify({
            code: 0,
            message: '网络错误，请检查网络连接',
            data: null
        }), {
            status: 0,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }

    function handleUnauthorized() {
        PermissionSystem.clearUser();
        if (typeof currentUser !== 'undefined') {
            currentUser = null;
        }
        
        const currentUrl = window.location.href;
        sessionStorage.setItem('redirect_url', currentUrl);
        
        showUnauthorizedToast();
        
        setTimeout(() => {
            window.location.href = 'login.jsp';
        }, 2000);
    }

    async function handleForbidden(response) {
        let message = '权限不足';
        try {
            const data = await response.clone().json();
            message = data.message || message;
        } catch (e) {
            // ignore
        }
        
        showForbiddenToast(message);
    }

    function showUnauthorizedToast() {
        const toast = document.createElement('div');
        toast.className = 'api-toast api-toast-warning';
        toast.innerHTML = `
            <i class="fas fa-exclamation-circle"></i>
            <span>登录已过期，请重新登录</span>
        `;
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #f59e0b;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 8px;
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => toast.remove(), 3000);
    }

    function showForbiddenToast(message) {
        const toast = document.createElement('div');
        toast.className = 'api-toast api-toast-error';
        toast.innerHTML = `
            <i class="fas fa-times-circle"></i>
            <span>${message}</span>
        `;
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #ef4444;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 8px;
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => toast.remove(), 3000);
    }

    function addRequestInterceptor(interceptor) {
        requestInterceptors.push(interceptor);
        return function() {
            requestInterceptors = requestInterceptors.filter(i => i !== interceptor);
        };
    }

    function addResponseInterceptor(interceptor) {
        responseInterceptors.push(interceptor);
        return function() {
            responseInterceptors = responseInterceptors.filter(i => i !== interceptor);
        };
    }

    function addAuthHeader(headers) {
        const token = localStorage.getItem('token');
        if (token) {
            headers['Authorization'] = `Bearer ${token}`;
        }
        return headers;
    }

    return {
        initialize,
        checkApiPermission,
        addRequestInterceptor,
        addResponseInterceptor,
        addAuthHeader,
        ADMIN_API_PREFIX,
        COMMUNITY_API_PREFIX
    };
})();

window.ApiPermissionMiddleware = ApiPermissionMiddleware;
