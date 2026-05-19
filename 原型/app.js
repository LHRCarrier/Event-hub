const loadedPages = {};
let isInitialized = false;
let charts = {};

function showPage(pageName) {
    if (!isInitialized) {
        console.log('Pages still loading...');
        return;
    }
    
    document.querySelectorAll('.page-content').forEach(page => {
        page.classList.remove('active');
    });
    
    const targetPage = document.getElementById('page-' + pageName);
    if (targetPage) {
        targetPage.classList.add('active');
    }
    
    document.querySelectorAll('.sidebar .nav-link').forEach(link => {
        link.classList.remove('active');
    });
    
    const activeLink = document.querySelector(`.sidebar .nav-link[href="#${pageName}"]`);
    if (activeLink) {
        activeLink.classList.add('active');
    }
    
    if (pageName === 'dashboard') {
        initDashboardCharts();
    }
}

function initDashboardCharts() {
    initTrendChart();
    initCategoryChart();
    initCommunityChart();
    initStatusChart();
}

function initTrendChart() {
    const chartDom = document.getElementById('trendChart');
    if (!chartDom) return;
    
    if (charts['trendChart']) {
        charts['trendChart'].dispose();
    }
    
    charts['trendChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'axis',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '10%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' }
        },
        yAxis: {
            type: 'value',
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' },
            splitLine: { lineStyle: { color: '#f0f0f0' } }
        },
        series: [
            {
                name: 'Registrations',
                type: 'line',
                smooth: true,
                data: [180, 220, 150, 320, 450, 580, 620, 550, 480, 380, 320, 410],
                lineStyle: { color: '#4f46e5', width: 3 },
                itemStyle: { color: '#4f46e5' },
                areaStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: 'rgba(79, 70, 229, 0.3)' },
                        { offset: 1, color: 'rgba(79, 70, 229, 0.05)' }
                    ])
                },
                symbol: 'circle',
                symbolSize: 6
            }
        ]
    };
    
    charts['trendChart'].setOption(option);
}

function initCategoryChart() {
    const chartDom = document.getElementById('categoryChart');
    if (!chartDom) return;
    
    if (charts['categoryChart']) {
        charts['categoryChart'].dispose();
    }
    
    charts['categoryChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'item',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            formatter: '{b}: {c} ({d}%)'
        },
        legend: {
            orient: 'horizontal',
            bottom: '5%',
            textStyle: { color: '#666' }
        },
        series: [
            {
                name: 'Events',
                type: 'pie',
                radius: ['45%', '70%'],
                center: ['50%', '45%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 8,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 18,
                        fontWeight: 'bold'
                    }
                },
                labelLine: { show: false },
                data: [
                    { value: 55, name: 'Technology', itemStyle: { color: '#4f46e5' } },
                    { value: 38, name: 'Sports', itemStyle: { color: '#f97316' } },
                    { value: 30, name: 'Cultural', itemStyle: { color: '#ec4899' } },
                    { value: 25, name: 'Art', itemStyle: { color: '#22c55e' } },
                    { value: 18, name: 'Business', itemStyle: { color: '#06b6d4' } },
                    { value: 15, name: 'Education', itemStyle: { color: '#a855f7' } },
                    { value: 12, name: 'Music', itemStyle: { color: '#f59e0b' } },
                    { value: 8, name: 'Other', itemStyle: { color: '#6b7280' } }
                ]
            }
        ]
    };
    
    charts['categoryChart'].setOption(option);
}

function initCommunityChart() {
    const chartDom = document.getElementById('communityChart');
    if (!chartDom) return;
    
    if (charts['communityChart']) {
        charts['communityChart'].dispose();
    }
    
    charts['communityChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'axis',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            axisPointer: { type: 'shadow' }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '10%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: ['Tech Club', 'Photography', 'Music', 'Sports', 'Book Club', 'Art'],
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666', interval: 0, rotate: 15 }
        },
        yAxis: {
            type: 'value',
            axisLine: { lineStyle: { color: '#e0e0e0' } },
            axisLabel: { color: '#666' },
            splitLine: { lineStyle: { color: '#f0f0f0' } }
        },
        series: [
            {
                name: 'Active Members',
                type: 'bar',
                barWidth: '50%',
                data: [156, 89, 124, 145, 67, 78],
                itemStyle: {
                    borderRadius: [6, 6, 0, 0],
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: '#3b82f6' },
                        { offset: 1, color: '#1d4ed8' }
                    ])
                }
            }
        ]
    };
    
    charts['communityChart'].setOption(option);
}

function initStatusChart() {
    const chartDom = document.getElementById('statusChart');
    if (!chartDom) return;
    
    if (charts['statusChart']) {
        charts['statusChart'].dispose();
    }
    
    charts['statusChart'] = echarts.init(chartDom);
    
    const option = {
        tooltip: {
            trigger: 'item',
            backgroundColor: 'rgba(255, 255, 255, 0.95)',
            borderColor: '#e0e0e0',
            textStyle: { color: '#333' },
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
            {
                name: 'Status',
                type: 'pie',
                radius: '65%',
                center: ['50%', '50%'],
                label: {
                    show: true,
                    formatter: '{b}\n{c} ({d}%)',
                    fontSize: 12
                },
                labelLine: { show: true },
                data: [
                    { value: 1850, name: 'Approved', itemStyle: { color: '#22c55e' } },
                    { value: 620, name: 'Pending', itemStyle: { color: '#f59e0b' } },
                    { value: 280, name: 'Cancelled', itemStyle: { color: '#ef4444' } },
                    { value: 97, name: 'Rejected', itemStyle: { color: '#6b7280' } }
                ]
            }
        ]
    };
    
    charts['statusChart'].setOption(option);
}

function loadPage(pageName) {
    return new Promise((resolve, reject) => {
        if (loadedPages[pageName]) {
            resolve();
            return;
        }
        
        const container = document.getElementById('page-' + pageName);
        if (!container) {
            reject('Container not found');
            return;
        }
        
        const xhr = new XMLHttpRequest();
        xhr.open('GET', `pages/${pageName}.html`, true);
        
        xhr.onload = function() {
            if (xhr.status === 200 || xhr.status === 0) {
                container.innerHTML = xhr.responseText;
                loadedPages[pageName] = true;
                resolve();
            } else {
                console.error('Failed to load page:', pageName, 'Status:', xhr.status);
                container.innerHTML = `<div class="text-center text-gray-500 py-8">Failed to load page: ${pageName}</div>`;
                loadedPages[pageName] = true;
                resolve();
            }
        };
        
        xhr.onerror = function() {
            console.error('Network error loading page:', pageName);
            container.innerHTML = `<div class="text-center text-gray-500 py-8">Network error loading page: ${pageName}</div>`;
            loadedPages[pageName] = true;
            resolve();
        };
        
        xhr.ontimeout = function() {
            console.error('Timeout loading page:', pageName);
            container.innerHTML = `<div class="text-center text-gray-500 py-8">Timeout loading page: ${pageName}</div>`;
            loadedPages[pageName] = true;
            resolve();
        };
        
        xhr.timeout = 5000;
        xhr.send();
    });
}

function searchEvents() {
    console.log('Searching events...');
}

function searchCommunities() {
    console.log('Searching communities...');
}

function searchHomeCommunities() {
    console.log('Searching home communities...');
}

function filterHomeCommunities(filter) {
    console.log('Filtering home communities by:', filter);
}

function viewEvent(id) {
    console.log('Viewing event:', id);
    showPage('event-detail');
}

function viewCommunity(id) {
    console.log('Viewing community:', id);
    showPage('community-detail');
}

function viewCommunityHome(id) {
    console.log('Viewing community home:', id);
    showPage('community-home');
}

function applyToCommunityBtn(id, name) {
    console.log('Applying to community:', id, name);
}

function showModal(modalId) {
    console.log('Showing modal:', modalId);
}

function goBackToCommunityDetail() {
    showPage('community-detail');
}

function goBackToCommunityHome() {
    showPage('community-home');
}

function showCommunityEvents() {
    console.log('Showing community events...');
}

function showCommunityMembers() {
    showPage('community-members');
}

function createCommunityEvent() {
    showPage('create-event');
}

function manageCommunityMembers() {
    showPage('community-members');
}

function viewCommunityRegistrations() {
    console.log('Viewing community registrations...');
}

function viewCommunityDashboard() {
    showPage('community-dashboard');
}

function loadAdminApplications(status) {
    console.log('Loading admin applications with status:', status);
}

function selectApprovalTab(status) {
    console.log('Selecting approval tab:', status);
}

function handleLogout() {
    console.log('Logging out...');
}

document.addEventListener('DOMContentLoaded', async function() {
    const loadingIndicator = document.createElement('div');
    loadingIndicator.id = 'loadingIndicator';
    loadingIndicator.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(255, 255, 255, 0.9);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    `;
    loadingIndicator.innerHTML = `
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <p class="mt-4 text-gray-600">Loading pages...</p>
    `;
    document.body.appendChild(loadingIndicator);
    
    const sidebarLinks = document.querySelectorAll('.sidebar .nav-link');
    sidebarLinks.forEach(link => {
        link.style.pointerEvents = 'none';
        link.style.opacity = '0.5';
    });
    
    const pages = ['home', 'home-new', 'communities', 'community-detail', 'create-community', 
                   'community-members', 'community-home', 'community-dashboard', 
                   'events', 'event-detail', 'create-event', 'registrations', 
                   'users', 'categories', 'create-category', 'dashboard', 
                   'applications', 'community-approvals', 'profile'];
    
    try {
        await Promise.all(pages.map(page => loadPage(page)));
        isInitialized = true;
        
        sidebarLinks.forEach(link => {
            link.style.pointerEvents = 'auto';
            link.style.opacity = '1';
        });
        
        document.getElementById('page-home').classList.add('active');
        loadingIndicator.remove();
    } catch (error) {
        console.error('Error initializing pages:', error);
        loadingIndicator.innerHTML = `
            <div class="text-danger">Failed to load pages</div>
            <p class="mt-4 text-gray-600">Please check console for details</p>
        `;
    }
});

window.addEventListener('resize', function() {
    Object.keys(charts).forEach(key => {
        charts[key]?.resize();
    });
});