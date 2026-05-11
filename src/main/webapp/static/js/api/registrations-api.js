const RegistrationsAPI = {
    async getRegistrationsByUser(userId) {
        return await fetchApi(`/registrations/user/${userId}`);
    },
    
    async getRegistrationsByEvent(eventId) {
        return await fetchApi(`/registrations/event/${eventId}`);
    },
    
    async createRegistration(data) {
        return await fetchApi('/registrations', {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },
    
    async cancelRegistration(registrationId) {
        return await fetchApi(`/registrations/${registrationId}`, {
            method: 'DELETE'
        });
    }
};