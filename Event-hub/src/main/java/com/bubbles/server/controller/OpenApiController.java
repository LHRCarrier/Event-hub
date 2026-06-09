package com.bubbles.server.controller;

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
                            "summary": "User Login",
                            "description": "User login with email and password",
                            "requestBody": {
                                "required": true,
                                "content": {
                                    "application/json": {
                                        "schema": {
                                            "type": "object",
                                            "properties": {
                                                "username": { "type": "string" },
                                                "password": { "type": "string" }
                                            },
                                            "required": ["username", "password"]
                                        }
                                    }
                                }
                            },
                            "responses": {
                                "200": { "description": "Login successful" },
                                "401": { "description": "Authentication failed" }
                            }
                        }
                    },
                    "/api/auth/register": {
                        "post": {
                            "summary": "User Registration",
                            "description": "Create new user account",
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
                                "200": { "description": "Registration successful" },
                                "400": { "description": "Parameter error" }
                            }
                        }
                    },
                    "/api/events": {
                        "get": {
                            "summary": "Get Events",
                            "description": "Get events with pagination",
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
                            "summary": "Get Users",
                            "description": "Get users with pagination",
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