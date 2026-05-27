const DashboardAPI = {
    async getStats() {
        return await fetchApi('/admin/dashboard/stats');
    },

    async getChartData() {
        return await fetchApi('/admin/dashboard/chart-data');
    }
};
