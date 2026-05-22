const PermissionDirectives = (function() {
    const observers = [];

    function initialize() {
        PermissionSystem.onPermissionChange(() => {
            updateAllElements();
        });
        
        observeDOMChanges();
        
        updateAllElements();
    }

    function updateAllElements() {
        updateElementsByPermission();
        updateElementsByRole();
        updateElementsByCommunityRole();
        updateAdminElements();
    }

    function updateElementsByPermission() {
        const elements = document.querySelectorAll('[data-permission]');
        
        elements.forEach(element => {
            const requiredPermission = element.getAttribute('data-permission');
            const hasPermission = PermissionSystem.hasPermission(requiredPermission);
            
            applyVisibility(element, hasPermission);
        });
    }

    function updateElementsByRole() {
        const elements = document.querySelectorAll('[data-role]');
        
        elements.forEach(element => {
            const requiredRole = element.getAttribute('data-role');
            const currentRole = PermissionSystem.getRole();
            
            const hasRole = checkRoleHierarchy(currentRole, requiredRole);
            applyVisibility(element, hasRole);
        });
    }

    function updateElementsByCommunityRole() {
        const elements = document.querySelectorAll('[data-community-role]');
        
        elements.forEach(element => {
            const communityId = element.getAttribute('data-community-id');
            const requiredRole = element.getAttribute('data-community-role');
            
            if (!communityId) return;
            
            let hasRole = false;
            
            if (requiredRole === 'ADMIN') {
                hasRole = PermissionSystem.isCommunityAdmin(parseInt(communityId));
            } else if (requiredRole === 'MEMBER') {
                hasRole = PermissionSystem.isCommunityMember(parseInt(communityId));
            }
            
            applyVisibility(element, hasRole);
        });
    }

    function updateAdminElements() {
        const elements = document.querySelectorAll('[data-admin-only]');
        
        elements.forEach(element => {
            const isAdmin = PermissionSystem.isAdmin();
            applyVisibility(element, isAdmin);
        });
    }

    function checkRoleHierarchy(currentRole, requiredRole) {
        const hierarchy = {
            'ADMIN': 100,
            'USER': 10,
            'GUEST': 0
        };
        
        const currentLevel = hierarchy[currentRole] || 0;
        const requiredLevel = hierarchy[requiredRole] || 0;
        
        return currentLevel >= requiredLevel;
    }

    function applyVisibility(element, shouldShow) {
        const hideMode = element.getAttribute('data-hide-mode') || 'hide';
        
        if (shouldShow) {
            element.classList.remove('permission-hidden', 'permission-disabled');
            element.removeAttribute('disabled');
            
            if (element._originalDisplay !== undefined) {
                element.style.display = element._originalDisplay;
            }
        } else {
            switch (hideMode) {
                case 'disable':
                    element.classList.add('permission-disabled');
                    element.setAttribute('disabled', 'true');
                    break;
                    
                case 'hide':
                default:
                    element.classList.add('permission-hidden');
                    if (element._originalDisplay === undefined) {
                        element._originalDisplay = element.style.display || '';
                    }
                    element.style.display = 'none';
                    break;
            }
        }
    }

    function observeDOMChanges() {
        const observer = new MutationObserver((mutations) => {
            let shouldUpdate = false;
            
            mutations.forEach(mutation => {
                if (mutation.type === 'childList') {
                    mutation.addedNodes.forEach(node => {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            if (node.hasAttribute && (
                                node.hasAttribute('data-permission') ||
                                node.hasAttribute('data-role') ||
                                node.hasAttribute('data-admin-only') ||
                                node.hasAttribute('data-community-role')
                            )) {
                                shouldUpdate = true;
                            }
                            
                            if (node.querySelectorAll) {
                                const permissionElements = node.querySelectorAll('[data-permission], [data-role], [data-admin-only], [data-community-role]');
                                if (permissionElements.length > 0) {
                                    shouldUpdate = true;
                                }
                            }
                        }
                    });
                }
            });
            
            if (shouldUpdate) {
                updateAllElements();
            }
        });
        
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
        
        observers.push(observer);
    }

    function checkPermission(permission) {
        return PermissionSystem.hasPermission(permission);
    }

    function checkRole(role) {
        return PermissionSystem.getRole() === role;
    }

    function checkAdmin() {
        return PermissionSystem.isAdmin();
    }

    function checkCommunityAdmin(communityId) {
        return PermissionSystem.isCommunityAdmin(communityId);
    }

    function showIfPermission(element, permission) {
        if (typeof element === 'string') {
            element = document.querySelector(element);
        }
        
        if (!element) return;
        
        element.setAttribute('data-permission', permission);
        updateAllElements();
    }

    function showIfAdmin(element) {
        if (typeof element === 'string') {
            element = document.querySelector(element);
        }
        
        if (!element) return;
        
        element.setAttribute('data-admin-only', 'true');
        updateAllElements();
    }

    function showIfCommunityAdmin(element, communityId) {
        if (typeof element === 'string') {
            element = document.querySelector(element);
        }
        
        if (!element) return;
        
        element.setAttribute('data-community-role', 'ADMIN');
        element.setAttribute('data-community-id', communityId.toString());
        updateAllElements();
    }

    function disableIfNoPermission(element, permission) {
        if (typeof element === 'string') {
            element = document.querySelector(element);
        }
        
        if (!element) return;
        
        element.setAttribute('data-permission', permission);
        element.setAttribute('data-hide-mode', 'disable');
        updateAllElements();
    }

    function createPermissionButton(options) {
        const {
            text,
            permission,
            onClick,
            className = 'btn btn-primary',
            icon = null,
            disabled = false
        } = options;
        
        const button = document.createElement('button');
        button.className = className;
        button.type = 'button';
        button.disabled = disabled;
        
        if (icon) {
            button.innerHTML = `<i class="${icon}"></i> ${text}`;
        } else {
            button.textContent = text;
        }
        
        if (permission) {
            button.setAttribute('data-permission', permission);
            button.setAttribute('data-hide-mode', 'hide');
        }
        
        if (onClick) {
            button.addEventListener('click', onClick);
        }
        
        return button;
    }

    function createAdminOnlyButton(options) {
        const button = createPermissionButton(options);
        button.setAttribute('data-admin-only', 'true');
        return button;
    }

    function injectStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .permission-hidden {
                display: none !important;
            }
            
            .permission-disabled {
                opacity: 0.5;
                cursor: not-allowed !important;
                pointer-events: none;
            }
            
            .nav-hidden {
                display: none !important;
            }
            
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            
            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
            
            .permission-toast-content {
                display: flex;
                align-items: center;
                gap: 8px;
            }
        `;
        document.head.appendChild(style);
    }

    return {
        initialize,
        updateAllElements,
        checkPermission,
        checkRole,
        checkAdmin,
        checkCommunityAdmin,
        showIfPermission,
        showIfAdmin,
        showIfCommunityAdmin,
        disableIfNoPermission,
        createPermissionButton,
        createAdminOnlyButton,
        injectStyles
    };
})();

window.PermissionDirectives = PermissionDirectives;
