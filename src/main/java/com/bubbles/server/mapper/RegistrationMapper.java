package com.bubbles.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.pojo.entity.Registration;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 注册记录数据访问层接口
 * 继承MyBatis-Plus的BaseMapper，提供基本的CRUD操作
 */
@Mapper
public interface RegistrationMapper extends BaseMapper<Registration> {

    /**
     * 查询用户的注册记录列表
     * @param userId 用户ID
     * @return 用户的注册记录列表
     */
    @Select("SELECT r.* FROM registrations r WHERE r.user_id = #{userId}")
    List<Registration> findByUserId(@Param("userId") Integer userId);

    /**
     * 查询事件的参与者列表
     * @param eventId 事件ID
     * @return 事件的参与者注册记录列表
     */
    @Select("SELECT r.* FROM registrations r WHERE r.event_id = #{eventId}")
    List<Registration> findByEventId(@Param("eventId") Integer eventId);

    /**
     * 查询用户对特定事件的注册记录数量
     * 用于判断用户是否已注册该事件
     * @param eventId 事件ID
     * @param userId 用户ID
     * @return 注册记录数量，0表示未注册
     */
    @Select("SELECT COUNT(*) FROM registrations WHERE event_id = #{eventId} AND user_id = #{userId}")
    int countByEventAndUser(@Param("eventId") Integer eventId, @Param("userId") Integer userId);

    /**
     * 查询事件的注册人数
     * @param eventId 事件ID
     * @return 该事件的已注册人数
     */
    @Select("SELECT COUNT(*) FROM registrations WHERE event_id = #{eventId}")
    int countByEventId(@Param("eventId") Integer eventId);
}