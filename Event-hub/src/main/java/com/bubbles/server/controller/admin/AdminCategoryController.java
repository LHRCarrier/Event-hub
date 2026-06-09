package com.bubbles.server.controller.admin;

import com.bubbles.common.exception.BusinessException;
import com.bubbles.pojo.dto.request.CategoryCreateRequest;
import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CategoryResponse;
import com.bubbles.server.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/categories")
@Tag(name = "Admin Category API", description = "Category management operations (admin only)")
public class AdminCategoryController {

    private final CategoryService categoryService;

    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @PostMapping
    @Operation(summary = "Create Category", description = "Create new event category (admin only)")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(@RequestBody CategoryCreateRequest request) {
        CategoryResponse response = categoryService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("Creation successful", response));
    }

    @GetMapping
    @Operation(summary = "Get Categories", description = "Get all categories (admin only)")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllCategories() {
        List<CategoryResponse> response = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{categoryId}")
    @Operation(summary = "Get Category", description = "Get category by ID (admin only)")
    public ResponseEntity<ApiResponse<CategoryResponse>> getCategoryById(
            @Parameter(description = "Category ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        CategoryResponse response = categoryService.getCategoryById(categoryId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{categoryId}")
    @Operation(summary = "Update Category", description = "Update category information (admin only)")
    public ResponseEntity<ApiResponse<Void>> updateCategory(
            @Parameter(description = "Category ID", required = true) @PathVariable(name = "categoryId") Integer categoryId,
            @RequestBody CategoryCreateRequest request) {
        categoryService.updateCategory(categoryId, request);
        return ResponseEntity.ok(ApiResponse.success("Update successful", null));
    }

    @DeleteMapping("/{categoryId}")
    @Operation(summary = "Delete Category", description = "Delete specified category (admin only)")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(
            @Parameter(description = "Category ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok(ApiResponse.success("Deletion successful", null));
    }
}
