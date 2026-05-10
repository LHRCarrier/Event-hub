package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.LoginRequest;
import com.bubbles.eventhub.dto.request.RegisterRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.LoginResponse;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "认证接口", description = "用户登录和注册相关接口")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * 用户登录接口
     * @param request 登录请求参数，包含用户名和密码
     * @return 登录成功返回用户信息和JWT令牌
     * @throws BusinessException 用户名或密码错误时抛出异常
     */
    @PostMapping("/login")
    @Operation(summary = "用户登录", description = "用户使用用户名和密码进行登录，成功后返回JWT令牌")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "200", 
            description = "登录成功",
            content = @Content(schema = @Schema(implementation = LoginResponse.class))
        ),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "400", 
            description = "用户名或密码错误"
        )
    })
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("登录成功", response));
    }

    /**
     * 用户注册接口
     * @param request 注册请求参数，包含用户名、密码、邮箱等
     * @return 注册成功返回HTTP 201状态码
     * @throws BusinessException 用户名已存在或邮箱已被注册时抛出异常
     */
    @PostMapping("/register")
    @Operation(summary = "用户注册", description = "创建新用户账户，需要提供用户名、密码和邮箱")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "201", 
            description = "注册成功"
        ),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "400", 
            description = "用户名已存在或邮箱已被注册"
        )
    })
    public ResponseEntity<ApiResponse<Void>> register(@Valid @RequestBody RegisterRequest request) {
        System.out.println("register called");
        authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("注册成功", null));
    }
}