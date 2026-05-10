package com.example.eventhub.controller;

import com.example.eventhub.dto.response.ApiResponse;
import com.example.eventhub.dto.response.EventResponse;
import com.example.eventhub.service.EventService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/search")
@Tag(name = "搜索接口", description = "事件搜索功能")
public class SearchController {

    private final EventService eventService;

    public SearchController(EventService eventService) {
        this.eventService = eventService;
    }

    /**
     * 搜索事件
     * 支持按关键字和分类ID进行筛选，可选的时间范围过滤
     * @param keyword 搜索关键字，用于匹配事件名称
     * @param categoryId 分类ID筛选（非必填）
     * @param startDate 事件开始日期筛选下限（非必填，格式：yyyy-MM-dd）
     * @param endDate 事件开始日期筛选上限（非必填，格式：yyyy-MM-dd）
     * @return 符合条件的事件列表
     */
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