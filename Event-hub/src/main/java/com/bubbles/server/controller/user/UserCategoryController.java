package com.bubbles.server.controller.user;

import com.bubbles.pojo.dto.response.ApiResponse;
import com.bubbles.pojo.dto.response.CategoryResponse;
import com.bubbles.server.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "Category API", description = "Category query operations (available to regular users)")
public class UserCategoryController {

    private final CategoryService categoryService;

    public UserCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    @Operation(summary = "Get Categories", description = "Get all categories")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getCategories() {
        List<CategoryResponse> response = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{categoryId}")
    @Operation(summary = "Get Category", description = "Get category details")
    public ResponseEntity<ApiResponse<CategoryResponse>> getCategory(
            @Parameter(description = "Category ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        CategoryResponse response = categoryService.getCategoryById(categoryId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
