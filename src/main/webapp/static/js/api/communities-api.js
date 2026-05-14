const CommunitiesAPI = {
    async getCommunities(page = 1, size = 10, keyword = '') {
        let url = `/communities?page=${page}&size=${size}`;
        if (keyword) {
            url += `&keyword=${encodeURIComponent(keyword)}`;
        }
        return await fetchApi(url);
    },

    async getCommunity(communityId) {
        return await fetchApi(`/communities/${communityId}`);
    },

    async createCommunity(data) {
        return await fetchApi('/communities', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    async updateCommunity(communityId, data) {
        return await fetchApi(`/communities/${communityId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    async deleteCommunity(communityId) {
        return await fetchApi(`/communities/${communityId}`, {
            method: 'DELETE'
        });
    },

    async joinCommunity(communityId) {
        return await fetchApi(`/communities/${communityId}/members/join`, {
            method: 'POST'
        });
    },

    async leaveCommunity(communityId) {
        return await fetchApi(`/communities/${communityId}/members/leave`, {
            method: 'POST'
        });
    },

    async getCommunityMembers(communityId, page = 1, size = 10) {
        return await fetchApi(`/communities/${communityId}/members?page=${page}&size=${size}`);
    },

    async updateMemberRole(communityId, memberId, role) {
        return await fetchApi(`/communities/${communityId}/members/${memberId}/role`, {
            method: 'PUT',
            body: JSON.stringify({ role })
        });
    },

    async removeMember(communityId, memberId) {
        return await fetchApi(`/communities/${communityId}/members/${memberId}`, {
            method: 'DELETE'
        });
    },

    async checkMembership(communityId) {
        return await fetchApi(`/communities/${communityId}/members/check`);
    },

    async getUserCommunities(userId) {
        return await fetchApi(`/users/${userId}/communities`);
    },

    async countUserCommunities(userId) {
        return await fetchApi(`/users/${userId}/communities/count`);
    },

    async getCommunityHome(communityId) {
        return await fetchApi(`/c/${communityId}/home`);
    },

    async getCommunityEvents(communityId, page = 1, size = 10) {
        return await fetchApi(`/c/${communityId}/events?page=${page}&size=${size}`);
    },

    async getCommunityEvent(communityId, eventId) {
        return await fetchApi(`/c/${communityId}/events/${eventId}`);
    },

    async createCommunityEvent(communityId, data) {
        return await fetchApi(`/c/${communityId}/events`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    async updateCommunityEvent(communityId, eventId, data) {
        return await fetchApi(`/c/${communityId}/events/${eventId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    async deleteCommunityEvent(communityId, eventId) {
        return await fetchApi(`/c/${communityId}/events/${eventId}`, {
            method: 'DELETE'
        });
    },

    async getCommunityRegistrations(communityId, page = 1, size = 10) {
        return await fetchApi(`/c/${communityId}/registrations?page=${page}&size=${size}`);
    },

    async getCommunityCategories(communityId) {
        return await fetchApi(`/c/${communityId}/categories`);
    },

    async createCommunityCategory(communityId, data) {
        return await fetchApi(`/c/${communityId}/categories`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    async getCommunityDashboardStats(communityId) {
        return await fetchApi(`/c/${communityId}/dashboard/stats`);
    }
};
