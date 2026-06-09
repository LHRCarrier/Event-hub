<div id="page-create-event" class="page-content d-none">
    <div class="page-header">
        <button class="btn btn-outline-primary back-btn" onclick="showPage('events')">
            <i class="fas fa-arrow-left me-2"></i>Back
        </button>
        <div class="page-title-section">
            <h1 class="page-title">Create Event</h1>
            <p class="page-subtitle">Create a new event for your community</p>
        </div>
        <div></div>
    </div>

    <div class="create-event-container">
        <div class="create-event-card">
            <form id="createEventForm" class="create-event-form">
                <div class="form-group">
                    <label class="form-label">Event Name</label>
                    <input type="text" class="form-input" id="eventName" placeholder="Enter event name">
                </div>
                <div class="form-group">
                    <label class="form-label">Event Date</label>
                    <input type="datetime-local" class="form-input" id="eventDate">
                </div>
                <div class="form-group">
                    <label class="form-label">Location</label>
                    <input type="text" class="form-input" id="eventLocation" placeholder="Enter location">
                </div>
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select class="form-input" id="eventCategory"></select>
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea class="form-input" rows="4" id="eventDescription" placeholder="Enter event description"></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="showPage('events')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Event</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
#page-create-event .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-create-event .back-btn {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: rgba(255, 255, 255, 0.9);
    border-radius: 12px;
    padding: 10px 16px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 
        0 4px 12px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
    position: relative;
    overflow: hidden;
}

#page-create-event .back-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.4s ease;
}

#page-create-event .back-btn:hover::before {
    left: 100%;
}

#page-create-event .back-btn:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
    box-shadow: 
        0 6px 20px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-create-event .back-btn:active {
    transform: translateY(0);
    box-shadow: 
        0 3px 10px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

#page-create-event .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-create-event .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-create-event .create-event-container {
    display: flex;
    justify-content: center;
}

#page-create-event .create-event-card {
    width: 100%;
    max-width: 600px;
    border-radius: 28px;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03));
    border: 1px solid rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(0px);
    -webkit-backdrop-filter: blur(0px);
    box-shadow:
        0 8px 32px rgba(255, 255, 255, 0.08),
        0 0 40px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    padding: 40px;
    transition: all 0.4s ease;
    position: relative;
    overflow: hidden;
}

#page-create-event .create-event-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 40%;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
    pointer-events: none;
    border-radius: 28px 28px 0 0;
}

#page-create-event .create-event-card::after {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transform: rotate(45deg);
    transition: all 0.5s ease;
    opacity: 0;
    pointer-events: none;
}

#page-create-event .create-event-card:hover::after {
    animation: shimmer 0.6s ease-out;
}

#page-create-event .create-event-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow:
        0 20px 50px rgba(255, 255, 255, 0.12),
        0 0 40px rgba(255, 255, 255, 0.06),
        inset 0 0 0 1px rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

#page-create-event .create-event-form {
    display: flex;
    flex-direction: column;
    gap: 20px;
    position: relative;
    z-index: 1;
}

#page-create-event .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#page-create-event .form-label {
    font-size: 14px;
    font-weight: 500;
    color: var(--white-90);
}

#page-create-event .form-input {
    padding: 12px 16px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid rgba(255, 255, 255, 0.12);
    color: var(--white-95);
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, background 0.2s;
    resize: vertical;
}

#page-create-event .form-input:focus {
    border-color: rgba(255, 255, 255, 0.4);
    background: rgba(255, 255, 255, 0.08);
    box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.08);
}

#page-create-event .form-input::placeholder {
    color: var(--white-50);
}

#page-create-event .form-actions {
    display: flex;
    gap: 12px;
    margin-top: 12px;
}

#page-create-event .form-actions .btn {
    flex: 1;
    padding: 12px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
}

#page-create-event .btn-primary {
    background: rgba(255, 255, 255, 0.1) !important;
    color: rgba(255, 255, 255, 0.9) !important;
    border: 1px solid rgba(255, 255, 255, 0.15) !important;
    box-shadow:
        0 4px 16px rgba(255, 255, 255, 0.08),
        0 0 20px rgba(255, 255, 255, 0.04),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
    position: relative;
    overflow: hidden;
}

#page-create-event .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.5s ease;
}

#page-create-event .btn-primary:hover::before {
    left: 100%;
}

#page-create-event .btn-primary:hover {
    background: rgba(255, 255, 255, 0.15) !important;
    transform: translateY(-2px);
    box-shadow:
        0 8px 24px rgba(255, 255, 255, 0.12),
        0 0 30px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.15);
}

#page-create-event .btn-primary:active {
    transform: translateY(0);
    box-shadow:
        0 4px 12px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

#page-create-event .btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow:
        0 4px 12px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

#page-create-event .btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
    transform: translateY(-2px);
    box-shadow:
        0 6px 20px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-create-event .btn-secondary:active {
    transform: translateY(0);
    box-shadow:
        0 3px 10px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

@media (max-width: 767px) {
    #page-create-event .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }

    #page-create-event .create-event-card {
        padding: 24px;
        margin: 0 16px;
    }

    #page-create-event .form-actions {
        flex-direction: column;
    }
}
</style>