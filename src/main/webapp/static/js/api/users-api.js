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
    
    async deleteUser(userId) {
        return await fetchApi(`/users/${userId}`, {
            method: 'DELETE'
        });
    }
};