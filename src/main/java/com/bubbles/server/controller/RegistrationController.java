package com.bubbles.server.controller;

import com.bubbles.pojo.dto.request.RegistrationRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.ParticipantResponse;
import com.bubbles.pojo.dto.response.RegistrationResponse;
import com.bubbles.common.exception.BusinessException;
import com.bubbles.server.service.RegistrationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/registrations")
@Tag(name = "注册管理接口", description = "事件注册的创建、查询和取消操作")
public class RegistrationController {

    private final RegistrationService registrationService;

    public RegistrationController(RegistrationService registrationService) {
        this.registrationService = registrationService;
    }

    /**
     * 用户注册参与事件
     * @param request 注册请求参数，包含事件ID和用户ID
     * @return 注册成功返回HTTP 201状态码
     * @throws BusinessException 事件不存在、用户不存在或已注册该事件时抛出异常
     */
    @PostMapping
    @Operation(summary = "注册事件", description = "用户注册参与指定事件")
    public ResponseEntity<ApiResponse<Void>> registerEvent(@RequestBody RegistrationRequest request) {
        registrationService.registerEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("注册成功", null));
    }

    /**
     * 取消事件注册
     * @param registrationId 注册记录ID
     * @return 取消成功返回空响应
     * @throws BusinessException 注册记录不存在时抛出异常
     */
    @DeleteMapping("/{registrationId}")
    @Operation(summary = "取消注册", description = "取消用户的事件注册")
    public ResponseEntity<ApiResponse<Void>> cancelRegistration(
            @Parameter(description = "注册记录ID", required = true) @PathVariable(name = "registrationId") Integer registrationId) {
        registrationService.cancelRegistration(registrationId);
        return ResponseEntity.ok(ApiResponse.success("取消成功", null));
    }

    /**
     * 获取用户的注册记录列表
     * @param userId 用户ID
     * @return 用户参与的所有事件注册记录列表
     * @throws BusinessException 用户不存在时抛出异常
     */
    @GetMapping("/user/{userId}")
    @Operation(summary = "获取用户注册记录", description = "获取指定用户的所有事件注册记录")
    public ResponseEntity<ApiResponse<List<RegistrationResponse>>> getUserRegistrations(
            @Parameter(description = "用户ID", required = true) @PathVariable(name = "userId") Integer userId) {
        List<RegistrationResponse> response = registrationService.getUserRegistrations(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 获取事件的参与者列表
     * @param eventId 事件ID
     * @return 参与该事件的所有用户信息列表
     * @throws BusinessException 事件不存在时抛出异常
     */
    @GetMapping("/event/{eventId}")
    @Operation(summary = "获取事件参与者", description = "获取指定事件的所有参与者信息")
    public ResponseEntity<ApiResponse<List<ParticipantResponse>>> getEventParticipants(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        List<ParticipantResponse> response = registrationService.getEventParticipants(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/check")
    @Operation(summary = "检查注册状态", description = "检查用户是否已注册指定事件")
    public ResponseEntity<ApiResponse<Boolean>> checkRegistration(
            @Parameter(description = "事件ID", required = true) @RequestParam(name = "eventId") Integer eventId,
            @Parameter(description = "用户ID", required = true) @RequestParam(name = "userId") Integer userId) {
        boolean registered = registrationService.checkRegistration(eventId, userId);
        return ResponseEntity.ok(ApiResponse.success(registered));
    }
}