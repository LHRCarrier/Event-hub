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
@Tag(name = "管理分类接口", description = "事件分类的创建、查询、更新和删除操作（仅管理员）")
public class AdminCategoryController {

    private final CategoryService categoryService;

    public AdminCategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @PostMapping
    @Operation(summary = "创建分类", description = "创建新的事件分类（仅管理员）")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(@RequestBody CategoryCreateRequest request) {
        CategoryResponse response = categoryService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    @GetMapping
    @Operation(summary = "获取分类列表", description = "获取所有分类列表（仅管理员）")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllCategories() {
        List<CategoryResponse> response = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{categoryId}")
    @Operation(summary = "获取分类详情", description = "根据分类ID获取分类详细信息（仅管理员）")
    public ResponseEntity<ApiResponse<CategoryResponse>> getCategoryById(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        CategoryResponse response = categoryService.getCategoryById(categoryId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{categoryId}")
    @Operation(summary = "更新分类", description = "更新分类信息（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> updateCategory(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId,
            @RequestBody CategoryCreateRequest request) {
        categoryService.updateCategory(categoryId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    @DeleteMapping("/{categoryId}")
    @Operation(summary = "删除分类", description = "删除指定分类（仅管理员）")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}
