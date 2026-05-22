const UserProfileAPI = {
    async getUser(userId) {
        return await fetchApi(`/users/${userId}`);
    },
    
    async updateUser(userId, data) {
        return await fetchApi(`/users/${userId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    }
};

const UserAvatarAPI = {
    async uploadAvatar(userId, file) {
        const formData = new FormData();
        formData.append('file', file);
        
        const options = {
            method: 'POST',
            body: formData
        };
        
        return await fetchApi(`/avatar/upload/${userId}`, options);
    },
    
    async deleteAvatar(userId) {
        return await fetchApi(`/avatar/${userId}`, {
            method: 'DELETE'
        });
    }
};

const AdminUserAPI = {
    async getUsers(page = 1, size = 10, keyword = '') {
        let url = `/admin/users?page=${page}&size=${size}`;
        if (keyword) {
            url += `&keyword=${encodeURIComponent(keyword)}`;
        }
        return await fetchApi(url);
    },
    
    async getUser(userId) {
        return await fetchApi(`/admin/users/${userId}`);
    },
    
    async updateUser(userId, data) {
        return await fetchApi(`/admin/users/${userId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async disableUser(userId) {
        return await fetchApi(`/admin/users/${userId}/disable`, {
            method: 'POST'
        });
    },
    
    async enableUser(userId) {
        return await fetchApi(`/admin/users/${userId}/enable`, {
            method: 'POST'
        });
    }
};

const UsersAPI = {
    ...UserProfileAPI,
    ...UserAvatarAPI,
    ...AdminUserAPI,
    
    async getUsers(page = 1, size = 10, keyword = '') {
        return await AdminUserAPI.getUsers(page, size, keyword);
    },
    
    async getUser(userId) {
        return await UserProfileAPI.getUser(userId);
    },
    
    async updateUser(userId, data) {
        return await UserProfileAPI.updateUser(userId, data);
    },
    
    async disableUser(userId) {
        return await AdminUserAPI.disableUser(userId);
    },
    
    async enableUser(userId) {
        return await AdminUserAPI.enableUser(userId);
    },
    
    async uploadAvatar(userId, file) {
        return await UserAvatarAPI.uploadAvatar(userId, file);
    },
    
    async deleteAvatar(userId) {
        return await UserAvatarAPI.deleteAvatar(userId);
    }
};
