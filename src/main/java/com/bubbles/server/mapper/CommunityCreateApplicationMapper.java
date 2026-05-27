package com.bubbles.server.mapper;

import com.bubbles.pojo.entity.CommunityCreateApplication;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * 社区创建申请Mapper接口
 */
@Mapper
public interface CommunityCreateApplicationMapper extends BaseMapper<CommunityCreateApplication> {

    List<CommunityCreateApplication> selectByApplicantId(@Param("applicantId") Integer applicantId);

    List<CommunityCreateApplication> selectByStatus(@Param("status") String status);

    int countByName(@Param("name") String name);

    void deleteRejectedByName(@Param("name") String name);

    @Select("SELECT status, COUNT(*) as count FROM community_create_applications GROUP BY status")
    List<Map<String, Object>> countByStatus();
}