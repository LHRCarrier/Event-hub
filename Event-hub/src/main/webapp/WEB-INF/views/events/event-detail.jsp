<div id="page-event-detail" class="page-content d-none">
    <div class="page-header">
        <button class="btn btn-outline-primary back-btn" onclick="showPage('events')">
            <i class="fas fa-arrow-left me-2"></i>Back
        </button>
        <div class="page-title-section">
            <h1 class="page-title">Event Details</h1>
            <p class="page-subtitle">View event information</p>
        </div>
        <div></div>
    </div>
    <div class="event-detail-container" id="eventDetail">
    </div>
</div>

<style>
#page-event-detail .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

#page-event-detail .back-btn {
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

#page-event-detail .back-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.12), transparent);
    transition: left 0.4s ease;
}

#page-event-detail .back-btn:hover::before {
    left: 100%;
}

#page-event-detail .back-btn:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
    box-shadow: 
        0 6px 20px rgba(255, 255, 255, 0.08),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

#page-event-detail .back-btn:active {
    transform: translateY(0);
    box-shadow: 
        0 3px 10px rgba(255, 255, 255, 0.06),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

#page-event-detail .page-title {
    font-size: 24px;
    font-weight: 700;
    color: var(--white-95);
    margin: 0 0 4px 0;
}

#page-event-detail .page-subtitle {
    font-size: 14px;
    color: var(--white-65);
    margin: 0;
}

#page-event-detail .event-detail-container {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

@media (max-width: 767px) {
    #page-event-detail .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }
}
</style>