package com.bubbles.eventhub.service;

import com.bubbles.eventhub.dto.request.UpdateUserRequest;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.dto.response.UserResponse;

/**
 * 用户服务接口
 * 提供用户的增删改查功能
 */
public interface UserService {

    /**
     * 分页获取用户列表
     * 支持按关键字搜索用户名或真实姓名
     * @param page 页码，从1开始
     * @param size 每页数量
     * @param keyword 搜索关键字（非必填）
     * @return 分页的用户列表
     */
    PageResponse<UserResponse> getUsers(int page, int size, String keyword);

    /**
     * 根据用户ID获取用户详情
     * @param userId 用户ID
     * @return 用户详细信息
     * @throws BusinessException 用户不存在时抛出异常
     */
    UserResponse getUserById(Integer userId);

    /**
     * 更新用户信息
     * @param userId 要更新的用户ID
     * @param request 用户更新请求参数
     * @throws BusinessException 用户不存在或邮箱已被使用时抛出异常
     */
    void updateUser(Integer userId, UpdateUserRequest request);

    /**
     * 删除用户
     * @param userId 要删除的用户ID
     * @throws BusinessException 用户不存在时抛出异常
     */
    void deleteUser(Integer userId);

    /**
     * 获取用户总数
     * @return 系统中用户的总数量
     */
    int getTotalUsers();

    /**
     * 获取活跃用户数量
     * 活跃用户定义为角色为USER的用户
     * @return 系统中活跃用户的数量
     */
    int getActiveUsers();
}