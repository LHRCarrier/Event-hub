const EventsAPI = {
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
    
    async createEvent(data) {
        return await fetchApi('/events', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },
    
    async updateEvent(eventId, data) {
        return await fetchApi(`/events/${eventId}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },
    
    async deleteEvent(eventId) {
        return await fetchApi(`/events/${eventId}`, {
            method: 'DELETE'
        });
    },
    
    async searchEvents(keyword, categoryId = '', startDate = '', endDate = '') {
        let url = `/search/events?keyword=${encodeURIComponent(keyword)}`;
        if (categoryId) url += `&categoryId=${categoryId}`;
        if (startDate) url += `&startDate=${startDate}`;
        if (endDate) url += `&endDate=${endDate}`;
        return await fetchApi(url);
    }
};