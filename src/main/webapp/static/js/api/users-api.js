const UsersAPI = {
    async getUsers(page = 1, size = 10) {
        return await fetchApi(`/users?page=${page}&size=${size}`);
    },
    
    async getUser(userId) {
        return await fetchApi(`/users/${userId}`);
    },
    
    async updateUser(userId, data) {
        return await fetchApi(`/users/${userId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async disableUser(userId) {
        return await fetchApi(`/users/${userId}/disable`, {
            method: 'POST'
        });
    },
    
    async enableUser(userId) {
        return await fetchApi(`/users/${userId}/enable`, {
            method: 'POST'
        });
    }
};