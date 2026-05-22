const RouterGuard = (function() {
    const PUBLIC_ROUTES = ['login', 'register'];
    const DEFAULT_ROUTE = 'home';
    const FORBIDDEN_ROUTE = 'home';
    
    let navigationListeners = [];
    let lastRoute = null;

    function initialize() {
        window.addEventListener('hashchange', handleHashChange);
        
        PermissionSystem.onPermissionChange(() => {
            if (lastRoute) {
                validateAndNavigate(lastRoute, false);
            }
            updateNavigationUI();
        });
    }

    function handleHashChange() {
        const hash = window.location.hash.slice(1) || DEFAULT_ROUTE;
        navigateTo(hash);
    }

    function navigateTo(routeName, updateHash = true) {
        const validationResult = validateRoute(routeName);
        
        if (!validationResult.valid) {
            handleForbiddenAccess(routeName, validationResult.reason);
            return false;
        }
        
        lastRoute = routeName;
        
        if (updateHash && window.location.hash !== '#' + routeName) {
            window.location.hash = routeName;
        }
        
        notifyNavigation(routeName);
        return true;
    }

    function validateRoute(routeName) {
        if (PUBLIC_ROUTES.includes(routeName)) {
            return { valid: true };
        }
        
        if (!isLoggedIn()) {
            return { 
                valid: false, 
                reason: 'NOT_LOGGED_IN',
                message: '请先登录'
            };
        }
        
        if (!PermissionSystem.canAccessRoute(routeName)) {
            return { 
                valid: false, 
                reason: 'PERMISSION_DENIED',
                message: '您没有权限访问此页面'
            };
        }
        
        return { valid: true };
    }

    function validateAndNavigate(routeName, updateHash = true) {
        const result = validateRoute(routeName);
        
        if (result.valid) {
            return navigateTo(routeName, updateHash);
        } else {
            handleForbiddenAccess(routeName, result.reason);
            return false;
        }
    }

    function handleForbiddenAccess(routeName, reason) {
        console.warn(`Access denied to route: ${routeName}, reason: ${reason}`);
        
        switch (reason) {
            case 'NOT_LOGGED_IN':
                sessionStorage.setItem('redirect_url', window.location.href);
                redirectToLogin();
                break;
                
            case 'PERMISSION_DENIED':
                showPermissionDeniedMessage(routeName);
                if (window.location.hash !== '#' + FORBIDDEN_ROUTE) {
                    window.location.hash = FORBIDDEN_ROUTE;
                }
                break;
                
            default:
                window.location.hash = DEFAULT_ROUTE;
        }
    }

    function showPermissionDeniedMessage(routeName) {
        const toast = document.createElement('div');
        toast.className = 'permission-toast';
        toast.innerHTML = `
            <div class="permission-toast-content">
                <i class="fas fa-exclamation-triangle"></i>
                <span>您没有权限访问此页面</span>
            </div>
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
            animation: slideIn 0.3s ease-out;
        `;
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    function redirectToLogin() {
        window.location.href = 'login.jsp';
    }

    function isLoggedIn() {
        if (typeof PermissionSystem !== 'undefined') {
            return PermissionSystem.getRole() !== 'GUEST';
        }
        const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
        return savedUser !== null;
    }

    function onNavigation(callback) {
        navigationListeners.push(callback);
        return function() {
            navigationListeners = navigationListeners.filter(cb => cb !== callback);
        };
    }

    function notifyNavigation(routeName) {
        navigationListeners.forEach(callback => {
            try {
                callback(routeName);
            } catch (error) {
                console.error('Navigation listener error:', error);
            }
        });
    }

    function updateNavigationUI() {
        const navLinks = document.querySelectorAll('[data-route]');
        
        navLinks.forEach(link => {
            const route = link.getAttribute('data-route');
            const canAccess = PermissionSystem.canAccessRoute(route);
            
            if (canAccess) {
                link.classList.remove('nav-hidden');
                link.removeAttribute('disabled');
                link.style.display = '';
            } else {
                link.classList.add('nav-hidden');
                link.setAttribute('disabled', 'true');
                link.style.display = 'none';
            }
        });
        
        updateAdminNavigation();
    }

    function updateAdminNavigation() {
        const adminNavItems = document.querySelectorAll('[data-admin-only]');
        
        adminNavItems.forEach(item => {
            if (PermissionSystem.isAdmin()) {
                item.classList.remove('nav-hidden');
                item.style.display = '';
            } else {
                item.classList.add('nav-hidden');
                item.style.display = 'none';
            }
        });
    }

    function getCurrentRoute() {
        return lastRoute || window.location.hash.slice(1) || DEFAULT_ROUTE;
    }

    function getRouteHistory() {
        return JSON.parse(sessionStorage.getItem('route_history') || '[]');
    }

    function addToHistory(routeName) {
        const history = getRouteHistory();
        history.push({
            route: routeName,
            timestamp: Date.now()
        });
        
        if (history.length > 50) {
            history.shift();
        }
        
        sessionStorage.setItem('route_history', JSON.stringify(history));
    }

    return {
        initialize,
        navigateTo,
        validateRoute,
        validateAndNavigate,
        onNavigation,
        updateNavigationUI,
        getCurrentRoute,
        getRouteHistory,
        addToHistory,
        PUBLIC_ROUTES,
        DEFAULT_ROUTE,
        FORBIDDEN_ROUTE
    };
})();

window.RouterGuard = RouterGuard;
