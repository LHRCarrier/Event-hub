package com.example.eventhub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.eventhub.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 用户数据访问层接口
 * 继承MyBatis-Plus的BaseMapper，提供基本的CRUD操作
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {

    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 匹配的用户对象，若不存在则返回null
     */
    @Select("SELECT * FROM users WHERE username = #{username}")
    User findByUsername(@Param("username") String username);

    /**
     * 根据邮箱查询用户
     * @param email 邮箱地址
     * @return 匹配的用户对象，若不存在则返回null
     */
    @Select("SELECT * FROM users WHERE email = #{email}")
    User findByEmail(@Param("email") String email);

    /**
     * 根据角色查询用户列表
     * @param role 用户角色
     * @return 匹配角色的用户列表
     */
    @Select("SELECT * FROM users WHERE role = #{role}")
    List<User> findByRole(@Param("role") String role);

    /**
     * 根据关键字搜索用户
     * 搜索范围包括真实姓名和用户名，使用模糊匹配
     * @param keyword 搜索关键字
     * @return 匹配关键字的用户列表
     */
    @Select("SELECT * FROM users WHERE real_name LIKE CONCAT('%', #{keyword}, '%') OR username LIKE CONCAT('%', #{keyword}, '%')")
    List<User> searchByKeyword(@Param("keyword") String keyword);
}