package com.bubbles.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.pojo.entity.Community;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 社区Mapper接口
 */
@Mapper
public interface CommunityMapper extends BaseMapper<Community> {

    List<Community> selectActiveCommunities();

    List<Community> searchCommunities(@Param("keyword") String keyword);

    @Select("SELECT name, member_count FROM communities WHERE status = 'ACTIVE' ORDER BY member_count DESC LIMIT #{limit}")
    List<java.util.Map<String, Object>> findTopByMemberCount(@Param("limit") int limit);

    @Select("SELECT name, create_time as time FROM ities ORDER BY create_time DESC LIMIT #{limit}")
    List<java.util.Map<String, Object>> findRecentCommunities(@Param("limit") int limit);
}