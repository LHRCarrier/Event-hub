-- =====================================================
-- EventHub v2.0 数据库完整脚本
-- 社区模块化版本
-- 创建日期: 2026-05-13
-- =====================================================

-- -----------------------------------------------------
-- 创建数据库
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS eventhub
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE eventhub;

-- =====================================================
-- 第一部分：核心数据表
-- =====================================================

-- -----------------------------------------------------
-- 1. 用户表 (users)
-- 存储系统用户信息
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    real_name VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    avatar_url VARCHAR(255) DEFAULT NULL COMMENT '用户头像URL',
    bio VARCHAR(500) DEFAULT NULL COMMENT '用户简介',
    role VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色：USER-普通用户 ADMIN-系统管理员',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-正常 INACTIVE-停用',
    points INT NOT NULL DEFAULT 0 COMMENT '用户积分',
    source VARCHAR(20) DEFAULT 'WEB' COMMENT '注册来源：WEB-网站 APP-手机APP WECHAT-微信',
    last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) DEFAULT NULL COMMENT '最后登录IP',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    INDEX idx_email (email),
    INDEX idx_status (status),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='用户表';

-- -----------------------------------------------------
-- 2. 分类表 (categories)
-- 支持二级分类的事件分类
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    parent_id INT DEFAULT NULL COMMENT '父分类ID，NULL表示顶级分类',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    icon_url VARCHAR(255) DEFAULT NULL COMMENT '分类图标URL',
    color VARCHAR(7) DEFAULT '#1890ff' COMMENT '分类颜色',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    CONSTRAINT fk_category_parent FOREIGN KEY (parent_id)
        REFERENCES categories(category_id) ON DELETE SET NULL,

    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='分类表';

-- -----------------------------------------------------
-- 3. 社区表 (communities)
-- 社区信息
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS communities (
    community_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE COMMENT '社区名称',
    description TEXT DEFAULT NULL COMMENT '社区描述',
    logo_url VARCHAR(255) DEFAULT NULL COMMENT '社区Logo URL',
    require_approval BOOLEAN NOT NULL DEFAULT TRUE COMMENT '加入是否需要审核',
    creator_id INT DEFAULT NULL COMMENT '创建者ID',
    settings JSON DEFAULT NULL COMMENT '社区设置配置',
    member_count INT NOT NULL DEFAULT 0 COMMENT '成员数量缓存',
    event_count INT NOT NULL DEFAULT 0 COMMENT '事件数量缓存',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-正常 INACTIVE-停用 PENDING-待审核',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    CONSTRAINT fk_community_creator FOREIGN KEY (creator_id)
        REFERENCES users(user_id) ON DELETE SET NULL,

    INDEX idx_status (status),
    INDEX idx_require_approval (require_approval)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区表';

-- -----------------------------------------------------
-- 4. 社区成员表 (community_members)
-- 用户与社区的关系
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    community_id INT NOT NULL COMMENT '社区ID',
    user_id INT NOT NULL COMMENT '用户ID',
    role VARCHAR(20) NOT NULL DEFAULT 'MEMBER' COMMENT '角色：ADMIN-管理员 MEMBER-成员',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-正常 INACTIVE-已退出',
    source VARCHAR(20) DEFAULT 'APPLICATION' COMMENT '加入来源：APPLICATION-申请加入 INVITE-邀请 DIRECT-直接加入',
    apply_time DATETIME DEFAULT NULL COMMENT '申请时间',
    approve_time DATETIME DEFAULT NULL COMMENT '审批通过时间',
    approved_by INT DEFAULT NULL COMMENT '审批人ID',
    join_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注信息',

    CONSTRAINT fk_member_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE CASCADE,
    CONSTRAINT fk_member_user FOREIGN KEY (user_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_member_approved_by FOREIGN KEY (approved_by)
        REFERENCES users(user_id) ON DELETE SET NULL,

    UNIQUE KEY unique_member (community_id, user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role (role),
    INDEX idx_apply_time (apply_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区成员表';

-- -----------------------------------------------------
-- 5. 社区加入申请表 (community_applications)
-- 用户申请加入社区的记录
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    community_id INT NOT NULL COMMENT '社区ID',
    user_id INT NOT NULL COMMENT '申请人ID',
    message VARCHAR(255) DEFAULT NULL COMMENT '申请留言',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待审批 APPROVED-已批准 REJECTED-已拒绝',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    approve_time DATETIME DEFAULT NULL COMMENT '审批时间',
    approve_by INT DEFAULT NULL COMMENT '审批人ID',
    reject_reason VARCHAR(255) DEFAULT NULL COMMENT '拒绝原因',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    CONSTRAINT fk_application_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_user FOREIGN KEY (user_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_approver FOREIGN KEY (approve_by)
        REFERENCES users(user_id) ON DELETE SET NULL,

    INDEX idx_community_status (community_id, status),
    INDEX idx_user_status (user_id, status),
    INDEX idx_apply_time (apply_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区加入申请表';

-- -----------------------------------------------------
-- 6. 社区创建申请表 (community_create_applications)
-- 用户申请创建新社区的记录
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_create_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '申请的社区名称',
    description TEXT DEFAULT NULL COMMENT '社区描述',
    logo_url VARCHAR(255) DEFAULT NULL COMMENT '社区Logo URL',
    applicant_id INT NOT NULL COMMENT '申请人ID',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待审批 APPROVED-已批准 REJECTED-已拒绝',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    approve_time DATETIME DEFAULT NULL COMMENT '审批时间',
    approve_by INT DEFAULT NULL COMMENT '审批人ID',
    reject_reason VARCHAR(255) DEFAULT NULL COMMENT '拒绝原因',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    CONSTRAINT fk_create_applicant FOREIGN KEY (applicant_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_create_approver FOREIGN KEY (approve_by)
        REFERENCES users(user_id) ON DELETE SET NULL,

    UNIQUE KEY uk_name (name),
    INDEX idx_applicant_status (applicant_id, status),
    INDEX idx_status (status),
    INDEX idx_apply_time (apply_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区创建申请表';

-- -----------------------------------------------------
-- 7. 社区分类表 (community_categories)
-- 社区专属的分类管理
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    community_id INT NOT NULL COMMENT '所属社区ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    CONSTRAINT fk_cc_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE CASCADE,

    INDEX idx_community (community_id),
    UNIQUE KEY uk_community_name (community_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区分类表';

-- -----------------------------------------------------
-- 8. 事件表 (events)
-- 社区活动信息
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '事件名称',
    date DATETIME NOT NULL COMMENT '事件日期时间',
    location VARCHAR(200) NOT NULL COMMENT '事件地点',
    location_detail VARCHAR(500) DEFAULT NULL COMMENT '详细地点描述',
    description TEXT DEFAULT NULL COMMENT '事件描述',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '事件封面图片URL',
    category_id INT DEFAULT NULL COMMENT '分类ID',
    community_id INT DEFAULT NULL COMMENT '所属社区ID，NULL表示全局活动',
    creator_id INT DEFAULT NULL COMMENT '创建者ID',
    status VARCHAR(20) NOT NULL DEFAULT 'UPCOMING' COMMENT '状态：UPCOMING-即将发生 ONGOING-进行中 ENDED-已结束 CANCELLED-已取消',
    max_participants INT DEFAULT NULL COMMENT '最大参与人数，NULL表示无限制',
    registration_deadline DATETIME DEFAULT NULL COMMENT '报名截止时间',
    view_count INT NOT NULL DEFAULT 0 COMMENT '浏览次数',
    favorite_count INT NOT NULL DEFAULT 0 COMMENT '收藏次数',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    CONSTRAINT fk_event_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id) ON DELETE SET NULL,
    CONSTRAINT fk_event_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE SET NULL,
    CONSTRAINT fk_event_creator FOREIGN KEY (creator_id)
        REFERENCES users(user_id) ON DELETE SET NULL,

    INDEX idx_community_id (community_id),
    INDEX idx_date (date),
    INDEX idx_status (status),
    INDEX idx_category_id (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='事件表';

-- -----------------------------------------------------
-- 9. 活动注册表 (registrations)
-- 用户报名参加活动的记录
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL COMMENT '事件ID',
    user_id INT NOT NULL COMMENT '用户ID',
    status VARCHAR(20) NOT NULL DEFAULT 'REGISTERED' COMMENT '状态：REGISTERED-已注册 ATTENDED-已出席 CANCELLED-已取消',
    source VARCHAR(20) DEFAULT 'WEB' COMMENT '报名来源：WEB-网站 APP-手机APP WECHAT-微信',
    checkin_code VARCHAR(20) DEFAULT NULL COMMENT '签到码',
    checkin_time DATETIME DEFAULT NULL COMMENT '签到时间',
    cancel_time DATETIME DEFAULT NULL COMMENT '取消时间',
    cancel_reason VARCHAR(255) DEFAULT NULL COMMENT '取消原因',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注信息',
    register_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',

    CONSTRAINT fk_registration_event FOREIGN KEY (event_id)
        REFERENCES events(event_id) ON DELETE CASCADE,
    CONSTRAINT fk_registration_user FOREIGN KEY (user_id)
        REFERENCES users(user_id) ON DELETE CASCADE,

    UNIQUE KEY unique_registration (event_id, user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_event_id (event_id),
    INDEX idx_status (status),
    INDEX idx_register_time (register_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='活动注册表';

-- -----------------------------------------------------
-- 10. 操作日志表 (operation_logs)
-- 记录关键操作，便于审计
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS operation_logs (
    log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT DEFAULT NULL COMMENT '操作用户ID',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    target_type VARCHAR(50) NOT NULL COMMENT '目标类型',
    target_id INT DEFAULT NULL COMMENT '目标ID',
    operation_detail TEXT DEFAULT NULL COMMENT '操作详情',
    ip_address VARCHAR(45) DEFAULT NULL COMMENT 'IP地址',
    user_agent VARCHAR(255) DEFAULT NULL COMMENT '用户代理',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',

    INDEX idx_user (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_target (target_type, target_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='操作日志表';

-- =====================================================
-- 第二部分：初始化数据
-- =====================================================

-- -----------------------------------------------------
-- 1. 创建默认管理员账号
-- 用户名: admin
-- 密码: admin123 (BCrypt加密)
-- -----------------------------------------------------
INSERT INTO users (username, password, email, role, status, source, create_time) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjzqAKL9xL5jvMFVdNJHvGCgTq/VEq', 'admin@eventhub.com', 'ADMIN', 'ACTIVE', 'SYSTEM', NOW());

-- -----------------------------------------------------
-- 2. 创建测试用户账号
-- -----------------------------------------------------
INSERT INTO users (username, password, email, real_name, role, status, source, create_time) VALUES
('testuser', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjzqAKL9xL5jvMFVdNJHvGCgTq/VEq', 'test@eventhub.com', '测试用户', 'USER', 'ACTIVE', 'WEB', NOW());

-- -----------------------------------------------------
-- 3. 创建系统分类（顶层分类）
-- -----------------------------------------------------
INSERT INTO categories (name, description, sort_order, color, create_time) VALUES
('Tech', 'Technology workshops & talks', 1, '#1890ff', NOW()),
('Sports', 'Sports activities & games', 2, '#52c41a', NOW()),
('Cultural', 'Cultural events & festivals', 3, '#722ed1', NOW()),
('Art', 'Art exhibitions & workshops', 4, '#eb2f96', NOW()),
('Workshop', 'Educational workshops', 5, '#fa8c16', NOW()),
('Music', 'Music events & concerts', 6, '#13c2c2', NOW()),
('Food', 'Food festivals & tasting events', 7, '#faad14', NOW()),
('Community', 'Community gatherings', 8, '#8c8c8c', NOW());

-- -----------------------------------------------------
-- 4. 创建子分类示例（技术分类的子分类）
-- -----------------------------------------------------
INSERT INTO categories (name, description, parent_id, sort_order, color, create_time) VALUES
('AI & Machine Learning', 'Artificial Intelligence and ML topics', 1, 1, '#1890ff', NOW()),
('Web Development', 'Web and frontend development', 1, 2, '#1890ff', NOW()),
('Mobile Development', 'iOS, Android and mobile topics', 1, 3, '#1890ff', NOW());

-- -----------------------------------------------------
-- 5. 创建示例社区（需要审核才能加入）
-- -----------------------------------------------------
INSERT INTO communities (name, description, require_approval, creator_id, member_count, event_count, status, create_time) VALUES
('Tech Community', 'Technology enthusiasts community for sharing knowledge and networking', TRUE, 1, 0, 0, 'ACTIVE', NOW()),
('Sports Club', 'Sports and fitness enthusiasts group', TRUE, 1, 0, 0, 'ACTIVE', NOW()),
('Art Society', 'Art lovers and creators community', TRUE, 1, 0, 0, 'ACTIVE', NOW()),
('Music Club', 'Music lovers and musicians community', TRUE, 1, 0, 0, 'ACTIVE', NOW());

-- -----------------------------------------------------
-- 6. 创建社区分类
-- -----------------------------------------------------
INSERT INTO community_categories (community_id, name, description, sort_order) VALUES
(1, '技术交流', '技术话题讨论', 1),
(1, '编程挑战', '代码编程挑战', 2),
(2, '运动比赛', '体育竞技活动', 1),
(2, '健身指导', '健身知识分享', 2),
(3, '艺术展览', '艺术作品展示', 1),
(3, '创作交流', '创作心得分享', 2),
(4, '音乐会', '音乐演出活动', 1),
(4, '音乐教学', '音乐知识分享', 2);

-- -----------------------------------------------------
-- 7. 创建示例事件
-- -----------------------------------------------------
INSERT INTO events (name, date, location, description, category_id, community_id, creator_id, status, create_time) VALUES
('Tech Workshop 2026', '2026-06-15 10:00:00', 'Community Center', 'Learn the latest technologies including cloud computing and AI.', 1, 1, 1, 'UPCOMING', NOW()),
('Sports Day 2026', '2026-06-20 09:00:00', 'City Stadium', 'Annual sports day with various games and competitions.', 2, 2, 1, 'UPCOMING', NOW()),
('Cultural Night', '2026-06-25 18:00:00', 'Town Hall', 'Experience traditional music, dance, and art from around the world.', 3, NULL, 1, 'UPCOMING', NOW()),
('Art Exhibition', '2026-06-30 10:00:00', 'Art Gallery', 'A showcase of local artists finest works.', 4, 3, 1, 'UPCOMING', NOW()),
('Music Festival', '2026-07-10 12:00:00', 'Central Park', 'A day of live music featuring local bands.', 6, 4, 1, 'UPCOMING', NOW()),
('AI Conference', '2026-07-15 09:00:00', 'Convention Center', 'Annual AI conference with industry experts.', 9, 1, 1, 'UPCOMING', NOW());

-- -----------------------------------------------------
-- 8. 创建社区成员（管理员加入自己的社区）
-- -----------------------------------------------------
INSERT INTO community_members (community_id, user_id, role, status, source, approve_time, approved_by, join_time) VALUES
(1, 1, 'ADMIN', 'ACTIVE', 'DIRECT', NOW(), 1, NOW()),
(2, 1, 'ADMIN', 'ACTIVE', 'DIRECT', NOW(), 1, NOW()),
(3, 1, 'ADMIN', 'ACTIVE', 'DIRECT', NOW(), 1, NOW()),
(4, 1, 'ADMIN', 'ACTIVE', 'DIRECT', NOW(), 1, NOW());

-- -----------------------------------------------------
-- 9. 创建活动注册示例
-- -----------------------------------------------------
INSERT INTO registrations (event_id, user_id, status, source, register_time) VALUES
(1, 1, 'REGISTERED', 'WEB', NOW()),
(3, 1, 'REGISTERED', 'WEB', NOW());

-- -----------------------------------------------------
-- 10. 记录初始化日志
-- -----------------------------------------------------
INSERT INTO operation_logs (user_id, operation_type, target_type, target_id, operation_detail, create_time) VALUES
(1, 'INIT', 'DATABASE', NULL, 'EventHub v2.0 数据库初始化完成', NOW());

-- =====================================================
-- 第三部分：创建视图（简化常见查询）
-- =====================================================

-- -----------------------------------------------------
-- 1. 社区详情视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_community_details AS
SELECT
    c.community_id,
    c.name,
    c.description,
    c.logo_url,
    c.status,
    c.require_approval,
    c.member_count,
    c.event_count,
    c.create_time,
    u.username AS creator_name,
    u.user_id AS creator_id
FROM communities c
LEFT JOIN users u ON c.creator_id = u.user_id;

-- -----------------------------------------------------
-- 2. 社区成员详情视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_community_members_detail AS
SELECT
    cm.member_id,
    cm.community_id,
    cm.user_id,
    cm.role,
    cm.status,
    cm.join_time,
    cm.apply_time,
    cm.source,
    u.username,
    u.email,
    u.real_name,
    u.avatar_url,
    c.name AS community_name
FROM community_members cm
JOIN users u ON cm.user_id = u.user_id
JOIN communities c ON cm.community_id = c.community_id;

-- -----------------------------------------------------
-- 3. 待审批申请视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_pending_applications AS
SELECT
    'JOIN' AS application_type,
    ca.application_id,
    ca.community_id,
    ca.user_id,
    ca.status,
    ca.apply_time,
    ca.message,
    c.name AS community_name,
    u.username AS applicant_name
FROM community_applications ca
JOIN communities c ON ca.community_id = c.community_id
JOIN users u ON ca.user_id = u.user_id
WHERE ca.status = 'PENDING'
UNION ALL
SELECT
    'CREATE' AS application_type,
    cca.application_id,
    NULL AS community_id,
    cca.applicant_id AS user_id,
    cca.status,
    cca.apply_time,
    cca.description AS message,
    cca.name AS community_name,
    u.username AS applicant_name
FROM community_create_applications cca
JOIN users u ON cca.applicant_id = u.user_id
WHERE cca.status = 'PENDING';

-- -----------------------------------------------------
-- 4. 事件详情视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_event_details AS
SELECT
    e.event_id,
    e.name,
    e.date,
    e.location,
    e.location_detail,
    e.description,
    e.cover_image,
    e.status,
    e.max_participants,
    e.registration_deadline,
    e.view_count,
    e.favorite_count,
    e.create_time,
    c.category_id,
    c.name AS category_name,
    co.community_id,
    co.name AS community_name,
    co.logo_url AS community_logo,
    u.user_id AS creator_id,
    u.username AS creator_name,
    (SELECT COUNT(*) FROM registrations r WHERE r.event_id = e.event_id AND r.status = 'REGISTERED') AS registration_count
FROM events e
LEFT JOIN categories c ON e.category_id = c.category_id
LEFT JOIN communities co ON e.community_id = co.community_id
LEFT JOIN users u ON e.creator_id = u.user_id;

-- -----------------------------------------------------
-- 5. 用户注册详情视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_registration_details AS
SELECT
    r.registration_id,
    r.event_id,
    r.user_id,
    r.status,
    r.register_time,
    r.cancel_time,
    r.checkin_time,
    r.checkin_code,
    r.source,
    e.name AS event_name,
    e.date AS event_date,
    e.location AS event_location,
    u.username,
    u.email,
    u.real_name,
    u.phone
FROM registrations r
JOIN events e ON r.event_id = e.event_id
JOIN users u ON r.user_id = u.user_id;

-- -----------------------------------------------------
-- 6. 用户社区关系视图
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_user_communities AS
SELECT
    u.user_id,
    u.username,
    u.email,
    c.community_id,
    c.name AS community_name,
    cm.role,
    cm.status AS member_status,
    cm.join_time
FROM users u
JOIN community_members cm ON u.user_id = cm.user_id
JOIN communities c ON cm.community_id = c.community_id
WHERE cm.status = 'ACTIVE' AND c.status = 'ACTIVE';

-- =====================================================
-- 第四部分：创建存储过程
-- =====================================================

DELIMITER //

-- -----------------------------------------------------
-- 1. 更新社区统计数据
-- -----------------------------------------------------
CREATE PROCEDURE sp_update_community_stats(IN p_community_id INT)
BEGIN
    DECLARE v_member_count INT;
    DECLARE v_event_count INT;

    SELECT COUNT(*) INTO v_member_count
    FROM community_members
    WHERE community_id = p_community_id AND status = 'ACTIVE';

    SELECT COUNT(*) INTO v_event_count
    FROM events
    WHERE community_id = p_community_id AND status != 'CANCELLED';

    UPDATE communities
    SET member_count = v_member_count,
        event_count = v_event_count,
        update_time = CURRENT_TIMESTAMP
    WHERE community_id = p_community_id;
END //

-- -----------------------------------------------------
-- 2. 批准加入申请并创建成员记录
-- -----------------------------------------------------
CREATE PROCEDURE sp_approve_join_application(
    IN p_application_id INT,
    IN p_approver_id INT
)
BEGIN
    DECLARE v_community_id INT;
    DECLARE v_user_id INT;

    SELECT community_id, user_id INTO v_community_id, v_user_id
    FROM community_applications
    WHERE application_id = p_application_id AND status = 'PENDING';

    IF v_community_id IS NOT NULL THEN
        INSERT INTO community_members (community_id, user_id, role, status, source, approve_time, approved_by, join_time)
        VALUES (v_community_id, v_user_id, 'MEMBER', 'ACTIVE', 'APPLICATION', NOW(), p_approver_id, NOW());

        UPDATE community_applications
        SET status = 'APPROVED', approve_time = NOW(), approve_by = p_approver_id
        WHERE application_id = p_application_id;

        CALL sp_update_community_stats(v_community_id);
    END IF;
END //

-- -----------------------------------------------------
-- 3. 拒绝加入申请
-- -----------------------------------------------------
CREATE PROCEDURE sp_reject_join_application(
    IN p_application_id INT,
    IN p_approver_id INT,
    IN p_reject_reason VARCHAR(255)
)
BEGIN
    UPDATE community_applications
    SET status = 'REJECTED',
        approve_time = NOW(),
        approve_by = p_approver_id,
        reject_reason = p_reject_reason
    WHERE application_id = p_application_id AND status = 'PENDING';
END //

-- -----------------------------------------------------
-- 4. 批准创建社区申请
-- -----------------------------------------------------
CREATE PROCEDURE sp_approve_create_community(
    IN p_application_id INT,
    IN p_approver_id INT
)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_description TEXT;
    DECLARE v_logo_url VARCHAR(255);
    DECLARE v_applicant_id INT;
    DECLARE v_community_id INT;

    SELECT name, description, logo_url, applicant_id INTO v_name, v_description, v_logo_url, v_applicant_id
    FROM community_create_applications
    WHERE application_id = p_application_id AND status = 'PENDING';

    IF v_name IS NOT NULL THEN
        INSERT INTO communities (name, description, logo_url, require_approval, creator_id, status, create_time)
        VALUES (v_name, v_description, v_logo_url, TRUE, v_applicant_id, 'ACTIVE', NOW());

        SET v_community_id = LAST_INSERT_ID();

        INSERT INTO community_members (community_id, user_id, role, status, source, approve_time, approved_by, join_time)
        VALUES (v_community_id, v_applicant_id, 'ADMIN', 'ACTIVE', 'DIRECT', NOW(), p_approver_id, NOW());

        INSERT INTO community_categories (community_id, name, description, sort_order)
        VALUES (v_community_id, '默认分类', '社区默认分类', 0);

        UPDATE community_create_applications
        SET status = 'APPROVED', approve_time = NOW(), approve_by = p_approver_id
        WHERE application_id = p_application_id;
    END IF;
END //

-- -----------------------------------------------------
-- 5. 拒绝创建社区申请
-- -----------------------------------------------------
CREATE PROCEDURE sp_reject_create_community(
    IN p_application_id INT,
    IN p_approver_id INT,
    IN p_reject_reason VARCHAR(255)
)
BEGIN
    UPDATE community_create_applications
    SET status = 'REJECTED',
        approve_time = NOW(),
        approve_by = p_approver_id,
        reject_reason = p_reject_reason
    WHERE application_id = p_application_id AND status = 'PENDING';
END //

-- -----------------------------------------------------
-- 6. 用户退出社区
-- -----------------------------------------------------
CREATE PROCEDURE sp_leave_community(
    IN p_community_id INT,
    IN p_user_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_is_last_admin INT DEFAULT 0;
    DECLARE v_admin_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_admin_count
    FROM community_members
    WHERE community_id = p_community_id AND role = 'ADMIN' AND status = 'ACTIVE';

    SELECT role INTO @user_role FROM community_members
    WHERE community_id = p_community_id AND user_id = p_user_id AND status = 'ACTIVE';

    IF @user_role = 'ADMIN' AND v_admin_count <= 1 THEN
        SET p_result = 'ERROR_LAST_ADMIN';
    ELSE
        UPDATE community_members
        SET status = 'INACTIVE'
        WHERE community_id = p_community_id AND user_id = p_user_id;

        CALL sp_update_community_stats(p_community_id);
        SET p_result = 'SUCCESS';
    END IF;
END //

DELIMITER ;

-- =====================================================
-- 第五部分：创建函数
-- =====================================================

DELIMITER //

-- -----------------------------------------------------
-- 1. 检查用户是否为社区成员
-- -----------------------------------------------------
CREATE FUNCTION fn_is_community_member(
    p_community_id INT,
    p_user_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM community_members
    WHERE community_id = p_community_id
    AND user_id = p_user_id
    AND status = 'ACTIVE';

    RETURN v_count > 0;
END //

-- -----------------------------------------------------
-- 2. 检查用户是否为社区管理员
-- -----------------------------------------------------
CREATE FUNCTION fn_is_community_admin(
    p_community_id INT,
    p_user_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM community_members
    WHERE community_id = p_community_id
    AND user_id = p_user_id
    AND role = 'ADMIN'
    AND status = 'ACTIVE';

    RETURN v_count > 0;
END //

-- -----------------------------------------------------
-- 3. 获取用户社区角色
-- -----------------------------------------------------
CREATE FUNCTION fn_get_user_community_role(
    p_community_id INT,
    p_user_id INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_role VARCHAR(20) DEFAULT NULL;

    SELECT role INTO v_role
    FROM community_members
    WHERE community_id = p_community_id
    AND user_id = p_user_id
    AND status = 'ACTIVE';

    RETURN v_role;
END //

DELIMITER ;

-- =====================================================
-- 第六部分：验证脚本执行结果
-- =====================================================

SELECT '========================================' AS '';
SELECT '   EventHub v2.0 数据库初始化完成！  ' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';
SELECT '数据库信息:' AS '';
SELECT DATABASE() AS database_name;
SELECT NOW() AS initialization_time;
SELECT '' AS '';
SELECT '数据表列表:' AS '';
SHOW TABLES;
SELECT '' AS '';
SELECT '视图列表:' AS '';
SHOW TABLE STATUS WHERE Comment = 'VIEW';
SELECT '' AS '';
SELECT '存储过程列表:' AS '';
SHOW PROCEDURE STATUS WHERE Db = DATABASE();
SELECT '' AS '';
SELECT '函数列表:' AS '';
SHOW FUNCTION STATUS WHERE Db = DATABASE();
SELECT '' AS '';
SELECT '初始化数据统计:' AS '';
SELECT '用户数' AS item, COUNT(*) AS count FROM users
UNION ALL
SELECT '分类数', COUNT(*) FROM categories
UNION ALL
SELECT '社区数', COUNT(*) FROM communities
UNION ALL
SELECT '社区成员数', COUNT(*) FROM community_members
UNION ALL
SELECT '事件数', COUNT(*) FROM events
UNION ALL
SELECT '注册记录数', COUNT(*) FROM registrations;
SELECT '' AS '';
SELECT '默认管理员账号:' AS '';
SELECT '  用户名: admin' AS '';
SELECT '  密码: admin123 (BCrypt加密)' AS '';
SELECT '' AS '';
SELECT '========================================' AS '';