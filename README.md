# Event Hub

社区活动管理平台，支持用户创建/加入社区、发布/报名活动、社区成员管理、文件上传等功能。

## 技术栈

| 类别 | 技术 |
|------|------|
| 语言 | Java 17 |
| 框架 | Spring Web MVC 6.1.6 (传统 WAR 部署，非 Spring Boot) |
| ORM | MyBatis-Plus 3.5.5 + MyBatis XML Mapper |
| 数据库 | MySQL 8.0 |
| 前端 | JSP/JSTL + ECharts 5.4.3 |
| 安全 | JWT (jjwt 0.12.3) + BCrypt (jbcrypt) |
| 文件存储 | Aliyun OSS |
| 构建 | Maven |
| 部署 | Tomcat 10 (Jakarta EE 9+) |

## 环境要求

| 组件 | 版本要求 |
|------|----------|
| JDK | 17+ |
| Maven | 3.8+ |
| MySQL | 8.0 |
| Tomcat | 10.x |
| 操作系统 | Windows / Linux / macOS |

## 部署指南

### 1. 克隆项目

```bash
git clone <your-repo-url>
cd Event-hub
```

### 2. 初始化数据库

确保 MySQL 服务已启动（默认端口 3305），使用 root 用户登录并创建数据库：

```sql
CREATE DATABASE IF NOT EXISTS eventhub
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
```

项目中的 `schema.sql` 包含完整的建表语句和存储过程，导入即可：

```bash
mysql -u root -p -P 3305 eventhub < schema.sql
```

### 3. 配置 application.yml

编辑 `src/main/resources/application.yml`，按实际环境修改以下配置：

```yaml
# 数据库连接
spring:
  datasource:
    url: jdbc:mysql://localhost:3305/eventhub?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf-8
    username: root           # 修改为你的数据库用户名
    password: root           # 修改为你的数据库密码

# JWT 密钥（生产环境务必更换为随机长字符串）
jwt:
  secret: eventhub_secret_key_2026_must_be_at_least_256_bits_long_for_hs256_algorithm
  expiration: 7200000        # Token 有效期（毫秒），默认 2 小时
```

### 4. 配置 Aliyun OSS（文件上传）

项目使用阿里云 OSS 存储上传文件（用户头像、活动封面等）。需要先[开通 OSS 服务](https://oss.console.aliyun.com/)并创建 Bucket。

在 `application.yml` 中配置：

```yaml
spring:
  alioss:
    endpoint: XXXXXX          # OSS 地域节点
    access-key-id: XXXXXXXX        # AccessKey ID
    access-key-secret: XXXXXXXX  # AccessKey Secret
    bucket-name: bubbleovo                          # Bucket 名称
    cdn-domain:  XXXXXX                                    # CDN 加速域名（可选）
```

**获取 AccessKey**：登录阿里云控制台 → RAM 访问控制 → 用户 → 创建用户 → 勾选 OpenAPI 调用访问 → 获取 AccessKey ID 和 Secret。

**Bucket 建议设置**：
- 读写权限：公共读（如需公开访问图片）
- 跨域配置：允许 `*` 来源，允许 GET/PUT 方法

### 5. 构建 WAR 包

```bash
mvn clean package
```

构建产物为 `target/eventhub.war`。

### 6. 部署到 Tomcat

**方式一：直接复制（推荐）**

将 WAR 包复制到 Tomcat 的 `webapps/` 目录下：

```bash
# Windows
copy target\eventhub.war C:\apache-tomcat-10\webapps\

# Linux / macOS
cp target/eventhub.war /opt/tomcat/webapps/
```

**方式二：Tomcat Manager**

访问 `http://localhost:8080/manager/html`，在 "WAR file to deploy" 区域上传 `eventhub.war`。

部署后启动 Tomcat：

```bash
# Windows
C:\apache-tomcat-10\bin\startup.bat

# Linux / macOS
/opt/tomcat/bin/startup.sh
```

应用将在 `http://localhost:8080/eventhub` 提供服务。

### 7. Tomcat 配置建议

**`server.xml`**（`conf/server.xml`）：如非 8080 端口，修改 Connector：

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

**文件上传大小限制**：已在 `web.xml` 中配置（单文件 2MB，总请求 5MB），如需调整可修改：

```xml
<multipart-config>
    <max-file-size>2097152</max-file-size>      <!-- 单文件 2MB -->
    <max-request-size>5242880</max-request-size> <!-- 总请求 5MB -->
</multipart-config>
```

### 8. 验证部署

访问以下地址确认部署成功：

- 首页：`http://localhost:8080/eventhub/`
- API 文档（Swagger）：`http://localhost:8080/eventhub/swagger-ui.html`
- Knife4j 文档：`http://localhost:8080/eventhub/doc.html`

### 9. 生产环境注意事项

1. **更换 JWT 密钥**：使用至少 256 位的随机字符串替换默认密钥
2. **数据库密码**：使用强密码，不要使用默认的 `root/root`
3. **OSS AccessKey**：建议使用 RAM 子账号，仅授予 OSS 操作权限
4. **关闭调试日志**：将 `logging.level.com.bubbles` 改为 `INFO`
5. **HTTPS**：生产环境使用反向代理（Nginx/Caddy）配置 SSL 证书

## 项目结构

```
src/main/java/com/bubbles/
├── common/
│   ├── filter/          # Servlet Filter（AuthFilter 鉴权）
│   ├── properties/      # 配置属性类（AliOssProperties）
│   ├── utils/           # 工具类（JwtUtil、AliOssUtil）
│   └── exception/       # 自定义异常
├── pojo/
│   ├── entity/          # MyBatis-Plus 实体（@TableName）
│   └── dto/
│       ├── request/     # 请求 DTO（@Valid 校验）
│       └── response/    # 响应 DTO + ApiResponse<T> 统一包装
└── server/
    ├── config/          # @Configuration（AppConfig、WebConfig、MyBatisConfig）
    ├── controller/      # @RestController
    │   ├── user/        # 用户端接口 /api/user/**
    │   └── admin/       # 管理端接口 /api/admin/**
    ├── service/         # 服务接口
    ├── service/impl/    # @Service 实现（含 OssUploadService）
    ├── mapper/          # MyBatis @Mapper 接口
    ├── handler/         # @RestControllerAdvice 全局异常处理
    └── interceptor/     # HandlerInterceptor（RoleBased、CommunityPermission）
src/main/resources/
├── mapper/              # MyBatis XML 映射文件
└── application.yml      # 应用配置（数据库、OSS、JWT）
src/main/webapp/
├── index.jsp            # 主入口（SPA 单页容器）
├── login.jsp            # 登录页
├── register.jsp         # 注册页
├── static/
│   └── js/
│       ├── app.js       # 主逻辑
│       └── api/         # API 调用模块
└── WEB-INF/
    ├── web.xml          # Servlet 配置
    └── views/           # JSP 视图（按模块分目录）
```

## API 设计

| 路径前缀 | 权限 | 说明 |
|----------|------|------|
| `/api/auth/**` | 公开 | 登录、注册 |
| `/api/user/**` | 需登录 | 用户操作 |
| `/api/admin/**` | 管理员 | 仪表盘、分类管理 |
| `/api/communities/**` | 需登录 | 社区操作 |
| `/api/c/{communityId}/**` | 社区成员 | 社区内资源 |

统一响应格式 `ApiResponse<T>`：

```json
{
  "code": 200,
  "message": "success",
  "data": { ... }
}
```

请求流程：`AuthFilter (JWT 校验)` → `Interceptor (角色/社区权限)` → `Controller` → `Service` → `Mapper`

## 许可证

MIT
