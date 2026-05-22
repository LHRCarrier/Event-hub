package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.EventResponse;
import com.bubbles.server.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/search")
@Tag(name = "事件搜索接口", description = "事件搜索功能")
public class EventSearchController {

    private final EventService eventService;

    public EventSearchController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping("/events")
    @Operation(summary = "搜索事件", description = "按关键字搜索事件，支持分类和日期范围筛选")
    public ResponseEntity<ApiResponse<List<EventResponse>>> searchEvents(
            @Parameter(description = "搜索关键字", required = true) @RequestParam(name = "keyword") String keyword,
            @Parameter(description = "分类ID") @RequestParam(name = "categoryId", required = false) Integer categoryId,
            @Parameter(description = "开始日期 (yyyy-MM-dd)") @RequestParam(name = "startDate", required = false) String startDate,
            @Parameter(description = "结束日期 (yyyy-MM-dd)") @RequestParam(name = "endDate", required = false) String endDate) {
        List<EventResponse> response = eventService.searchEvents(keyword, categoryId, startDate, endDate);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
