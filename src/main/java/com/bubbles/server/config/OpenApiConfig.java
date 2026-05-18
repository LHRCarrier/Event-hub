package com.bubbles.server.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Springdoc OpenAPI 配置类
 * 配置API文档的基本信息和安全设置
 */
@Configuration
public class OpenApiConfig {

    /**
     * 配置OpenAPI文档的基本信息
     */
    @Bean
    public OpenAPI customOpenAPI() {
        final String securitySchemeName = "bearerAuth";
        
        return new OpenAPI()
            .info(new Info()
                .title("EventHub API")
                .description("EventHub 社区活动管理系统 API 文档\n\n" +
                    "提供用户认证、事件管理、注册管理、分类管理等功能的RESTful接口。\n\n" +
                    "**认证方式:**\n" +
                    "- 使用 JWT Token 进行认证\n" +
                    "- 在请求头中添加 `Authorization: Bearer <token>`\n\n" +
                    "**基础路径:** `/eventhub/api`")
                .version("1.0.0")
                .contact(new Contact()
                    .name("EventHub Team")
                    .email("support@eventhub.example.com")
                    .url("https://eventhub.example.com"))
                .license(new License()
                    .name("Apache 2.0")
                    .url("https://www.apache.org/licenses/LICENSE-2.0")))
            .servers(List.of(
                new Server()
                    .url("http://localhost:8080/eventhub")
                    .description("开发环境")
            ))
            .addSecurityItem(new SecurityRequirement().addList(securitySchemeName))
            .components(new io.swagger.v3.oas.models.Components()
                .addSecuritySchemes(securitySchemeName,
                    new SecurityScheme()
                        .name(securitySchemeName)
                        .type(SecurityScheme.Type.HTTP)
                        .scheme("bearer")
                        .bearerFormat("JWT")));
    }
}