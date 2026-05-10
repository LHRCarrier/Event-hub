package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.request.CategoryCreateRequest;
import com.bubbles.eventhub.dto.response.CategoryResponse;
import com.bubbles.eventhub.entity.Category;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.CategoryMapper;
import com.bubbles.eventhub.mapper.EventMapper;
import com.bubbles.eventhub.service.CategoryService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 分类服务实现类
 * 负责处理分类的增删改查业务逻辑
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryMapper categoryMapper;
    private final EventMapper eventMapper;

    public CategoryServiceImpl(CategoryMapper categoryMapper, EventMapper eventMapper) {
        this.categoryMapper = categoryMapper;
        this.eventMapper = eventMapper;
    }

    /**
     * 创建分类
     * @param request 分类创建请求参数，包含名称和描述
     * @return 创建成功返回分类详细信息
     * @throws BusinessException 分类名称已存在时抛出异常
     */
    @Override
    @Transactional
    public CategoryResponse createCategory(CategoryCreateRequest request) {
        if (categoryMapper.findByName(request.getName()) != null) {
            throw new BusinessException(400, "分类名称已存在");
        }

        Category category = new Category();
        category.setName(request.getName());
        category.setDescription(request.getDescription());

        categoryMapper.insert(category);
        return getCategoryById(category.getCategoryId());
    }

    /**
     * 获取所有分类列表
     * @return 包含所有分类信息的列表，每个分类包含其下的事件数量
     */
    @Override
    public List<CategoryResponse> getAllCategories() {
        List<Category> categories = categoryMapper.selectList(null);
        return categories.stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList());
    }

    /**
     * 根据分类ID获取分类详情
     * @param categoryId 分类ID
     * @return 分类详细信息
     * @throws BusinessException 分类不存在时抛出异常
     */
    @Override
    public CategoryResponse getCategoryById(Integer categoryId) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(404, "分类不存在");
        }
        return convertToResponse(category);
    }

    /**
     * 更新分类信息
     * @param categoryId 要更新的分类ID
     * @param request 分类更新请求参数
     * @throws BusinessException 分类不存在或新名称与其他分类重名时抛出异常
     */
    @Override
    @Transactional
    public void updateCategory(Integer categoryId, CategoryCreateRequest request) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(404, "分类不存在");
        }

        Category existing = categoryMapper.findByName(request.getName());
        if (existing != null && !existing.getCategoryId().equals(categoryId)) {
            throw new BusinessException(400, "分类名称已存在");
        }

        category.setName(request.getName());
        category.setDescription(request.getDescription());

        categoryMapper.updateById(category);
    }

    /**
     * 删除分类
     * 特殊说明：若该分类下存在任何事件，则不允许删除，以保护数据完整性
     * @param categoryId 要删除的分类ID
     * @throws BusinessException 分类不存在或该分类下存在事件时抛出异常
     */
    @Override
    @Transactional
    public void deleteCategory(Integer categoryId) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(404, "分类不存在");
        }

        if (eventMapper.findByCategoryId(categoryId).size() > 0) {
            throw new BusinessException(400, "该分类下存在事件，无法删除");
        }

        categoryMapper.deleteById(categoryId);
    }

    /**
     * 获取分类总数
     * @return 系统中分类的总数量
     */
    @Override
    public int getTotalCategories() {
        return categoryMapper.selectCount(null).intValue();
    }

    /**
     * 将Category实体转换为CategoryResponse
     * @param category 分类实体
     * @return 分类响应对象，包含事件数量
     */
    private CategoryResponse convertToResponse(Category category) {
        CategoryResponse response = new CategoryResponse();
        response.setCategoryId(category.getCategoryId());
        response.setName(category.getName());
        response.setDescription(category.getDescription());
        response.setEventCount(eventMapper.findByCategoryId(category.getCategoryId()).size());
        response.setCreateTime(category.getCreateTime());
        return response;
    }
}