const PermissionInit = (function() {
    let initialized = false;
    let initPromise = null;

    async function initialize() {
        if (initialized) {
            return true;
        }
        
        if (initPromise) {
            return initPromise;
        }
        
        initPromise = doInitialize();
        return initPromise;
    }

    async function doInitialize() {
        console.log('Initializing Permission System...');
        
        try {
            PermissionDirectives.injectStyles();
            
            ApiPermissionMiddleware.initialize();
            
            RouterGuard.initialize();
            
            PermissionDirectives.initialize();
            
            await loadUserInfo();
            
            initialized = true;
            console.log('Permission System initialized successfully');
            
            return true;
        } catch (error) {
            console.error('Failed to initialize Permission System:', error);
            return false;
        }
    }

    async function loadUserInfo() {
        const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
        
        if (!savedUser) {
            PermissionSystem.clearUser();
            if (typeof currentUser !== 'undefined') {
                currentUser = null;
            }
            return;
        }
        
        try {
            const userData = JSON.parse(savedUser);
            
            if (!userData.token) {
                handleExpiredToken();
                return;
            }
            
            const payload = parseJwt(userData.token);
            
            if (payload.exp && payload.exp * 1000 < Date.now()) {
                handleExpiredToken();
                return;
            }
            
            const user = {
                userId: userData.userId || payload.userId || payload.sub,
                username: userData.username || payload.username,
                role: userData.role || payload.role || 'USER',
                avatarUrl: userData.avatarUrl,
                email: userData.email || payload.email
            };
            
            console.log('Permission System: User loaded with role:', user.role);
            
            if (typeof currentUser !== 'undefined') {
                currentUser = user;
            }
            PermissionSystem.init(user);
            
        } catch (error) {
            console.error('Failed to parse user data:', error);
            handleExpiredToken();
        }
    }

    function parseJwt(token) {
        try {
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            
            return JSON.parse(jsonPayload);
        } catch (error) {
            throw new Error('Invalid token format');
        }
    }

    function handleExpiredToken() {
        localStorage.removeItem('eventhub_user');
        sessionStorage.removeItem('eventhub_user');
        PermissionSystem.clearUser();
        if (typeof currentUser !== 'undefined') {
            currentUser = null;
        }
    }

    function isInitialized() {
        return initialized;
    }

    function reinitialize() {
        initialized = false;
        initPromise = null;
        return initialize();
    }

    return {
        initialize,
        isInitialized,
        reinitialize,
        loadUserInfo
    };
})();

window.PermissionInit = PermissionInit;
