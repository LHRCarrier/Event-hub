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
@Tag(name = "Search API", description = "Event search functionality")
public class EventSearchController {

    private final EventService eventService;

    public EventSearchController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping("/events")
    @Operation(summary = "Search Events", description = "Search events by keyword with category and date range filters")
    public ResponseEntity<ApiResponse<List<EventResponse>>> searchEvents(
            @Parameter(description = "Search keyword", required = true) @RequestParam(name = "keyword") String keyword,
            @Parameter(description = "Category ID") @RequestParam(name = "categoryId", required = false) Integer categoryId,
            @Parameter(description = "Start date (yyyy-MM-dd)") @RequestParam(name = "startDate", required = false) String startDate,
            @Parameter(description = "End date (yyyy-MM-dd)") @RequestParam(name = "endDate", required = false) String endDate) {
        List<EventResponse> response = eventService.searchEvents(keyword, categoryId, startDate, endDate);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
