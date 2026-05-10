package com.example.eventhub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.eventhub.entity.Event;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 事件数据访问层接口
 * 继承MyBatis-Plus的BaseMapper，提供基本的CRUD操作
 */
@Mapper
public interface EventMapper extends BaseMapper<Event> {

    /**
     * 根据状态查询事件列表
     * @param status 事件状态（如：UPCOMING、PAST）
     * @return 符合状态的事件列表
     */
    @Select("SELECT * FROM events WHERE status = #{status} ORDER BY date DESC")
    List<Event> findByStatus(@Param("status") String status);

    /**
     * 根据分类查询事件列表
     * @param categoryId 分类ID
     * @return 属于该分类的事件列表
     */
    @Select("SELECT * FROM events WHERE category_id = #{categoryId} ORDER BY date DESC")
    List<Event> findByCategoryId(@Param("categoryId") Integer categoryId);

    /**
     * 根据关键字搜索事件
     * 模糊匹配事件名称
     * @param keyword 搜索关键字
     * @return 匹配关键字的事件列表
     */
    @Select("SELECT * FROM events WHERE name LIKE CONCAT('%', #{keyword}, '%') ORDER BY date DESC")
    List<Event> searchByName(@Param("keyword") String keyword);

    /**
     * 查询所有事件
     * 按事件日期降序排列
     * @return 所有事件列表
     */
    @Select("SELECT * FROM events ORDER BY date DESC")
    List<Event> findAllWithCategory();

    /**
     * 查询事件的参与者数量
     * @param eventId 事件ID
     * @return 该事件的注册人数
     */
    @Select("SELECT COUNT(*) FROM registrations WHERE event_id = #{eventId}")
    int countParticipants(@Param("eventId") Integer eventId);
}