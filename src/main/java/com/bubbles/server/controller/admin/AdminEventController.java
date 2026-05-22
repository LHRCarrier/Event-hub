package com.bubbles.server.controller.admin;

import com.bubbles.pojo.dto.request.EventCreateRequest;
import com.bubbles.pojo.dto.request.EventUpdateRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.server.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/events")
@Tag(name = "管理事件接口", description = "事件的创建、查询、更新和删除操作（仅管理员）")
public class AdminEventController {

    private final EventService eventService;

    public AdminEventController(EventService eventService) {
        this.eventService = eventService;
    }

    @PostMapping
    @Operation(summary = "创建事件", description = "创建新的社区活动事件（仅管理员）")
    public ResponseEntity<ApiResponse<EventResponse>> createEvent(@RequestBody EventCreateRequest request) {
        EventResponse response = eventService.createEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    @GetMapping
    @Operation(summary = "获取事件列表", description = "分页获取事件列表，支持关键字、分类和状态筛选（仅管理员）")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getEvents(
            @Parameter(description = "页码，从1开始") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "搜索关键字") @RequestParam(name = "keyword", required = false) String keyword,
            @Parameter(description = "分类ID") @RequestParam(name = "categoryId", required = false) Integer categoryId,
            @Parameter(description = "事件状态: ALL, UPCOMING, PAST") @RequestParam(name = "status", defaultValue = "ALL") String status) {
        PageResponse<EventResponse> response = eventService.getEvents(page, size, keyword, categoryId, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{eventId}")
    @Operation(summary = "获取事件详情", description = "根据事件ID获取事件详细信息（仅管理员）")
    public ResponseEntity<ApiResponse<EventResponse>> getEventById(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{eventId}")
    @Operation(summary = "更新事件", description = "更新事件信息（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId,
            @RequestBody EventUpdateRequest request) {
        eventService.updateEvent(eventId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{eventId}")
    @Operation(summary = "删除事件", description = "删除指定事件（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> deleteEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        eventService.deleteEvent(eventId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}
