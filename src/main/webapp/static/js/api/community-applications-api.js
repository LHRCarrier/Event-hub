const UserCommunityApplicationAPI = {
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

    async getUserCommunityApplications(userId) {
        return await fetchApi(`/community-applications/users/${userId}`);
    }
};

const AdminCommunityApplicationAPI = {
    async getAllApplications(page = 1, size = 10, status = '') {
        let url = `/admin/community-applications?page=${page}&size=${size}`;
        if (status) {
            url += `&status=${status}`;
        }
        return await fetchApi(url);
    },

    async approveApplication(applicationId, data) {
        return await fetchApi(`/admin/community-applications/${applicationId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    }
};

const CommunityApplicationsAPI = {
    ...UserCommunityApplicationAPI,
    ...AdminCommunityApplicationAPI,
    
    async applyToCommunity(communityId, data = {}) {
        return await UserCommunityApplicationAPI.applyToCommunity(communityId, data);
    },

    async getCommunityApplications(communityId, page = 1, size = 10, status = '') {
        return await UserCommunityApplicationAPI.getCommunityApplications(communityId, page, size, status);
    },

    async approveApplication(communityId, applicationId, data) {
        return await UserCommunityApplicationAPI.approveApplication(communityId, applicationId, data);
    },

    async getUserApplications(userId, page = 1, size = 10) {
        return await UserCommunityApplicationAPI.getUserApplications(userId, page, size);
    },

    async createCommunityApplication(data) {
        return await UserCommunityApplicationAPI.createCommunityApplication(data);
    },

    async getUserCommunityApplications(userId) {
        return await UserCommunityApplicationAPI.getUserCommunityApplications(userId);
    },

    async getAllCommunityApplications(page = 1, size = 10, status = '') {
        return await AdminCommunityApplicationAPI.getAllApplications(page, size, status);
    },

    async approveCommunityApplication(applicationId, data) {
        return await AdminCommunityApplicationAPI.approveApplication(applicationId, data);
    }
};
