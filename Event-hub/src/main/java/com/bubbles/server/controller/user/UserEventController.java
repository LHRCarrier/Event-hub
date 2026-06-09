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
@Tag(name = "Event API", description = "Event query operations (available to regular users)")
public class UserEventController {

    private final EventService eventService;

    public UserEventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping
    @Operation(summary = "Get Events", description = "Get event list with pagination and status filtering")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getEvents(
            @Parameter(description = "Page number (starting from 1)") @RequestParam(name = "page", defaultValue = "1") Integer page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") Integer size,
            @Parameter(description = "Status filter (UPCOMING/ONGOING/ENDED)") @RequestParam(name = "status", required = false) String status) {
        PageResponse<EventResponse> response = eventService.getEvents(page, size, null, null, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{eventId}")
    @Operation(summary = "Get Event Detail", description = "Get detailed information for specified event")
    public ResponseEntity<ApiResponse<EventResponse>> getEvent(
            @Parameter(description = "Event ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
