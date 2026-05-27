window.API = {
    auth: {
        login: async (data) => {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            return await response.json();
        },
        register: async (data) => {
            const response = await fetch('/api/auth/register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            return await response.json();
        }
    },
    
    user: {
        getUser: (userId) => fetchApi(`/users/${userId}`),
        updateUser: (userId, data) => fetchApi(`/users/${userId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        }),
        getUserCommunities: (userId) => fetchApi(`/communities/users/${userId}`),
        countUserCommunities: (userId) => fetchApi(`/communities/users/${userId}/count`),
        uploadAvatar: (userId, file) => {
            const formData = new FormData();
            formData.append('file', file);
            return fetchApi(`/avatar/upload/${userId}`, { method: 'POST', body: formData });
        },
        deleteAvatar: (userId) => fetchApi(`/avatar/${userId}`, { method: 'DELETE' })
    },
    
    community: {
        getCommunities: (page = 1, size = 10, keyword = '') => {
            let url = `/communities?page=${page}&size=${size}`;
            if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
            return fetchApi(url);
        },
        getCommunity: (communityId) => fetchApi(`/communities/${communityId}`),
        createCommunity: (data) => fetchApi('/communities', {
            method: 'POST',
            body: JSON.stringify(data)
        }),
        updateCommunity: (communityId, data) => fetchApi(`/communities/${communityId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        }),
        deleteCommunity: (communityId) => fetchApi(`/communities/${communityId}`, {
            method: 'DELETE'
        }),
        
        joinCommunity: (communityId) => fetchApi(`/communities/${communityId}/members/join`, {
            method: 'POST'
        }),
        leaveCommunity: (communityId) => fetchApi(`/communities/${communityId}/members/leave`, {
            method: 'POST'
        }),
        getMembers: (communityId, page = 1, size = 10) => 
            fetchApi(`/communities/${communityId}/members?page=${page}&size=${size}`),
        updateMemberRole: (communityId, memberId, role) => 
            fetchApi(`/communities/${communityId}/members/${memberId}/role`, {
                method: 'PUT',
                body: JSON.stringify({ role })
            }),
        removeMember: (communityId, memberId) => 
            fetchApi(`/communities/${communityId}/members/${memberId}`, { method: 'DELETE' }),
        checkMembership: (communityId) => 
            fetchApi(`/communities/${communityId}/members/check`),
        
        applyToJoin: (communityId, data) => 
            fetchApi(`/communities/${communityId}/apply`, {
                method: 'POST',
                body: JSON.stringify(data || {})
            }),
        getApplications: (communityId, page = 1, size = 10, status = '') => {
            let url = `/communities/${communityId}/applications?page=${page}&size=${size}`;
            if (status) url += `&status=${status}`;
            return fetchApi(url);
        },
        approveApplication: (communityId, applicationId, data) =>
            fetchApi(`/communities/${communityId}/applications/${applicationId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            }),
        getUserApplications: (userId, page = 1, size = 10) =>
            fetchApi(`/communities/users/${userId}/applications?page=${page}&size=${size}`),
        
        createCommunityApplication: (data) => 
            fetchApi('/community-applications', {
                method: 'POST',
                body: JSON.stringify(data)
            }),
        getUserCommunityApplications: (userId) =>
            fetchApi(`/community-applications/users/${userId}`),
        
        getHome: (communityId) => fetchApi(`/c/${communityId}/home`),
        getEvents: (communityId, page = 1, size = 10) =>
            fetchApi(`/c/${communityId}/events?page=${page}&size=${size}`),
        getEvent: (communityId, eventId) => fetchApi(`/c/${communityId}/events/${eventId}`),
        createEvent: (communityId, data) =>
            fetchApi(`/c/${communityId}/events`, {
                method: 'POST',
                body: JSON.stringify(data)
            }),
        updateEvent: (communityId, eventId, data) =>
            fetchApi(`/c/${communityId}/events/${eventId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            }),
        deleteEvent: (communityId, eventId) =>
            fetchApi(`/c/${communityId}/events/${eventId}`, { method: 'DELETE' }),
        
        getRegistrations: (communityId) => fetchApi(`/c/${communityId}/registrations`),
        getCategories: (communityId) => fetchApi(`/c/${communityId}/categories`),
        createCategory: (communityId, data) =>
            fetchApi(`/c/${communityId}/categories`, {
                method: 'POST',
                body: JSON.stringify(data)
            }),
        getDashboardStats: (communityId) => fetchApi(`/c/${communityId}/dashboard/stats`)
    },
    
    event: {
        getEvents: (page = 1, size = 10, status = '') => {
            let url = `/events?page=${page}&size=${size}`;
            if (status) url += `&status=${status}`;
            return fetchApi(url);
        },
        getEvent: (eventId) => fetchApi(`/events/${eventId}`),
        search: (keyword, categoryId = '', startDate = '', endDate = '') => {
            let url = `/search/events?keyword=${encodeURIComponent(keyword)}`;
            if (categoryId) url += `&categoryId=${categoryId}`;
            if (startDate) url += `&startDate=${startDate}`;
            if (endDate) url += `&endDate=${endDate}`;
            return fetchApi(url);
        }
    },
    
    registration: {
        getByUser: (userId) => fetchApi(`/registrations/user/${userId}`),
        getByEvent: (eventId) => fetchApi(`/registrations/event/${eventId}`),
        create: (data) => fetchApi('/registrations', {
            method: 'POST',
            body: JSON.stringify(data)
        }),
        cancel: (registrationId) => fetchApi(`/registrations/${registrationId}`, {
            method: 'DELETE'
        }),
        check: (eventId, userId) => fetchApi(`/registrations/check?eventId=${eventId}&userId=${userId}`)
    },
    
    category: {
        getAll: () => fetchApi('/categories'),
        get: (categoryId) => fetchApi(`/categories/${categoryId}`)
    },
    
    admin: {
        dashboard: {
            getStats: () => fetchApi('/admin/dashboard/stats'),
            getChartData: () => fetchApi('/admin/dashboard/chart-data')
        },
        users: {
            getAll: (page = 1, size = 10, keyword = '') => {
                let url = `/admin/users?page=${page}&size=${size}`;
                if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
                return fetchApi(url);
            },
            get: (userId) => fetchApi(`/admin/users/${userId}`),
            update: (userId, data) => fetchApi(`/admin/users/${userId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            }),
            disable: (userId) => fetchApi(`/admin/users/${userId}/disable`, { method: 'POST' }),
            enable: (userId) => fetchApi(`/admin/users/${userId}/enable`, { method: 'POST' })
        },
        events: {
            getAll: (page = 1, size = 10, keyword = '', categoryId = '', status = 'ALL') => {
                let url = `/admin/events?page=${page}&size=${size}`;
                if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
                if (categoryId) url += `&categoryId=${categoryId}`;
                if (status) url += `&status=${status}`;
                return fetchApi(url);
            },
            get: (eventId) => fetchApi(`/admin/events/${eventId}`),
            create: (data) => fetchApi('/admin/events', {
                method: 'POST',
                body: JSON.stringify(data)
            }),
            update: (eventId, data) => fetchApi(`/admin/events/${eventId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            }),
            delete: (eventId) => fetchApi(`/admin/events/${eventId}`, { method: 'DELETE' })
        },
        categories: {
            getAll: () => fetchApi('/admin/categories'),
            get: (categoryId) => fetchApi(`/admin/categories/${categoryId}`),
            create: (data) => fetchApi('/admin/categories', {
                method: 'POST',
                body: JSON.stringify(data)
            }),
            update: (categoryId, data) => fetchApi(`/admin/categories/${categoryId}`, {
                method: 'PUT',
                body: JSON.stringify(data)
            }),
            delete: (categoryId) => fetchApi(`/admin/categories/${categoryId}`, {
                method: 'DELETE'
            })
        },
        communityApplications: {
            getAll: (page = 1, size = 10, status = '') => {
                let url = `/admin/community-applications?page=${page}&size=${size}`;
                if (status) url += `&status=${status}`;
                return fetchApi(url);
            },
            approve: (applicationId, data) =>
                fetchApi(`/admin/community-applications/${applicationId}`, {
                    method: 'PUT',
                    body: JSON.stringify(data)
                })
        }
    }
};

window.fetchApi = fetchApi;
