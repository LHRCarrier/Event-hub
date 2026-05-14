const CommunityApplicationsAPI = {
    async applyToCommunity(communityId, data = {}) {
        return await fetchApi(`/communities/${communityId}/apply`, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    async getCommunityApplications(communityId, page = 1, size = 10, status = '') {
        let url = `/communities/${communityId}/applications?page=${page}&size=${size}`;
        if (status) {
            url += `&status=${status}`;
        }
        return await fetchApi(url);
    },

    async approveApplication(communityId, applicationId, data) {
        return await fetchApi(`/communities/${communityId}/applications/${applicationId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    async getUserApplications(userId, page = 1, size = 10) {
        return await fetchApi(`/communities/users/${userId}/applications?page=${page}&size=${size}`);
    },

    async createCommunityApplication(data) {
        return await fetchApi('/community-applications', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    async getAllCommunityApplications(page = 1, size = 10, status = '') {
        let url = `/community-applications?page=${page}&size=${size}`;
        if (status) {
            url += `&status=${status}`;
        }
        return await fetchApi(url);
    },

    async approveCommunityApplication(applicationId, data) {
        return await fetchApi(`/community-applications/${applicationId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    async getUserCommunityApplications(userId) {
        return await fetchApi(`/community-applications/users/${userId}`);
    }
};