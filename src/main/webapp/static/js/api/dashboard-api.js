const DashboardAPI = {
    async getStats() {
        return await fetchApi('/admin/dashboard/stats');
    }
};
