const CategoriesAPI = {
    async getCategories() {
        return await fetchApi('/categories');
    },
    
    async getCategory(categoryId) {
        return await fetchApi(`/categories/${categoryId}`);
    },
    
    async createCategory(data) {
        return await fetchApi('/categories', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },
    
    async updateCategory(categoryId, data) {
        return await fetchApi(`/categories/${categoryId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async deleteCategory(categoryId) {
        return await fetchApi(`/categories/${categoryId}`, {
            method: 'DELETE'
        });
    }
};