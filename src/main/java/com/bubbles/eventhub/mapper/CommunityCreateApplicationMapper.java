package com.bubbles.eventhub.mapper;

import com.bubbles.eventhub.entity.CommunityCreateApplication;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 社区创建申请Mapper接口
 */
@Mapper
public interface CommunityCreateApplicationMapper extends BaseMapper<CommunityCreateApplication> {

    @Select("SELECT * FROM community_create_applications WHERE applicant_id = #{applicantId} ORDER BY apply_time DESC")
    List<CommunityCreateApplication> selectByApplicantId(@Param("applicantId") Integer applicantId);

    @Select("SELECT * FROM community_create_applications WHERE status = #{status} ORDER BY apply_time DESC")
    List<CommunityCreateApplication> selectByStatus(@Param("status") String status);

    @Select("SELECT COUNT(*) FROM community_create_applications WHERE name = #{name}")
    int countByName(@Param("name") String name);
}