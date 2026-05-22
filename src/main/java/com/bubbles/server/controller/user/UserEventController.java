package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.pojo.dto.response.PageResponse;
import com.bubbles.server.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/events")
@Tag(name = "用户事件接口", description = "事件的查询操作（普通用户可用）")
public class UserEventController {

    private final EventService eventService;

    public UserEventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping
    @Operation(summary = "获取事件列表", description = "获取事件列表，支持分页和状态筛选")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getEvents(
            @Parameter(description = "页码（从1开始）") @RequestParam(name = "page", defaultValue = "1") Integer page,
            @Parameter(description = "每页大小") @RequestParam(name = "size", defaultValue = "10") Integer size,
            @Parameter(description = "状态筛选（UPCOMING/ONGOING/ENDED）") @RequestParam(name = "status", required = false) String status) {
        PageResponse<EventResponse> response = eventService.getEvents(page, size, null, null, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{eventId}")
    @Operation(summary = "获取事件详情", description = "获取指定事件的详细信息")
    public ResponseEntity<ApiResponse<EventResponse>> getEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
