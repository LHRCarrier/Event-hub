package com.bubbles.eventhub.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OpenApiController {

    @GetMapping("/v3/api-docs")
    public ResponseEntity<String> getOpenApiDocs() {
        String openApiJson = """
            {
                "openapi": "3.0.1",
                "info": {
                    "title": "EventHub API",
                    "description": "Community Event Management System API Documentation",
                    "version": "1.0.0"
                },
                "servers": [
                    {
                        "url": "/eventhub_war_exploded"
                    }
                ],
                "paths": {
                    "/api/auth/login": {
                        "post": {
                            "summary": "用户登录",
                            "description": "用户通过邮箱和密码登录系统",
                            "requestBody": {
                                "required": true,
                                "content": {
                                    "application/json": {
                                        "schema": {
                                            "type": "object",
                                            "properties": {
                                                "email": { "type": "string" },
                                                "password": { "type": "string" }
                                            },
                                            "required": ["email", "password"]
                                        }
                                    }
                                }
                            },
                            "responses": {
                                "200": { "description": "登录成功" },
                                "401": { "description": "认证失败" }
                            }
                        }
                    },
                    "/api/auth/register": {
                        "post": {
                            "summary": "用户注册",
                            "description": "创建新用户账户",
                            "requestBody": {
                                "required": true,
                                "content": {
                                    "application/json": {
                                        "schema": {
                                            "type": "object",
                                            "properties": {
                                                "email": { "type": "string" },
                                                "username": { "type": "string" },
                                                "password": { "type": "string" }
                                            },
                                            "required": ["email", "username", "password"]
                                        }
                                    }
                                }
                            },
                            "responses": {
                                "200": { "description": "注册成功" },
                                "400": { "description": "参数错误" }
                            }
                        }
                    },
                    "/api/events": {
                        "get": {
                            "summary": "获取事件列表",
                            "description": "分页获取事件列表",
                            "parameters": [
                                { "name": "page", "in": "query", "type": "integer" },
                                { "name": "size", "in": "query", "type": "integer" },
                                { "name": "status", "in": "query", "type": "string" }
                            ],
                            "responses": {
                                "200": { "description": "成功" }
                            }
                        }
                    },
                    "/api/users": {
                        "get": {
                            "summary": "获取用户列表",
                            "description": "分页获取用户列表",
                            "parameters": [
                                { "name": "page", "in": "query", "type": "integer" },
                                { "name": "size", "in": "query", "type": "integer" }
                            ],
                            "responses": {
                                "200": { "description": "成功" }
                            }
                        }
                    }
                },
                "components": {
                    "securitySchemes": {
                        "BearerAuth": {
                            "type": "http",
                            "scheme": "bearer",
                            "bearerFormat": "JWT"
                        }
                    }
                },
                "security": [
                    { "BearerAuth": [] }
                ]
            }
            """;
        return ResponseEntity.ok(openApiJson);
    }
}