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
@Tag(name = "Admin Event API", description = "Event management operations (admin only)")
public class AdminEventController {

    private final EventService eventService;

    public AdminEventController(EventService eventService) {
        this.eventService = eventService;
    }

    @PostMapping
    @Operation(summary = "Create Event", description = "Create new community event (admin only)")
    public ResponseEntity<ApiResponse<EventResponse>> createEvent(@RequestBody EventCreateRequest request) {
        EventResponse response = eventService.createEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Creation successful", response));
    }

    @GetMapping
    @Operation(summary = "Get Events", description = "Get event list with pagination and filters (admin only)")
    public ResponseEntity<ApiResponse<PageResponse<EventResponse>>> getEvents(
            @Parameter(description = "Page number (starting from 1)") @RequestParam(name = "page", defaultValue = "1") int page,
            @Parameter(description = "Page size") @RequestParam(name = "size", defaultValue = "10") int size,
            @Parameter(description = "Search keyword") @RequestParam(name = "keyword", required = false) String keyword,
            @Parameter(description = "Category ID") @RequestParam(name = "categoryId", required = false) Integer categoryId,
            @Parameter(description = "Event status: ALL, UPCOMING, PAST") @RequestParam(name = "status", defaultValue = "ALL") String status) {
        PageResponse<EventResponse> response = eventService.getEvents(page, size, keyword, categoryId, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{eventId}")
    @Operation(summary = "Get Event Detail", description = "Get event details by ID (admin only)")
    public ResponseEntity<ApiResponse<EventResponse>> getEventById(
            @Parameter(description = "Event ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        EventResponse response = eventService.getEventById(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{eventId}")
    @Operation(summary = "Update Event", description = "Update event information (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateEvent(
            @Parameter(description = "事件ID", required = true) @PathVariable(name = "eventId") Integer eventId,
            @RequestBody EventUpdateRequest request) {
        eventService.updateEvent(eventId, request);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @DeleteMapping("/{eventId}")
    @Operation(summary = "Delete Event", description = "Delete specified event (admin only)")
    public ResponseEntity<ApiResponse<Void>> deleteEvent(
            @Parameter(description = "Event ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        eventService.deleteEvent(eventId);
        return ResponseEntity.ok(ApiResponse.success("Deletion successful", null));
    }
}
