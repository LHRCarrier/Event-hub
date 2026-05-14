-- =====================================================
-- EventHub v2.0 数据库迁移脚本
-- 从 v1.0 迁移到社区模块化版本
-- 执行日期: 2026-05-13
-- =====================================================

-- 使用 eventhub 数据库
USE eventhub;

-- =====================================================
-- 第一部分：创建新数据表
-- =====================================================

-- -----------------------------------------------------
-- 1. 社区加入申请表 (community_applications)
-- 用于存储用户申请加入社区的记录
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    community_id INT NOT NULL,
    user_id INT NOT NULL,
    message VARCHAR(255) DEFAULT NULL COMMENT '申请留言',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING-待审批 APPROVED-已批准 REJECTED-已拒绝',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    approve_time DATETIME DEFAULT NULL COMMENT '审批时间',
    approve_by INT DEFAULT NULL COMMENT '审批人ID',
    reject_reason VARCHAR(255) DEFAULT NULL COMMENT '拒绝原因',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    -- 外键约束
    CONSTRAINT fk_application_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_user FOREIGN KEY (user_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_approver FOREIGN KEY (approve_by)
        REFERENCES users(user_id) ON DELETE SET NULL,

    -- 索引
    INDEX idx_community_status (community_id, status),
    INDEX idx_user_status (user_id, status),
    INDEX idx_apply_time (apply_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区加入申请表';

-- -----------------------------------------------------
-- 2. 社区创建申请表 (community_create_applications)
-- 用于存储用户申请创建新社区的记录
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_create_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '申请的社区名称',
    description TEXT DEFAULT NULL COMMENT '社区描述',
    logo_url VARCHAR(255) DEFAULT NULL COMMENT '社区Logo URL',
    applicant_id INT NOT NULL COMMENT '申请人ID',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING-待审批 APPROVED-已批准 REJECTED-已拒绝',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    approve_time DATETIME DEFAULT NULL COMMENT '审批时间',
    approve_by INT DEFAULT NULL COMMENT '审批人ID',
    reject_reason VARCHAR(255) DEFAULT NULL COMMENT '拒绝原因',
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    -- 外键约束
    CONSTRAINT fk_create_applicant FOREIGN KEY (applicant_id)
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_create_approver FOREIGN KEY (approve_by)
        REFERENCES users(user_id) ON DELETE SET NULL,

    -- 索引
    UNIQUE KEY uk_name (name),
    INDEX idx_applicant_status (applicant_id, status),
    INDEX idx_status (status),
    INDEX idx_apply_time (apply_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区创建申请表';

-- -----------------------------------------------------
-- 3. 社区分类表 (community_categories)
-- 用于社区专属的分类管理
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS community_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    community_id INT NOT NULL COMMENT '所属社区ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    -- 外键约束
    CONSTRAINT fk_cc_community FOREIGN KEY (community_id)
        REFERENCES communities(community_id) ON DELETE CASCADE,

    -- 索引
    INDEX idx_community (community_id),
    UNIQUE KEY uk_community_name (community_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='社区分类表';

-- -----------------------------------------------------
-- 4. 操作日志表 (operation_logs)
-- 用于记录关键操作，便于审计和问题排查
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS operation_logs (
    log_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id INT DEFAULT NULL COMMENT '操作用户ID',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    target_type VARCHAR(50) NOT NULL COMMENT '目标类型，如COMMUNITY/EVENT/MEMBER',
    target_id INT DEFAULT NULL COMMENT '目标ID',
    operation_detail TEXT DEFAULT NULL COMMENT '操作详情',
    ip_address VARCHAR(45) DEFAULT NULL COMMENT 'IP地址',
    user_agent VARCHAR(255) DEFAULT NULL COMMENT '用户代理',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- 索引
    INDEX idx_user (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_target (target_type, target_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='操作日志表';

-- =====================================================
-- 第二部分：修改现有数据表
-- =====================================================

-- -----------------------------------------------------
-- 1. 修改 communities 表
-- 添加 require_approval 字段控制加入是否需要审核
-- -----------------------------------------------------
ALTER TABLE communities
ADD COLUMN require_approval BOOLEAN NOT NULL DEFAULT TRUE
COMMENT '加入社区是否需要审核 TRUE-需要 FALSE-直接加入'
AFTER description;

-- 添加社区创建者字段
ALTER TABLE communities
ADD COLUMN creator_id INT DEFAULT NULL
COMMENT '社区创建者ID'
AFTER require_approval;

-- 添加社区设置JSON字段（用于存储灵活的社区配置）
ALTER TABLE communities
ADD COLUMN settings JSON DEFAULT NULL
COMMENT '社区设置配置'
AFTER creator_id;

-- 添加统计字段缓存（避免频繁 COUNT 查询）
ALTER TABLE communities
ADD COLUMN member_count INT NOT NULL DEFAULT 0
COMMENT '成员数量缓存'
AFTER settings;

ALTER TABLE communities
ADD COLUMN event_count INT NOT NULL DEFAULT 0
COMMENT '事件数量缓存'
AFTER member_count;

-- 添加外键约束
ALTER TABLE communities
ADD CONSTRAINT fk_community_creator FOREIGN KEY (creator_id)
    REFERENCES users(user_id) ON DELETE SET NULL;

-- 添加索引
ALTER TABLE communities
ADD INDEX idx_status (status),
ADD INDEX idx_require_approval (require_approval);

-- -----------------------------------------------------
-- 2. 修改 community_members 表
-- 添加申请时间字段
-- -----------------------------------------------------
ALTER TABLE community_members
ADD COLUMN apply_time DATETIME DEFAULT NULL
COMMENT '申请时间'
AFTER status;

-- 添加申请来源字段
ALTER TABLE community_members
ADD COLUMN source VARCHAR(20) DEFAULT 'APPLICATION'
COMMENT '加入来源：APPLICATION-申请加入 INVITE-邀请 DIRECT-直接加入'
AFTER apply_time;

-- 添加审批相关字段
ALTER TABLE community_members
ADD COLUMN approve_time DATETIME DEFAULT NULL
COMMENT '审批通过时间'
AFTER source;

ALTER TABLE community_members
ADD COLUMN approved_by INT DEFAULT NULL
COMMENT '审批人ID'
AFTER approve_time;

-- 添加外键约束
ALTER TABLE community_members
ADD CONSTRAINT fk_member_approved_by FOREIGN KEY (approved_by)
    REFERENCES users(user_id) ON DELETE SET NULL;

-- 添加备注字段
ALTER TABLE community_members
ADD COLUMN remark VARCHAR(255) DEFAULT NULL
COMMENT '备注信息'
AFTER approved_by;

-- 添加索引
ALTER TABLE community_members
ADD INDEX idx_user_id (user_id),
ADD INDEX idx_role (role),
ADD INDEX idx_apply_time (apply_time);

-- -----------------------------------------------------
-- 3. 修改 events 表
-- 添加更多事件管理字段
-- -----------------------------------------------------
-- 添加创建者字段
ALTER TABLE events
ADD COLUMN creator_id INT DEFAULT NULL
COMMENT '事件创建者ID'
AFTER community_id;

-- 添加最大参与人数
ALTER TABLE events
ADD COLUMN max_participants INT DEFAULT NULL
COMMENT '最大参与人数，NULL表示无限制'
AFTER status;

-- 添加报名截止时间
ALTER TABLE events
ADD COLUMN registration_deadline DATETIME DEFAULT NULL
COMMENT '报名截止时间'
AFTER max_participants;

-- 添加事件地点详细信息
ALTER TABLE events
ADD COLUMN location_detail VARCHAR(500) DEFAULT NULL
COMMENT '详细地点描述'
AFTER location;

-- 添加事件封面图片
ALTER TABLE events
ADD COLUMN cover_image VARCHAR(255) DEFAULT NULL
COMMENT '事件封面图片URL'
AFTER location_detail;

-- 添加点击量统计
ALTER TABLE events
ADD COLUMN view_count INT NOT NULL DEFAULT 0
COMMENT '浏览次数'
AFTER cover_image;

-- 添加收藏数统计
ALTER TABLE events
ADD COLUMN favorite_count INT NOT NULL DEFAULT 0
COMMENT '收藏次数'
AFTER view_count;

-- 添加外键约束
ALTER TABLE events
ADD CONSTRAINT fk_event_creator FOREIGN KEY (creator_id)
    REFERENCES users(user_id) ON DELETE SET NULL;

-- 添加索引
ALTER TABLE events
ADD INDEX idx_community_id (community_id),
ADD INDEX idx_date (date),
ADD INDEX idx_status (status),
ADD INDEX idx_category_id (category_id);

-- -----------------------------------------------------
-- 4. 修改 registrations 表
-- 添加更多注册管理字段
-- -----------------------------------------------------
-- 添加取消时间
ALTER TABLE registrations
ADD COLUMN cancel_time DATETIME DEFAULT NULL
COMMENT '取消时间'
AFTER status;

-- 添加取消原因
ALTER TABLE registrations
ADD COLUMN cancel_reason VARCHAR(255) DEFAULT NULL
COMMENT '取消原因'
AFTER cancel_time;

-- 添加签到时间
ALTER TABLE registrations
ADD COLUMN checkin_time DATETIME DEFAULT NULL
COMMENT '签到时间'
AFTER cancel_reason;

-- 添加签到码
ALTER TABLE registrations
ADD COLUMN checkin_code VARCHAR(20) DEFAULT NULL
COMMENT '签到码'
AFTER checkin_time;

-- 添加报名来源
ALTER TABLE registrations
ADD COLUMN source VARCHAR(20) DEFAULT 'WEB'
COMMENT '报名来源：WEB-网站 APP-手机APP WECHAT-微信'
AFTER checkin_code;

-- 添加备注
ALTER TABLE registrations
ADD COLUMN remark VARCHAR(255) DEFAULT NULL
COMMENT '备注信息'
AFTER source;

-- 添加索引
ALTER TABLE registrations
ADD INDEX idx_user_id (user_id),
ADD INDEX idx_event_id (event_id),
ADD INDEX idx_status (status),
ADD INDEX idx_register_time (register_time);

-- -----------------------------------------------------
-- 5. 修改 users 表
-- 添加用户扩展字段
-- -----------------------------------------------------
-- 添加用户头像
ALTER TABLE users
ADD COLUMN avatar_url VARCHAR(255) DEFAULT NULL
COMMENT '用户头像URL'
AFTER real_name;

-- 添加用户简介
ALTER TABLE users
ADD COLUMN bio VARCHAR(500) DEFAULT NULL
COMMENT '用户简介'
AFTER avatar_url;

-- 添加最后登录时间
ALTER TABLE users
ADD COLUMN last_login_time DATETIME DEFAULT NULL
COMMENT '最后登录时间'
AFTER bio;

-- 添加最后登录IP
ALTER TABLE users
ADD COLUMN last_login_ip VARCHAR(45) DEFAULT NULL
COMMENT '最后登录IP'
AFTER last_login_time;

-- 添加用户来源
ALTER TABLE users
ADD COLUMN source VARCHAR(20) DEFAULT 'WEB'
COMMENT '注册来源：WEB-网站 APP-手机APP WECHAT-微信'
AFTER last_login_ip;

-- 添加积分字段（可用于未来扩展）
ALTER TABLE users
ADD COLUMN points INT NOT NULL DEFAULT 0
COMMENT '用户积分'
AFTER source;

-- 添加索引
ALTER TABLE users
ADD INDEX idx_email (email),
ADD INDEX idx_status (status),
ADD INDEX idx_create_time (create_time);

-- -----------------------------------------------------
-- 6. 修改 categories 表
-- 添加分类扩展字段
-- -----------------------------------------------------
-- 添加父分类ID（支持二级分类）
ALTER TABLE categories
ADD COLUMN parent_id INT DEFAULT NULL
COMMENT '父分类ID，NULL表示顶级分类'
AFTER description;

-- 添加排序顺序
ALTER TABLE categories
ADD COLUMN sort_order INT DEFAULT 0
COMMENT '排序顺序'
AFTER parent_id;

-- 添加分类图标
ALTER TABLE categories
ADD COLUMN icon_url VARCHAR(255) DEFAULT NULL
COMMENT '分类图标URL'
AFTER sort_order;

-- 添加分类颜色
ALTER TABLE categories
ADD COLUMN color VARCHAR(7) DEFAULT '#1890ff'
COMMENT '分类颜色（十六进制）'
AFTER icon_url;

-- 添加外键约束
ALTER TABLE categories
ADD CONSTRAINT fk_category_parent FOREIGN KEY (parent_id)
    REFERENCES categories(category_id) ON DELETE SET NULL;

-- 添加索引
ALTER TABLE categories
ADD INDEX idx_parent_id (parent_id),
ADD INDEX idx_sort_order (sort_order);

-- =====================================================
-- 第三部分：数据迁移
-- =====================================================

-- -----------------------------------------------------
-- 1. 迁移现有社区成员数据
-- 将 join_time 设置为 apply_time
-- 将 source 设置为 DIRECT（直接加入）
-- -----------------------------------------------------
UPDATE community_members
SET apply_time = join_time,
    source = 'DIRECT'
WHERE apply_time IS NULL;

-- 迁移现有社区创建者的 member_id=1 的 admin 用户为创建者
UPDATE communities c
SET c.creator_id = (
    SELECT cm.user_id
    FROM community_members cm
    WHERE cm.community_id = c.community_id
    AND cm.role = 'ADMIN'
    ORDER BY cm.join_time ASC
    LIMIT 1
)
WHERE c.creator_id IS NULL;

-- -----------------------------------------------------
-- 2. 初始化社区统计字段
-- 更新现有社区的 member_count 和 event_count
-- -----------------------------------------------------
UPDATE communities c
SET c.member_count = (
    SELECT COUNT(*)
    FROM community_members cm
    WHERE cm.community_id = c.community_id
    AND cm.status = 'ACTIVE'
)
WHERE c.member_count = 0;

UPDATE communities c
SET c.event_count = (
    SELECT COUNT(*)
    FROM events e
    WHERE e.community_id = c.community_id
)
WHERE c.event_count = 0;

-- -----------------------------------------------------
-- 3. 创建默认社区分类
-- 为现有社区创建默认分类
-- -----------------------------------------------------
INSERT INTO community_categories (community_id, name, description, sort_order)
SELECT community_id, '默认分类', '社区默认分类', 0
FROM communities
WHERE NOT EXISTS (
    SELECT 1 FROM community_categories cc
    WHERE cc.community_id = communities.community_id
    LIMIT 1
);

-- -----------------------------------------------------
-- 4. 记录迁移日志
-- -----------------------------------------------------
INSERT INTO operation_logs (user_id, operation_type, target_type, target_id, operation_detail, create_time)
VALUES (1, 'MIGRATION', 'DATABASE', NULL, 'v1.0 到 v2.0 数据库迁移完成', NOW());

-- =====================================================
-- 第四部分：创建视图（简化常见查询）
-- =====================================================

-- -----------------------------------------------------
-- 1. 社区详情视图
-- 包含社区信息、成员数、事件数、创建者信息
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
-- 包含成员信息、用户信息、社区信息
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
-- 管理员可快速查看所有待审批申请
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_pending_applications AS
SELECT
    'JOIN' AS application_type,
    ca.application_id,
    ca.community_id,
    ca.user_id,
    ca.status,
    ca.apply_time,
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
    cca.name AS community_name,
    u.username AS applicant_name
FROM community_create_applications cca
JOIN users u ON cca.applicant_id = u.user_id
WHERE cca.status = 'PENDING';

-- -----------------------------------------------------
-- 4. 事件详情视图
-- 包含事件信息、分类名称、社区名称、注册统计
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
-- 包含注册信息、用户信息、事件信息
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

-- =====================================================
-- 第五部分：创建存储过程（常用业务逻辑）
-- =====================================================

-- -----------------------------------------------------
-- 1. 更新社区统计数据的存储过程
-- -----------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_update_community_stats(IN p_community_id INT)
BEGIN
    DECLARE v_member_count INT;
    DECLARE v_event_count INT;

    -- 统计成员数量
    SELECT COUNT(*) INTO v_member_count
    FROM community_members
    WHERE community_id = p_community_id AND status = 'ACTIVE';

    -- 统计事件数量
    SELECT COUNT(*) INTO v_event_count
    FROM events
    WHERE community_id = p_community_id;

    -- 更新社区统计字段
    UPDATE communities
    SET member_count = v_member_count,
        event_count = v_event_count,
        update_time = CURRENT_TIMESTAMP
    WHERE community_id = p_community_id;
END //

DELIMITER ;

-- -----------------------------------------------------
-- 2. 更新事件注册统计的存储过程
-- -----------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_update_event_stats(IN p_event_id INT)
BEGIN
    DECLARE v_registration_count INT;

    SELECT COUNT(*) INTO v_registration_count
    FROM registrations
    WHERE event_id = p_event_id AND status = 'REGISTERED';

    -- 注意：events表没有直接存储注册数缓存字段
    -- 如果需要可以在这里添加，或者在应用层处理
END //

DELIMITER ;

-- =====================================================
-- 第六部分：验证迁移结果
-- =====================================================

-- 验证表结构
SELECT '验证数据表结构...' AS Step;

SELECT TABLE_NAME, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'eventhub'
AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- 验证外键
SELECT '验证外键约束...' AS Step;

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'eventhub'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 验证视图
SELECT '验证视图创建...' AS Step;

SELECT TABLE_NAME AS ViewName
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'eventhub';

-- 验证存储过程
SELECT '验证存储过程创建...' AS Step;

SELECT ROUTINE_NAME
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'eventhub'
AND ROUTINE_TYPE = 'PROCEDURE';

-- 验证数据迁移
SELECT '验证数据迁移结果...' AS Step;

SELECT
    'communities' AS table_name,
    COUNT(*) AS total_count,
    SUM(CASE WHEN member_count > 0 THEN 1 ELSE 0 END) AS with_members
FROM communities
UNION ALL
SELECT
    'community_members' AS table_name,
    COUNT(*) AS total_count,
    SUM(CASE WHEN apply_time IS NOT NULL THEN 1 ELSE 0 END) AS migrated
FROM community_members
UNION ALL
SELECT
    'events' AS table_name,
    COUNT(*) AS total_count,
    SUM(CASE WHEN community_id IS NOT NULL THEN 1 ELSE 0 END) AS with_community
FROM events;

-- =====================================================
-- 迁移完成
-- =====================================================

SELECT '========================================' AS '';
SELECT '   EventHub v2.0 数据库迁移完成！      ' AS '';
SELECT '========================================' AS '';
SELECT '迁移时间: 2026-05-13' AS '';
SELECT '' AS '';

-- 回滚脚本（如果需要回滚，执行以下命令）
-- 注意：回滚前请先备份数据！
/*
-- 删除新增的表
DROP TABLE IF EXISTS operation_logs;
DROP TABLE IF EXISTS community_categories;
DROP TABLE IF EXISTS community_create_applications;
DROP TABLE IF EXISTS community_applications;

-- 删除新增的字段
ALTER TABLE users DROP COLUMN IF EXISTS points;
ALTER TABLE users DROP COLUMN IF EXISTS source;
ALTER TABLE users DROP COLUMN IF EXISTS last_login_ip;
ALTER TABLE users DROP COLUMN IF EXISTS last_login_time;
ALTER TABLE users DROP COLUMN IF EXISTS bio;
ALTER TABLE users DROP COLUMN IF EXISTS avatar_url;

ALTER TABLE categories DROP COLUMN IF EXISTS color;
ALTER TABLE categories DROP COLUMN IF EXISTS icon_url;
ALTER TABLE categories DROP COLUMN IF EXISTS sort_order;
ALTER TABLE categories DROP COLUMN IF EXISTS parent_id;

ALTER TABLE registrations DROP COLUMN IF EXISTS remark;
ALTER TABLE registrations DROP COLUMN IF EXISTS source;
ALTER TABLE registrations DROP COLUMN IF EXISTS checkin_code;
ALTER TABLE registrations DROP COLUMN IF EXISTS checkin_time;
ALTER TABLE registrations DROP COLUMN IF EXISTS cancel_reason;
ALTER TABLE registrations DROP COLUMN IF EXISTS cancel_time;

ALTER TABLE events DROP COLUMN IF EXISTS favorite_count;
ALTER TABLE events DROP COLUMN IF EXISTS view_count;
ALTER TABLE events DROP COLUMN IF EXISTS cover_image;
ALTER TABLE events DROP COLUMN IF EXISTS location_detail;
ALTER TABLE events DROP COLUMN IF EXISTS registration_deadline;
ALTER TABLE events DROP COLUMN IF EXISTS max_participants;
ALTER TABLE events DROP COLUMN IF EXISTS creator_id;

ALTER TABLE community_members DROP COLUMN IF EXISTS remark;
ALTER TABLE community_members DROP COLUMN IF EXISTS approved_by;
ALTER TABLE community_members DROP COLUMN IF EXISTS approve_time;
ALTER TABLE community_members DROP COLUMN IF EXISTS source;
ALTER TABLE community_members DROP COLUMN IF EXISTS apply_time;

ALTER TABLE communities DROP COLUMN IF EXISTS event_count;
ALTER TABLE communities DROP COLUMN IF EXISTS member_count;
ALTER TABLE communities DROP COLUMN IF EXISTS settings;
ALTER TABLE communities DROP COLUMN IF EXISTS creator_id;
ALTER TABLE communities DROP COLUMN IF EXISTS require_approval;
*/