const DashboardAPI = {
    async getStats() {
        return await fetchApi('/dashboard/stats');
    }
};