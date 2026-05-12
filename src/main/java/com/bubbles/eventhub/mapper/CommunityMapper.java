package com.bubbles.eventhub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.eventhub.entity.Community;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 社区Mapper接口
 */
@Mapper
public interface CommunityMapper extends BaseMapper<Community> {

    @Select("SELECT * FROM communities WHERE status = 'ACTIVE' ORDER BY create_time DESC")
    List<Community> selectActiveCommunities();

    @Select("SELECT * FROM communities WHERE name LIKE CONCAT('%', #{keyword}, '%') AND status = 'ACTIVE'")
    List<Community> searchCommunities(@Param("keyword") String keyword);
}