const UserCategoriesAPI = {
    async getCategories() {
        return await fetchApi('/categories');
    },
    
    async getCategory(categoryId) {
        return await fetchApi(`/categories/${categoryId}`);
    }
};

const AdminCategoryAPI = {
    async getAllCategories() {
        return await fetchApi('/admin/categories');
    },
    
    async getCategory(categoryId) {
        return await fetchApi(`/admin/categories/${categoryId}`);
    },
    
    async createCategory(data) {
        return await fetchApi('/admin/categories', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },
    
    async updateCategory(categoryId, data) {
        return await fetchApi(`/admin/categories/${categoryId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async deleteCategory(categoryId) {
        return await fetchApi(`/admin/categories/${categoryId}`, {
            method: 'DELETE'
        });
    }
};

const CategoriesAPI = {
    ...UserCategoriesAPI,
    ...AdminCategoryAPI,
    
    async getCategories() {
        return await UserCategoriesAPI.getCategories();
    },
    
    async getCategory(categoryId) {
        return await UserCategoriesAPI.getCategory(categoryId);
    },
    
    async createCategory(data) {
        return await AdminCategoryAPI.createCategory(data);
    },
    
    async updateCategory(categoryId, data) {
        return await AdminCategoryAPI.updateCategory(categoryId, data);
    },
    
    async deleteCategory(categoryId) {
        return await AdminCategoryAPI.deleteCategory(categoryId);
    },
    
    async getAllCategories() {
        return await AdminCategoryAPI.getAllCategories();
    }
};
