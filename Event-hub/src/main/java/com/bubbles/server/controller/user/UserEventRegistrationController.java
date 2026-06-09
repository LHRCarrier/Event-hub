package com.bubbles.server.controller.user;

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
@Tag(name = "Event Registration API", description = "Event registration creation, query and cancellation operations")
public class UserEventRegistrationController {

    private final RegistrationService registrationService;

    public UserEventRegistrationController(RegistrationService registrationService) {
        this.registrationService = registrationService;
    }

    @PostMapping
    @Operation(summary = "Register for Event", description = "User registers for specified event")
    public ResponseEntity<ApiResponse<Void>> registerEvent(@RequestBody RegistrationRequest request) {
        registrationService.registerEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Registration successful", null));
    }

    @DeleteMapping("/{registrationId}")
    @Operation(summary = "Cancel Registration", description = "Cancel user's event registration")
    public ResponseEntity<ApiResponse<Void>> cancelRegistration(
            @Parameter(description = "Registration ID", required = true) @PathVariable(name = "registrationId") Integer registrationId) {
        registrationService.cancelRegistration(registrationId);
        return ResponseEntity.ok(ApiResponse.success("Cancellation successful", null));
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "Get User Registrations", description = "Get all event registrations for specified user")
    public ResponseEntity<ApiResponse<List<RegistrationResponse>>> getUserRegistrations(
            @Parameter(description = "User ID", required = true) @PathVariable(name = "userId") Integer userId) {
        List<RegistrationResponse> response = registrationService.getUserRegistrations(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/event/{eventId}")
    @Operation(summary = "Get Event Participants", description = "Get all participants for specified event")
    public ResponseEntity<ApiResponse<List<ParticipantResponse>>> getEventParticipants(
            @Parameter(description = "Event ID", required = true) @PathVariable(name = "eventId") Integer eventId) {
        List<ParticipantResponse> response = registrationService.getEventParticipants(eventId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/check")
    @Operation(summary = "Check Registration Status", description = "Check if user is registered for specified event")
    public ResponseEntity<ApiResponse<Boolean>> checkRegistration(
            @Parameter(description = "Event ID", required = true) @RequestParam(name = "eventId") Integer eventId,
            @Parameter(description = "User ID", required = true) @RequestParam(name = "userId") Integer userId) {
        boolean registered = registrationService.checkRegistration(eventId, userId);
        return ResponseEntity.ok(ApiResponse.success(registered));
    }
}
