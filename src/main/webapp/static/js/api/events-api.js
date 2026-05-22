const UserEventsAPI = {
    async getEvents(page = 1, size = 10, status = '') {
        let url = `/events?page=${page}&size=${size}`;
        if (status) {
            url += `&status=${status}`;
        }
        return await fetchApi(url);
    },
    
    async getEvent(eventId) {
        return await fetchApi(`/events/${eventId}`);
    },
    
    async searchEvents(keyword, categoryId = '', startDate = '', endDate = '') {
        let url = `/search/events?keyword=${encodeURIComponent(keyword)}`;
        if (categoryId) url += `&categoryId=${categoryId}`;
        if (startDate) url += `&startDate=${startDate}`;
        if (endDate) url += `&endDate=${endDate}`;
        return await fetchApi(url);
    }
};

const AdminEventAPI = {
    async getEvents(page = 1, size = 10, keyword = '', categoryId = '', status = 'ALL') {
        let url = `/admin/events?page=${page}&size=${size}`;
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        if (categoryId) url += `&categoryId=${categoryId}`;
        if (status) url += `&status=${status}`;
        return await fetchApi(url);
    },
    
    async getEvent(eventId) {
        return await fetchApi(`/admin/events/${eventId}`);
    },
    
    async createEvent(data) {
        return await fetchApi('/admin/events', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },
    
    async updateEvent(eventId, data) {
        return await fetchApi(`/admin/events/${eventId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async deleteEvent(eventId) {
        return await fetchApi(`/admin/events/${eventId}`, {
            method: 'DELETE'
        });
    }
};

const EventsAPI = {
    ...UserEventsAPI,
    ...AdminEventAPI,
    
    async getEvents(page = 1, size = 10, status = '') {
        return await UserEventsAPI.getEvents(page, size, status);
    },
    
    async getEvent(eventId) {
        return await UserEventsAPI.getEvent(eventId);
    },
    
    async searchEvents(keyword, categoryId = '', startDate = '', endDate = '') {
        return await UserEventsAPI.searchEvents(keyword, categoryId, startDate, endDate);
    },
    
    async createEvent(data) {
        return await AdminEventAPI.createEvent(data);
    },
    
    async updateEvent(eventId, data) {
        return await AdminEventAPI.updateEvent(eventId, data);
    },
    
    async deleteEvent(eventId) {
        return await AdminEventAPI.deleteEvent(eventId);
    }
};
