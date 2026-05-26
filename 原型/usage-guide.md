# EventHub 卡片组件使用指南

## 目录

1. [概述](#1-概述)
2. [组件类型](#2-组件类型)
3. [快速开始](#3-快速开始)
4. [组件API](#4-组件API)
5. [使用示例](#5-使用示例)
6. [自定义配置](#6-自定义配置)
7. [注意事项](#7-注意事项)

---

## 1. 概述

本指南介绍如何在EventHub前端应用中使用统一的毛玻璃效果卡片组件。卡片组件采用模块化设计，支持多种卡片类型，具有统一的视觉样式和交互行为。

### 设计特点

- **毛玻璃效果**: 采用半透明模糊背景，营造轻盈通透的视觉质感
- **优雅交互**: 默认隐藏操作控件，悬浮时优雅呈现
- **响应式设计**: 适配各种屏幕尺寸
- **性能优化**: 使用CSS3硬件加速，避免过度渲染

---

## 2. 组件类型

| 组件类型 | 类名 | 用途 |
|---------|------|-----|
| 统计卡片 | `stat-card` | 展示数据统计信息 |
| 事件卡片 | `event-card` | 展示活动/事件信息 |
| 社区卡片 | `community-card` | 展示社区信息 |
| 列表卡片 | `list-card` | 展示列表项信息 |
| 活动卡片 | `activity-card` | 展示动态活动信息 |

---

## 3. 快速开始

### 3.1 引入依赖

确保页面中已引入以下资源：

```html
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<!-- 自定义样式 -->
<link href="styles.css" rel="stylesheet">

<!-- 组件脚本 -->
<script src="components/card-components.js"></script>
```

### 3.2 模板准备

在页面中添加卡片模板容器：

```html
<div class="card-templates" style="display: none;">
    <template id="stat-card-template">...</template>
    <template id="event-card-template">...</template>
    <template id="community-card-template">...</template>
    <template id="list-card-template">...</template>
    <template id="activity-card-template">...</template>
</div>
```

### 3.3 初始化组件

组件会在DOM加载完成后自动初始化：

```javascript
document.addEventListener('DOMContentLoaded', () => {
    CardComponents.init();
});
```

---

## 4. 组件API

### 4.1 渲染方法

#### `renderStatCard(data)`

渲染统计卡片

**参数**:

| 属性 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| id | string | 是 | 卡片唯一标识 |
| icon | string | 是 | Font Awesome图标类名 |
| value | string/number | 是 | 统计数值 |
| label | string | 是 | 标签文字 |

#### `renderEventCard(data)`

渲染事件卡片

**参数**:

| 属性 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| id | string | 是 | 事件ID |
| title | string | 是 | 事件标题 |
| description | string | 是 | 事件描述 |
| date | string | 是 | 事件日期 |
| location | string | 是 | 事件地点 |
| participants | number | 是 | 参与人数 |
| status | string | 是 | 状态(Upcoming/Active/Past) |

#### `renderCommunityCard(data)`

渲染社区卡片

**参数**:

| 属性 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| id | string | 是 | 社区ID |
| name | string | 是 | 社区名称 |
| description | string | 是 | 社区描述 |
| logoEmoji | string | 是 | Logo表情符号 |
| memberCount | number | 是 | 成员数量 |
| eventCount | number | 是 | 活动数量 |

#### `renderListCard(data)`

渲染列表卡片

**参数**:

| 属性 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| id | string | 是 | 项目ID |
| icon | string | 是 | Font Awesome图标类名 |
| iconType | string | 是 | 图标类型(primary/success/warning/info) |
| title | string | 是 | 标题 |
| description | string | 是 | 描述 |
| meta | string | 否 | 元信息 |

#### `renderActivityCard(data)`

渲染活动卡片

**参数**:

| 属性 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| id | string | 是 | 活动ID |
| icon | string | 是 | Font Awesome图标类名 |
| iconType | string | 是 | 图标类型 |
| title | string | 是 | 标题 |
| description | string | 是 | 描述 |
| time | string | 是 | 时间 |

#### `renderCards(containerId, cards, cardType)`

批量渲染卡片到指定容器

**参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|-----|
| containerId | string | 是 | 容器元素ID |
| cards | array | 是 | 卡片数据数组 |
| cardType | string | 是 | 卡片类型(stat/event/community/list/activity) |

### 4.2 事件处理

#### `handleStatCardAction(cardId, action)`

处理统计卡片操作

**action值**:
- `more`: 显示更多选项

#### `handleEventAction(eventId, action)`

处理事件卡片操作

**action值**:
- `register`: 注册活动
- `share`: 分享活动

#### `handleCommunityAction(communityId, action)`

处理社区卡片操作

**action值**:
- `join`: 加入社区
- `view`: 查看社区

#### `handleListAction(itemId, action)`

处理列表卡片操作

**action值**:
- `edit`: 编辑项目
- `view`: 查看项目
- `delete`: 删除项目

---

## 5. 使用示例

### 5.1 渲染统计卡片

```javascript
const stats = [
    { id: 'stat-1', icon: 'fa-calendar-alt', value: '156', label: 'Upcoming Events' },
    { id: 'stat-2', icon: 'fa-users', value: '2,847', label: 'Participants' },
    { id: 'stat-3', icon: 'fa-user', value: '1,245', label: 'Active Users' },
    { id: 'stat-4', icon: 'fa-tag', value: '24', label: 'Categories' }
];

CardComponents.renderCards('statsContainer', stats, 'stat');
```

### 5.2 渲染事件卡片

```javascript
const events = [
    {
        id: 'event-1',
        title: 'Tech Conference 2024',
        description: 'Join us for the biggest tech conference of the year...',
        date: 'June 15, 2024',
        location: 'Convention Center',
        participants: 450,
        status: 'Upcoming'
    }
];

CardComponents.renderCards('eventsContainer', events, 'event');
```

### 5.3 渲染社区卡片

```javascript
const communities = [
    {
        id: 'comm-1',
        name: 'Tech Club',
        description: 'A community for tech enthusiasts...',
        logoEmoji: '💻',
        memberCount: 156,
        eventCount: 12
    }
];

CardComponents.renderCards('communitiesContainer', communities, 'community');
```

### 5.4 渲染列表卡片

```javascript
const items = [
    {
        id: 'item-1',
        icon: 'fa-user-plus',
        iconType: 'success',
        title: 'New User Registered',
        description: 'John Doe joined EventHub',
        meta: '2 minutes ago'
    }
];

CardComponents.renderCards('listContainer', items, 'list');
```

### 5.5 手动渲染单个卡片

```javascript
const cardHtml = CardComponents.renderEventCard({
    id: 'event-2',
    title: 'Summer Festival',
    description: 'Enjoy music, food, and fun in the sun...',
    date: 'July 20, 2024',
    location: 'Central Park',
    participants: 800,
    status: 'Upcoming'
});

document.getElementById('customContainer').innerHTML = cardHtml;
```

---

## 6. 自定义配置

### 6.1 自定义色彩主题

在CSS中覆盖默认变量：

```css
:root {
    --primary-color: #your-color;
    --primary-light: #your-light-color;
    --primary-dark: #your-dark-color;
    --accent-orange: #your-orange;
    --accent-red: #your-red;
    --accent-green: #your-green;
    --accent-blue: #your-blue;
}
```

### 6.2 自定义卡片样式

```css
.stat-card.custom {
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.8);
}

.event-card.custom .event-banner {
    background: linear-gradient(135deg, #your-color1, #your-color2);
}
```

### 6.3 自定义动画时长

```css
.stat-card {
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
```

---

## 7. 注意事项

### 7.1 浏览器兼容性

| 浏览器 | 版本要求 | 说明 |
|-------|---------|-----|
| Chrome | 76+ | 完全支持 |
| Firefox | 70+ | backdrop-filter需启用flag |
| Safari | 14+ | 完全支持 |
| Edge | 79+ | 完全支持 |

### 7.2 降级方案

对于不支持backdrop-filter的浏览器，组件会自动降级为纯色背景：

```css
@supports not (backdrop-filter: blur(20px)) {
    .glass-effect {
        background: rgba(255, 255, 255, 0.95) !important;
    }
}
```

### 7.3 性能优化建议

1. **限制卡片数量**: 避免在单个页面渲染过多卡片
2. **使用虚拟化**: 对于长列表，考虑使用虚拟滚动
3. **避免嵌套毛玻璃**: 不要在毛玻璃卡片内嵌套另一个毛玻璃元素
4. **启用GPU加速**: 使用`will-change`属性提示浏览器优化

### 7.4 响应式适配

- 在移动端(<768px)，列表卡片的操作按钮始终显示
- 在桌面端，操作按钮仅在悬浮时显示
- 卡片宽度会根据屏幕尺寸自动调整

---

## 附录：图标类型映射

| 类型 | 背景色 | 图标色 | 用途 |
|-----|-------|-------|-----|
| primary | rgba(37, 184, 166, 0.1) | #25B8A6 | 主要操作 |
| success | rgba(126, 217, 87, 0.1) | #7ED957 | 成功状态 |
| warning | rgba(245, 166, 35, 0.1) | #F5A623 | 警告状态 |
| info | rgba(107, 179, 217, 0.1) | #6BB3D9 | 信息提示 |