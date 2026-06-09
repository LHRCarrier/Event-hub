const PermissionSystem = (function() {
    const ROLE_HIERARCHY = {
        'ADMIN': 100,
        'USER': 10,
        'GUEST': 0
    };

    const PERMISSIONS = {
        VIEW_EVENTS: 'view_events',
        CREATE_EVENT: 'create_event',
        EDIT_EVENT: 'edit_event',
        DELETE_EVENT: 'delete_event',
        REGISTER_EVENT: 'register_event',
        
        VIEW_CATEGORIES: 'view_categories',
        CREATE_CATEGORY: 'create_category',
        EDIT_CATEGORY: 'edit_category',
        DELETE_CATEGORY: 'delete_category',
        
        VIEW_USERS: 'view_users',
        EDIT_USER: 'edit_user',
        DISABLE_USER: 'disable_user',
        ENABLE_USER: 'enable_user',
        
        VIEW_DASHBOARD: 'view_dashboard',
        
        CREATE_COMMUNITY: 'create_community',
        VIEW_COMMUNITIES: 'view_communities',
        EDIT_COMMUNITY: 'edit_community',
        DELETE_COMMUNITY: 'delete_community',
        JOIN_COMMUNITY: 'join_community',
        LEAVE_COMMUNITY: 'leave_community',
        MANAGE_COMMUNITY_MEMBERS: 'manage_community_members',
        APPROVE_COMMUNITY_APPLICATION: 'approve_community_application',
        
        VIEW_APPLICATIONS: 'view_applications',
        APPROVE_CREATE_APPLICATION: 'approve_create_application',
        
        MANAGE_SETTINGS: 'manage_settings'
    };

    const ROLE_PERMISSIONS = {
        'ADMIN': [
            PERMISSIONS.VIEW_EVENTS,
            PERMISSIONS.CREATE_EVENT,
            PERMISSIONS.EDIT_EVENT,
            PERMISSIONS.DELETE_EVENT,
            PERMISSIONS.REGISTER_EVENT,
            PERMISSIONS.VIEW_CATEGORIES,
            PERMISSIONS.CREATE_CATEGORY,
            PERMISSIONS.EDIT_CATEGORY,
            PERMISSIONS.DELETE_CATEGORY,
            PERMISSIONS.VIEW_USERS,
            PERMISSIONS.EDIT_USER,
            PERMISSIONS.DISABLE_USER,
            PERMISSIONS.ENABLE_USER,
            PERMISSIONS.VIEW_DASHBOARD,
            PERMISSIONS.CREATE_COMMUNITY,
            PERMISSIONS.VIEW_COMMUNITIES,
            PERMISSIONS.EDIT_COMMUNITY,
            PERMISSIONS.DELETE_COMMUNITY,
            PERMISSIONS.JOIN_COMMUNITY,
            PERMISSIONS.LEAVE_COMMUNITY,
            PERMISSIONS.MANAGE_COMMUNITY_MEMBERS,
            PERMISSIONS.APPROVE_COMMUNITY_APPLICATION,
            PERMISSIONS.VIEW_APPLICATIONS,
            PERMISSIONS.APPROVE_CREATE_APPLICATION,
            PERMISSIONS.MANAGE_SETTINGS
        ],
        'USER': [
            PERMISSIONS.VIEW_EVENTS,
            PERMISSIONS.REGISTER_EVENT,
            PERMISSIONS.VIEW_CATEGORIES,
            PERMISSIONS.VIEW_COMMUNITIES,
            PERMISSIONS.CREATE_COMMUNITY,
            PERMISSIONS.JOIN_COMMUNITY,
            PERMISSIONS.LEAVE_COMMUNITY,
            PERMISSIONS.VIEW_APPLICATIONS
        ],
        'GUEST': [
            PERMISSIONS.VIEW_EVENTS,
            PERMISSIONS.VIEW_CATEGORIES,
            PERMISSIONS.VIEW_COMMUNITIES
        ]
    };

    const ROUTE_PERMISSIONS = {
        'home': [],
        'home-new': [],
        'events': [PERMISSIONS.VIEW_EVENTS],
        'event-detail': [PERMISSIONS.VIEW_EVENTS],
        'create-event': [PERMISSIONS.CREATE_EVENT],
        'categories': [PERMISSIONS.VIEW_CATEGORIES],
        'create-category': [PERMISSIONS.CREATE_CATEGORY],
        'users': [PERMISSIONS.VIEW_USERS],
        'dashboard': [PERMISSIONS.VIEW_DASHBOARD],
        'registrations': [PERMISSIONS.REGISTER_EVENT],
        'profile': [],
        'communities': [PERMISSIONS.VIEW_COMMUNITIES],
        'community-detail': [PERMISSIONS.VIEW_COMMUNITIES],
        'create-community': [PERMISSIONS.CREATE_COMMUNITY],
        'community-members': [PERMISSIONS.MANAGE_COMMUNITY_MEMBERS],
        'community-home': [PERMISSIONS.VIEW_COMMUNITIES],
        'community-dashboard': [PERMISSIONS.MANAGE_COMMUNITY_MEMBERS],
        'applications': [PERMISSIONS.VIEW_APPLICATIONS],
        'community-approvals': [PERMISSIONS.APPROVE_CREATE_APPLICATION],
        'settings': [PERMISSIONS.MANAGE_SETTINGS]
    };

    const ADMIN_ROUTES = ['users', 'dashboard', 'community-approvals', 'settings'];

    let currentUser = null;
    let userPermissions = [];
    let communityRoles = {};
    let permissionListeners = [];

    function init(user) {
        currentUser = user;
        updatePermissions();
        loadCommunityRoles();
    }

    function updatePermissions() {
        if (!currentUser || !currentUser.role) {
            userPermissions = ROLE_PERMISSIONS['GUEST'] || [];
            return;
        }
        userPermissions = ROLE_PERMISSIONS[currentUser.role] || ROLE_PERMISSIONS['GUEST'] || [];
        notifyPermissionChange();
    }

    async function loadCommunityRoles() {
        if (!currentUser) return;
        
        try {
            const result = await CommunitiesAPI.getUserCommunities(currentUser.userId);
            if (result.code === 200 && result.data) {
                communityRoles = {};
                result.data.forEach(community => {
                    communityRoles[community.communityId] = community.role;
                });
                notifyPermissionChange();
            }
        } catch (error) {
            console.error('Failed to load community roles:', error);
        }
    }

    function hasPermission(permission) {
        return userPermissions.includes(permission);
    }

    function hasAnyPermission(permissions) {
        if (!permissions || permissions.length === 0) return true;
        return permissions.some(p => userPermissions.includes(p));
    }

    function hasAllPermissions(permissions) {
        if (!permissions || permissions.length === 0) return true;
        return permissions.every(p => userPermissions.includes(p));
    }

    function canAccessRoute(routeName) {
        const requiredPermissions = ROUTE_PERMISSIONS[routeName];
        
        if (!requiredPermissions || requiredPermissions.length === 0) {
            return true;
        }
        
        if (ADMIN_ROUTES.includes(routeName) && !isAdmin()) {
            return false;
        }
        
        return hasAnyPermission(requiredPermissions);
    }

    function isAdmin() {
        return currentUser && currentUser.role === 'ADMIN';
    }

    function isUser() {
        return currentUser && (currentUser.role === 'USER' || currentUser.role === 'ADMIN');
    }

    function getRole() {
        return currentUser ? currentUser.role : 'GUEST';
    }

    function getRoleLevel() {
        const role = getRole();
        return ROLE_HIERARCHY[role] || 0;
    }

    function isCommunityAdmin(communityId) {
        if (isAdmin()) return true;
        return communityRoles[communityId] === 'ADMIN';
    }

    function isCommunityMember(communityId) {
        if (isAdmin()) return true;
        return communityRoles[communityId] === 'MEMBER' || communityRoles[communityId] === 'ADMIN';
    }

    function getCommunityRole(communityId) {
        return communityRoles[communityId] || null;
    }

    function updateCommunityRole(communityId, role) {
        communityRoles[communityId] = role;
        notifyPermissionChange();
    }

    function removeCommunityRole(communityId) {
        delete communityRoles[communityId];
        notifyPermissionChange();
    }

    function setUser(user) {
        currentUser = user;
        updatePermissions();
        loadCommunityRoles();
    }

    function clearUser() {
        currentUser = null;
        userPermissions = ROLE_PERMISSIONS['GUEST'] || [];
        communityRoles = {};
        notifyPermissionChange();
    }

    function onPermissionChange(callback) {
        permissionListeners.push(callback);
        return function() {
            permissionListeners = permissionListeners.filter(cb => cb !== callback);
        };
    }

    function notifyPermissionChange() {
        permissionListeners.forEach(callback => {
            try {
                callback({
                    user: currentUser,
                    permissions: userPermissions,
                    communityRoles: communityRoles
                });
            } catch (error) {
                console.error('Permission listener error:', error);
            }
        });
    }

    function getFilteredRoutes(allRoutes) {
        return allRoutes.filter(route => canAccessRoute(route));
    }

    function getAdminRoutes() {
        return ADMIN_ROUTES;
    }

    function checkApiPermission(apiPath, method) {
        if (apiPath.startsWith('/api/admin/')) {
            return isAdmin();
        }
        
        if (apiPath.startsWith('/api/c/')) {
            const match = apiPath.match(/\/api\/c\/(\d+)/);
            if (match) {
                const communityId = parseInt(match[1]);
                return isCommunityMember(communityId);
            }
        }
        
        return true;
    }

    return {
        PERMISSIONS,
        init,
        hasPermission,
        hasAnyPermission,
        hasAllPermissions,
        canAccessRoute,
        isAdmin,
        isUser,
        getRole,
        getRoleLevel,
        isCommunityAdmin,
        isCommunityMember,
        getCommunityRole,
        updateCommunityRole,
        removeCommunityRole,
        setUser,
        clearUser,
        onPermissionChange,
        getFilteredRoutes,
        getAdminRoutes,
        checkApiPermission,
        loadCommunityRoles
    };
})();

window.PermissionSystem = PermissionSystem;
