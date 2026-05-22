const PermissionTests = (function() {
    let testResults = [];
    let passedTests = 0;
    let failedTests = 0;

    function assert(condition, testName, details = '') {
        const result = {
            name: testName,
            passed: condition,
            details: details,
            timestamp: new Date().toISOString()
        };
        
        testResults.push(result);
        
        if (condition) {
            passedTests++;
            console.log(`✅ PASS: ${testName}`);
        } else {
            failedTests++;
            console.error(`❌ FAIL: ${testName}${details ? ' - ' + details : ''}`);
        }
        
        return condition;
    }

    function resetTestState() {
        testResults = [];
        passedTests = 0;
        failedTests = 0;
    }

    function createMockUser(role, userId = 1) {
        return {
            userId: userId,
            username: 'testuser',
            role: role,
            email: 'test@example.com'
        };
    }

    async function runAllTests() {
        console.log('========================================');
        console.log('Running Permission System Tests');
        console.log('========================================\n');
        
        resetTestState();
        
        await testRoleHierarchy();
        await testPermissionChecks();
        await testRouteAccess();
        await testCommunityPermissions();
        await testPermissionChanges();
        await testApiPermissionMiddleware();
        
        printSummary();
        
        return {
            total: testResults.length,
            passed: passedTests,
            failed: failedTests,
            results: testResults
        };
    }

    async function testRoleHierarchy() {
        console.log('\n--- Testing Role Hierarchy ---\n');
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        assert(PermissionSystem.isAdmin() === true, 'ADMIN user should be admin');
        assert(PermissionSystem.getRoleLevel() === 100, 'ADMIN role level should be 100');
        
        PermissionSystem.setUser(createMockUser('USER'));
        assert(PermissionSystem.isAdmin() === false, 'USER should not be admin');
        assert(PermissionSystem.isUser() === true, 'USER should be user');
        assert(PermissionSystem.getRoleLevel() === 10, 'USER role level should be 10');
        
        PermissionSystem.clearUser();
        assert(PermissionSystem.isAdmin() === false, 'Guest should not be admin');
        assert(PermissionSystem.isUser() === false, 'Guest should not be user');
        assert(PermissionSystem.getRole() === 'GUEST', 'Cleared user should be GUEST');
        assert(PermissionSystem.getRoleLevel() === 0, 'GUEST role level should be 0');
    }

    async function testPermissionChecks() {
        console.log('\n--- Testing Permission Checks ---\n');
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        assert(
            PermissionSystem.hasPermission('view_events') === true,
            'ADMIN should have view_events permission'
        );
        assert(
            PermissionSystem.hasPermission('create_event') === true,
            'ADMIN should have create_event permission'
        );
        assert(
            PermissionSystem.hasPermission('manage_settings') === true,
            'ADMIN should have manage_settings permission'
        );
        
        PermissionSystem.setUser(createMockUser('USER'));
        assert(
            PermissionSystem.hasPermission('view_events') === true,
            'USER should have view_events permission'
        );
        assert(
            PermissionSystem.hasPermission('create_event') === false,
            'USER should not have create_event permission'
        );
        assert(
            PermissionSystem.hasPermission('manage_settings') === false,
            'USER should not have manage_settings permission'
        );
        
        PermissionSystem.clearUser();
        assert(
            PermissionSystem.hasPermission('view_events') === true,
            'GUEST should have view_events permission'
        );
        assert(
            PermissionSystem.hasPermission('register_event') === false,
            'GUEST should not have register_event permission'
        );
        
        assert(
            PermissionSystem.hasAnyPermission(['view_events', 'create_event']) === true,
            'Should have any of the permissions (view_events)'
        );
        
        assert(
            PermissionSystem.hasAllPermissions(['view_events', 'create_event']) === false,
            'Should not have all permissions (missing create_event)'
        );
    }

    async function testRouteAccess() {
        console.log('\n--- Testing Route Access ---\n');
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        assert(
            PermissionSystem.canAccessRoute('dashboard') === true,
            'ADMIN can access dashboard'
        );
        assert(
            PermissionSystem.canAccessRoute('users') === true,
            'ADMIN can access users'
        );
        assert(
            PermissionSystem.canAccessRoute('settings') === true,
            'ADMIN can access settings'
        );
        
        PermissionSystem.setUser(createMockUser('USER'));
        assert(
            PermissionSystem.canAccessRoute('dashboard') === false,
            'USER cannot access dashboard'
        );
        assert(
            PermissionSystem.canAccessRoute('users') === false,
            'USER cannot access users'
        );
        assert(
            PermissionSystem.canAccessRoute('events') === true,
            'USER can access events'
        );
        assert(
            PermissionSystem.canAccessRoute('communities') === true,
            'USER can access communities'
        );
        
        PermissionSystem.clearUser();
        assert(
            PermissionSystem.canAccessRoute('home') === true,
            'GUEST can access home'
        );
        assert(
            PermissionSystem.canAccessRoute('events') === true,
            'GUEST can access events'
        );
        assert(
            PermissionSystem.canAccessRoute('profile') === false,
            'GUEST cannot access profile'
        );
    }

    async function testCommunityPermissions() {
        console.log('\n--- Testing Community Permissions ---\n');
        
        PermissionSystem.setUser(createMockUser('USER'));
        
        PermissionSystem.updateCommunityRole(1, 'ADMIN');
        assert(
            PermissionSystem.isCommunityAdmin(1) === true,
            'User should be community admin for community 1'
        );
        assert(
            PermissionSystem.isCommunityMember(1) === true,
            'Community admin should also be member'
        );
        
        PermissionSystem.updateCommunityRole(2, 'MEMBER');
        assert(
            PermissionSystem.isCommunityAdmin(2) === false,
            'User should not be community admin for community 2'
        );
        assert(
            PermissionSystem.isCommunityMember(2) === true,
            'User should be community member for community 2'
        );
        
        assert(
            PermissionSystem.isCommunityAdmin(999) === false,
            'User should not be admin of unknown community'
        );
        
        PermissionSystem.removeCommunityRole(1);
        assert(
            PermissionSystem.isCommunityAdmin(1) === false,
            'User should no longer be community admin after removal'
        );
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        assert(
            PermissionSystem.isCommunityAdmin(1) === true,
            'System ADMIN should be admin of any community'
        );
        assert(
            PermissionSystem.isCommunityMember(1) === true,
            'System ADMIN should be member of any community'
        );
    }

    async function testPermissionChanges() {
        console.log('\n--- Testing Permission Change Notifications ---\n');
        
        let notificationCount = 0;
        let lastNotification = null;
        
        const unsubscribe = PermissionSystem.onPermissionChange((data) => {
            notificationCount++;
            lastNotification = data;
        });
        
        PermissionSystem.setUser(createMockUser('USER'));
        await new Promise(resolve => setTimeout(resolve, 10));
        
        assert(
            notificationCount >= 1,
            'Permission change should trigger notification',
            `Notification count: ${notificationCount}`
        );
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        await new Promise(resolve => setTimeout(resolve, 10));
        
        assert(
            lastNotification && lastNotification.user && lastNotification.user.role === 'ADMIN',
            'Notification should contain updated user info'
        );
        
        notificationCount = 0;
        unsubscribe();
        
        PermissionSystem.setUser(createMockUser('USER'));
        await new Promise(resolve => setTimeout(resolve, 10));
        
        assert(
            notificationCount === 0,
            'Unsubscribed listener should not receive notifications'
        );
    }

    async function testApiPermissionMiddleware() {
        console.log('\n--- Testing API Permission Middleware ---\n');
        
        PermissionSystem.setUser(createMockUser('ADMIN'));
        
        let adminCheck = ApiPermissionMiddleware.checkApiPermission({
            url: '/api/admin/users',
            method: 'GET'
        });
        assert(
            adminCheck.allowed === true,
            'ADMIN should be allowed to access admin API'
        );
        
        PermissionSystem.setUser(createMockUser('USER'));
        
        adminCheck = ApiPermissionMiddleware.checkApiPermission({
            url: '/api/admin/users',
            method: 'GET'
        });
        assert(
            adminCheck.allowed === false,
            'USER should not be allowed to access admin API'
        );
        
        PermissionSystem.updateCommunityRole(1, 'ADMIN');
        let communityCheck = ApiPermissionMiddleware.checkApiPermission({
            url: '/api/c/1/events',
            method: 'POST'
        });
        assert(
            communityCheck.allowed === true,
            'Community admin should be allowed to POST to community API'
        );
        
        communityCheck = ApiPermissionMiddleware.checkApiPermission({
            url: '/api/c/1/events',
            method: 'GET'
        });
        assert(
            communityCheck.allowed === true,
            'Community member should be allowed to GET from community API'
        );
        
        communityCheck = ApiPermissionMiddleware.checkApiPermission({
            url: '/api/c/999/events',
            method: 'POST'
        });
        assert(
            communityCheck.allowed === false,
            'Non-member should not be allowed to POST to community API'
        );
    }

    function printSummary() {
        console.log('\n========================================');
        console.log('Test Summary');
        console.log('========================================');
        console.log(`Total Tests: ${testResults.length}`);
        console.log(`Passed: ${passedTests}`);
        console.log(`Failed: ${failedTests}`);
        console.log(`Success Rate: ${((passedTests / testResults.length) * 100).toFixed(1)}%`);
        console.log('========================================\n');
        
        if (failedTests > 0) {
            console.log('Failed Tests:');
            testResults
                .filter(r => !r.passed)
                .forEach(r => {
                    console.log(`  - ${r.name}${r.details ? ': ' + r.details : ''}`);
                });
        }
    }

    function getTestResults() {
        return {
            total: testResults.length,
            passed: passedTests,
            failed: failedTests,
            results: testResults
        };
    }

    return {
        runAllTests,
        getTestResults,
        assert,
        createMockUser,
        resetTestState
    };
})();

window.PermissionTests = PermissionTests;

document.addEventListener('DOMContentLoaded', function() {
    const testButton = document.createElement('button');
    testButton.textContent = 'Run Permission Tests';
    testButton.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        padding: 10px 20px;
        background: #3b82f6;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        z-index: 10000;
        font-size: 14px;
    `;
    testButton.setAttribute('data-admin-only', 'true');
    
    testButton.addEventListener('click', async () => {
        testButton.disabled = true;
        testButton.textContent = 'Running Tests...';
        
        const results = await PermissionTests.runAllTests();
        
        testButton.textContent = `Tests: ${results.passed}/${results.total} Passed`;
        setTimeout(() => {
            testButton.textContent = 'Run Permission Tests';
            testButton.disabled = false;
        }, 5000);
    });
    
    document.body.appendChild(testButton);
});
