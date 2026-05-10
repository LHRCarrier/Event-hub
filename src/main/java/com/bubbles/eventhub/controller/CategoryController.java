package com.bubbles.eventhub.controller;

import com.bubbles.eventhub.dto.request.CategoryCreateRequest;
import com.bubbles.eventhub.dto.response.ApiResponse;
import com.bubbles.eventhub.dto.response.CategoryResponse;
import com.bubbles.eventhub.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "分类管理接口", description = "事件分类的创建、查询、更新和删除操作")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * 创建文章分类
     * @param request 分类创建请求参数，包含分类名称和描述
     * @return 创建成功返回分类信息
     * @throws BusinessException 分类名称已存在时抛出异常
     */
    @PostMapping
    @Operation(summary = "创建分类", description = "创建新的事件分类")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(@RequestBody CategoryCreateRequest request) {
        CategoryResponse response = categoryService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.created("创建成功", response));
    }

    /**
     * 获取所有分类列表
     * @return 包含所有分类信息的列表
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllCategories() {
        List<CategoryResponse> response = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 根据分类ID获取分类详情
     * @param categoryId 分类ID
     * @return 分类详细信息
     * @throws BusinessException 分类不存在时抛出异常
     */
    @GetMapping("/{categoryId}")
    @Operation(summary = "获取分类详情", description = "根据分类ID获取分类详细信息")
    public ResponseEntity<ApiResponse<CategoryResponse>> getCategoryById(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        CategoryResponse response = categoryService.getCategoryById(categoryId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * 更新分类信息
     * @param categoryId 要更新的分类ID
     * @param request 分类更新请求参数
     * @return 更新成功返回空响应
     * @throws BusinessException 分类不存在或名称已存在时抛出异常
     */
    @PutMapping("/{categoryId}")
    @Operation(summary = "更新分类", description = "更新分类信息")
    public ResponseEntity<ApiResponse<Void>> updateCategory(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId,
            @RequestBody CategoryCreateRequest request) {
        categoryService.updateCategory(categoryId, request);
        return ResponseEntity.ok(ApiResponse.success("更新成功", null));
    }

    /**
     * 删除分类
     * @param categoryId 要删除的分类ID
     * @return 删除成功返回空响应
     * @throws BusinessException 分类不存在或该分类下存在事件时抛出异常
     */
    @DeleteMapping("/{categoryId}")
    @Operation(summary = "删除分类", description = "删除指定分类")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(
            @Parameter(description = "分类ID", required = true) @PathVariable(name = "categoryId") Integer categoryId) {
        categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok(ApiResponse.success("删除成功", null));
    }
}