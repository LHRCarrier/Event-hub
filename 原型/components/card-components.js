const CardComponents = (function() {
    const templates = {};
    let isInitialized = false;

    function init() {
        if (isInitialized) return;
        
        const templateContainer = document.querySelector('.card-templates');
        if (!templateContainer) {
            console.warn('Card templates container not found');
            return;
        }

        const templateElements = templateContainer.querySelectorAll('template');
        templateElements.forEach(template => {
            templates[template.id] = template.innerHTML;
        });

        isInitialized = true;
        console.log('Card components initialized');
    }

    function renderTemplate(templateId, data) {
        if (!templates[templateId]) {
            console.error(`Template ${templateId} not found`);
            return '';
        }

        let html = templates[templateId];
        for (const [key, value] of Object.entries(data)) {
            const placeholder = `{{${key}}}`;
            html = html.split(placeholder).join(value !== undefined ? value : '');
        }
        return html;
    }

    function renderStatCard(data) {
        return renderTemplate('stat-card-template', data);
    }

    function renderEventCard(data) {
        const statusMap = {
            'Upcoming': 'upcoming',
            'Active': 'active',
            'Past': 'past',
            'Pending': 'warning',
            'Approved': 'success'
        };
        
        const statusClass = statusMap[data.status] || 'upcoming';
        return renderTemplate('event-card-template', {
            ...data,
            statusClass: statusClass
        });
    }

    function renderCommunityCard(data) {
        return renderTemplate('community-card-template', data);
    }

    function renderListCard(data) {
        const iconClassMap = {
            'primary': 'primary',
            'success': 'success',
            'warning': 'warning',
            'info': 'info'
        };
        
        const iconClass = iconClassMap[data.iconType] || 'primary';
        return renderTemplate('list-card-template', {
            ...data,
            iconClass: iconClass
        });
    }

    function renderActivityCard(data) {
        const iconClassMap = {
            'primary': 'primary',
            'success': 'success',
            'warning': 'warning',
            'info': 'info'
        };
        
        const iconClass = iconClassMap[data.iconType] || 'primary';
        return renderTemplate('activity-card-template', {
            ...data,
            iconClass: iconClass
        });
    }

    function renderCards(containerId, cards, cardType) {
        const container = document.getElementById(containerId);
        if (!container) {
            console.error(`Container ${containerId} not found`);
            return;
        }

        let html = '';
        cards.forEach(cardData => {
            switch (cardType) {
                case 'stat':
                    html += renderStatCard(cardData);
                    break;
                case 'event':
                    html += renderEventCard(cardData);
                    break;
                case 'community':
                    html += renderCommunityCard(cardData);
                    break;
                case 'list':
                    html += renderListCard(cardData);
                    break;
                case 'activity':
                    html += renderActivityCard(cardData);
                    break;
                default:
                    console.error(`Unknown card type: ${cardType}`);
            }
        });

        container.innerHTML = html;
    }

    function handleStatCardAction(cardId, action) {
        console.log(`Stat card action: ${action} for card ${cardId}`);
        switch (action) {
            case 'more':
                showStatCardOptions(cardId);
                break;
        }
    }

    function showStatCardOptions(cardId) {
        const options = ['View Details', 'Export Data', 'Refresh'];
        const menu = document.createElement('div');
        menu.className = 'dropdown-menu show';
        menu.style.position = 'fixed';
        menu.style.zIndex = '1000';
        
        options.forEach(option => {
            const item = document.createElement('a');
            item.className = 'dropdown-item';
            item.href = '#';
            item.textContent = option;
            item.onclick = () => {
                console.log(`Selected: ${option}`);
                menu.remove();
            };
            menu.appendChild(item);
        });
        
        document.body.appendChild(menu);
        
        document.addEventListener('click', function closeMenu(e) {
            if (!menu.contains(e.target)) {
                menu.remove();
                document.removeEventListener('click', closeMenu);
            }
        });
    }

    function handleEventAction(eventId, action) {
        console.log(`Event action: ${action} for event ${eventId}`);
        switch (action) {
            case 'register':
                handleEventRegistration(eventId);
                break;
            case 'share':
                shareEvent(eventId);
                break;
        }
    }

    function handleEventRegistration(eventId) {
        const confirmModal = createConfirmModal(
            'Register for Event',
            'Are you sure you want to register for this event?',
            () => {
                console.log(`Registered for event ${eventId}`);
                showToast('Successfully registered for event!');
            }
        );
        document.body.appendChild(confirmModal);
    }

    function shareEvent(eventId) {
        const shareUrl = `${window.location.origin}/event/${eventId}`;
        navigator.clipboard.writeText(shareUrl).then(() => {
            showToast('Share link copied to clipboard!');
        });
    }

    function handleCommunityAction(communityId, action) {
        console.log(`Community action: ${action} for community ${communityId}`);
        switch (action) {
            case 'join':
                joinCommunity(communityId);
                break;
            case 'view':
                viewCommunity(communityId);
                break;
        }
    }

    function joinCommunity(communityId) {
        const confirmModal = createConfirmModal(
            'Join Community',
            'Are you sure you want to join this community?',
            () => {
                console.log(`Joined community ${communityId}`);
                showToast('Successfully joined community!');
            }
        );
        document.body.appendChild(confirmModal);
    }

    function handleListAction(itemId, action) {
        console.log(`List action: ${action} for item ${itemId}`);
        switch (action) {
            case 'edit':
                editItem(itemId);
                break;
            case 'view':
                viewItem(itemId);
                break;
            case 'delete':
                deleteItem(itemId);
                break;
        }
    }

    function editItem(itemId) {
        console.log(`Editing item ${itemId}`);
        showToast(`Editing item ${itemId}...`);
    }

    function viewItem(itemId) {
        console.log(`Viewing item ${itemId}`);
        showToast(`Viewing item ${itemId}...`);
    }

    function deleteItem(itemId) {
        const confirmModal = createConfirmModal(
            'Delete Item',
            'Are you sure you want to delete this item? This action cannot be undone.',
            () => {
                console.log(`Deleted item ${itemId}`);
                showToast('Item deleted successfully!');
            }
        );
        document.body.appendChild(confirmModal);
    }

    function createConfirmModal(title, message, onConfirm) {
        const modal = document.createElement('div');
        modal.className = 'modal fade show';
        modal.style.display = 'block';
        modal.style.background = 'rgba(0,0,0,0.5)';
        modal.innerHTML = `
            <div class="modal-dialog" style="margin-top: 10%;">
                <div class="glass-effect rounded-xl p-6">
                    <h5 class="text-lg font-bold mb-4">${title}</h5>
                    <p class="text-gray-600 mb-6">${message}</p>
                    <div class="flex gap-3 justify-end">
                        <button class="btn btn-secondary" onclick="this.closest('.modal').remove()">
                            Cancel
                        </button>
                        <button class="btn btn-primary" onclick="(this.closest('.modal').remove(), ${onConfirm})">
                            Confirm
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
        
        return modal;
    }

    function showToast(message) {
        const toast = document.createElement('div');
        toast.className = 'toast show';
        toast.style.position = 'fixed';
        toast.style.bottom = '20px';
        toast.style.right = '20px';
        toast.style.background = 'rgba(45, 55, 72, 0.9)';
        toast.style.color = 'white';
        toast.style.padding = '12px 24px';
        toast.style.borderRadius = '8px';
        toast.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
        toast.style.zIndex = '9999';
        toast.textContent = message;
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    function preloadTemplates() {
        const link = document.createElement('link');
        link.rel = 'import';
        link.href = 'components/card-templates.html';
        link.onload = init;
        document.head.appendChild(link);
    }

    document.addEventListener('DOMContentLoaded', () => {
        const templateContainer = document.querySelector('.card-templates');
        if (templateContainer) {
            init();
        } else {
            preloadTemplates();
        }
    });

    return {
        init,
        renderStatCard,
        renderEventCard,
        renderCommunityCard,
        renderListCard,
        renderActivityCard,
        renderCards,
        handleStatCardAction,
        handleEventAction,
        handleCommunityAction,
        handleListAction
    };
})();

window.CardComponents = CardComponents;
window.handleStatCardAction = CardComponents.handleStatCardAction;
window.handleEventAction = CardComponents.handleEventAction;
window.handleCommunityAction = CardComponents.handleCommunityAction;
window.handleListAction = CardComponents.handleListAction;

const BackgroundManager = (function() {
    const drops = [];
    let rainInterval = null;

    const config = {
        videoPath: 'Mock-background/videos/8cd6ab41d3814faac0f96ec1e2bd4fbd_raw.mp4',
        imagePath: '',
        currentMode: 'video'
    };

    function createDrop() {
        const rainContainer = document.querySelector('.rain-background');
        if (!rainContainer) return;

        const drop = document.createElement('div');
        drop.className = 'rain-drop';
        
        const left = Math.random() * 100;
        const height = 10 + Math.random() * 20;
        const duration = 0.5 + Math.random() * 1;
        const delay = Math.random() * 5;
        
        drop.style.left = `${left}%`;
        drop.style.height = `${height}px`;
        drop.style.animationDuration = `${duration}s`;
        drop.style.animationDelay = `${delay}s`;
        
        rainContainer.appendChild(drop);
        drops.push(drop);
        
        setTimeout(() => {
            const index = drops.indexOf(drop);
            if (index > -1) {
                drops.splice(index, 1);
                drop.remove();
            }
        }, (duration + delay + 1) * 1000);
    }

    function startRainAnimation() {
        stopRainAnimation();
        
        function spawnDrops() {
            const count = 3 + Math.floor(Math.random() * 5);
            for (let i = 0; i < count; i++) {
                createDrop();
            }
        }
        
        spawnDrops();
        rainInterval = setInterval(spawnDrops, 100);
    }

    function stopRainAnimation() {
        if (rainInterval) {
            clearInterval(rainInterval);
            rainInterval = null;
        }
        drops.forEach(drop => drop.remove());
        drops.length = 0;
    }

    function showMode(mode) {
        const videoBg = document.getElementById('video-background');
        const imageBg = document.getElementById('image-background');
        const cssBg = document.getElementById('css-animation-background');

        videoBg.classList.add('hidden');
        imageBg.classList.add('hidden');
        cssBg.classList.add('hidden');

        switch(mode) {
            case 'video':
                videoBg.classList.remove('hidden');
                stopRainAnimation();
                break;
            case 'image':
                imageBg.classList.remove('hidden');
                stopRainAnimation();
                break;
            case 'css-animation':
            default:
                cssBg.classList.remove('hidden');
                startRainAnimation();
                break;
        }
        
        config.currentMode = mode;
    }

    function setVideoPath(path) {
        const video = document.getElementById('bg-video');
        const source = video.querySelector('source');
        source.src = path;
        config.videoPath = path;
        video.load();
    }

    function setImagePath(path) {
        const imageBg = document.getElementById('image-background');
        imageBg.style.backgroundImage = path ? `url(${path})` : '';
        config.imagePath = path;
    }

    function getConfig() {
        return { ...config };
    }

    function init() {
        showMode(config.currentMode);
    }

    document.addEventListener('DOMContentLoaded', init);

    return {
        init,
        showMode,
        setVideoPath,
        setImagePath,
        getConfig,
        startRainAnimation,
        stopRainAnimation
    };
})();

window.BackgroundManager = BackgroundManager;