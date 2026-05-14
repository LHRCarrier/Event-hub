package com.bubbles.eventhub.service.impl;

import com.bubbles.eventhub.dto.request.UpdateUserRequest;
import com.bubbles.eventhub.dto.response.PageResponse;
import com.bubbles.eventhub.dto.response.UserResponse;
import com.bubbles.eventhub.entity.User;
import com.bubbles.eventhub.exception.BusinessException;
import com.bubbles.eventhub.mapper.UserMapper;
import com.bubbles.eventhub.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 用户服务实现类
 * 负责处理用户的增删改查业务逻辑
 */
@Service
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    public UserServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    /**
     * 分页获取用户列表
     * 支持按关键字搜索用户名或真实姓名
     * @param page 页码，从1开始
     * @param size 每页数量
     * @param keyword 搜索关键字（非必填）
     * @return 分页的用户列表
     */
    @Override
    public PageResponse<UserResponse> getUsers(int page, int size, String keyword) {
        if (keyword == null) {
            keyword = "";
        }

        int offset = (page - 1) * size;
        List<User> users = userMapper.searchByKeyword(keyword);

        List<UserResponse> userResponses = users.stream()
            .skip(offset)
            .limit(size)
            .map(this::convertToResponse)
            .collect(Collectors.toList());

        return new PageResponse<>(userResponses, users.size(), page, size);
    }

    /**
     * 根据用户ID获取用户详情
     * @param userId 用户ID
     * @return 用户详细信息
     * @throws BusinessException 用户不存在时抛出异常
     */
    @Override
    public UserResponse getUserById(Integer userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(404, "用户不存在");
        }
        return convertToResponse(user);
    }

    /**
     * 更新用户信息
     * 特殊说明：邮箱更新时需检查唯一性，确保新邮箱未被其他用户使用
     * @param userId 要更新的用户ID
     * @param request 用户更新请求参数
     * @throws BusinessException 用户不存在或邮箱已被使用时抛出异常
     */
    @Override
    @Transactional
    public void updateUser(Integer userId, UpdateUserRequest request) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(404, "用户不存在");
        }

        if (request.getEmail() != null && !request.getEmail().equals(user.getEmail())) {
            User existing = userMapper.findByEmail(request.getEmail());
            if (existing != null && !existing.getUserId().equals(userId)) {
                throw new BusinessException(400, "邮箱已被使用");
            }
            user.setEmail(request.getEmail());
        }

        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getRealName() != null) {
            user.setRealName(request.getRealName());
        }

        userMapper.updateById(user);
    }

    /**
     * 删除用户
     * @param userId 要删除的用户ID
     * @throws BusinessException 用户不存在时抛出异常
     */
    @Override
    @Transactional
    public void deleteUser(Integer userId) {
        if (userMapper.selectById(userId) == null) {
            throw new BusinessException(404, "用户不存在");
        }
        userMapper.deleteById(userId);
    }

    /**
     * 获取用户总数
     * @return 系统中用户的总数量
     */
    @Override
    public int getTotalUsers() {
        return userMapper.selectCount(null).intValue();
    }

    /**
     * 获取活跃用户数量
     * 特殊说明：活跃用户定义为角色为USER的用户
     * @return 系统中活跃用户的数量
     */
    @Override
    public int getActiveUsers() {
        return userMapper.findByRole("USER").size();
    }

    /**
     * 根据用户ID获取用户角色
     * @param userId 用户ID
     * @return 用户角色（ADMIN 或 USER）
     */
    @Override
    public String getUserRole(Integer userId) {
        User user = userMapper.selectById(userId);
        return user != null ? user.getRole() : null;
    }

    /**
     * 将User实体转换为UserResponse
     * @param user 用户实体
     * @return 用户响应对象（不含密码信息）
     */
    private UserResponse convertToResponse(User user) {
        UserResponse response = new UserResponse();
        response.setUserId(user.getUserId());
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setPhone(user.getPhone());
        response.setRealName(user.getRealName());
        response.setRole(user.getRole());
        response.setStatus(user.getStatus());
        response.setCreateTime(user.getCreateTime());
        return response;
    }
}