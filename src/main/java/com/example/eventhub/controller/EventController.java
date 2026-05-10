package com.example.eventhub.controller;

import com.example.eventhub.dto.request.EventCreateRequest;
import com.example.eventhub.dto.request.EventUpdateRequest;
import com.example.eventhub.dto.response.ApiResponse;
import com.example.eventhub.dto.response.EventResponse;
import com.example.eventhub.dto.response.PageResponse;
import com.example.eventhub.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events")
@Tag(name = "事件管理接口", description = "事件的创建、查询、更新和删除操作")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    /**
     * 创建新事件
     * @param request 事件创建请求参数，包含名称、日期、地点、描述和分类ID
     * @return 创建成功返回事件详情
     * @throws BusinessException 分类不存在时抛出异常
     */
    @PostMapping
    @Operation(summary = "创建事件", description = "创建新的社区活动事件")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "201", 
            description = "创建成功"
        ),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(
            responseCode = "400", 
            description = "分类不存在"
        )
    })
    public ResponseEntity<ApiResponse<EventResponse>> createEvent(@RequestBody EventCreateRequest request) {
        EventResponse response = eventService.createEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    /**
     * 分页获取事件列表
     * 支持按关键字、分类ID和状态筛选，默认返回所有状态的事件
     * @param page 页码，从1开始
     * @param size 每页数量，默认10
     * @param keyword 搜索关键字，用于匹配事件名称（非必填）
     * @param categoryId 分类ID筛选（非必填）
     * @param status 事件状态筛选，可选值：ALL、UPCOMING、PAST等（默认ALL）
     * @return 分页的事件列表
     */
    @GetMapping
    @Operation(summary = "获取事件列表", description = "分页获取事件列表，支持关键字、分类和状态筛选")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getEvents(
            @Parameter(description = "页码，从1开始", example = "1") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量", example = "10") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "搜索关键字") @RequestParam(name = "keyword", required = false) String keyword,
            @Parameter(description = "分类ID") @RequestParam(name = "categoryId", required = false) Integer categoryId,
            @Parameter(description = "事件状态: ALL, UPCOMING, PAST") @RequestParam(name = "status", defaultValue = "ALL") String status) {
        PageResponse<EventResponse> response = eventService.getEvents(page, size, keyword, categoryId, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 根据事件ID获取事件详情
     * @param eventId 事件ID
     * @return 事件详细信息
     * @throws BusinessException 事件不存在时抛出异常
     */
    @GetMapping("/{eventId}")
    @Operation(summary = "获取事件详情", description = "根据事件ID获取事件详细信息")
    public ResponseEntity<ApiResponse<EventResponse>> getEventById(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 更新事件信息
     * @param eventId 要更新的事件ID
     * @param request 事件更新请求参数，所有字段可选
     * @return 更新成功返回空响应
     * @throws BusinessException 事件不存在或分类不存在时抛出异常
     */
    @PutMapping("/{eventId}")
    @Operation(summary = "更新事件", description = "更新事件信息")
    public ResponseEntity<ApiResponse<Void>> updateEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId,
            @RequestBody EventUpdateRequest request) {
        eventService.updateEvent(eventId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    /**
     * 删除事件
     * @param eventId 要删除的事件ID
     * @return 删除成功返回空响应
     * @throws BusinessException 事件不存在时抛出异常
     */
    @DeleteMapping("/{eventId}")
    @Operation(summary = "删除事件", description = "删除指定事件")
    public ResponseEntity<ApiResponse<Void>> deleteEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        eventService.deleteEvent(eventId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}