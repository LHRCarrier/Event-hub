package com.bubbles.eventhub.service;

import com.bubbles.eventhub.dto.request.CategoryCreateRequest;
import com.bubbles.eventhub.dto.response.CategoryResponse;

import java.util.List;

/**
 * 分类服务接口
 * 提供分类的增删改查功能
 */
public interface CategoryService {

    /**
     * 创建分类
     * @param request 分类创建请求参数，包含名称和描述
     * @return 创建成功返回分类信息
     * @throws BusinessException 分类名称已存在时抛出异常
     */
    CategoryResponse createCategory(CategoryCreateRequest request);

    /**
     * 获取所有分类列表
     * @return 包含所有分类信息的列表
     */
    List<CategoryResponse> getAllCategories();

    /**
     * 根据分类ID获取分类详情
     * @param categoryId 分类ID
     * @return 分类详细信息
     * @throws BusinessException 分类不存在时抛出异常
     */
    CategoryResponse getCategoryById(Integer categoryId);

    /**
     * 更新分类信息
     * @param categoryId 要更新的分类ID
     * @param request 分类更新请求参数
     * @throws BusinessException 分类不存在或名称已存在时抛出异常
     */
    void updateCategory(Integer categoryId, CategoryCreateRequest request);

    /**
     * 删除分类
     * @param categoryId 要删除的分类ID
     * @throws BusinessException 分类不存在或该分类下存在事件时抛出异常
     */
    void deleteCategory(Integer categoryId);

    /**
     * 获取分类总数
     * @return 系统中分类的总数量
     */
    int getTotalCategories();

    /**
     * 获取社区关联的分类列表
     * @param communityId 社区ID
     * @return 社区关联的分类列表
     */
    List<CategoryResponse> getCategoriesByCommunity(Integer communityId);

    /**
     * 创建社区专属分类
     * @param communityId 社区ID
     * @param request 分类创建请求
     * @return 创建的分类信息
     */
    CategoryResponse createCommunityCategory(Integer communityId, CategoryCreateRequest request);
}