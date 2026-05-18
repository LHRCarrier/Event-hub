package com.bubbles.server.mapper;

import com.bubbles.pojo.entity.CommunityCreateApplication;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 社区创建申请Mapper接口
 */
@Mapper
public interface CommunityCreateApplicationMapper extends BaseMapper<CommunityCreateApplication> {

    List<CommunityCreateApplication> selectByApplicantId(@Param("applicantId") Integer applicantId);

    List<CommunityCreateApplication> selectByStatus(@Param("status") String status);

    int countByName(@Param("name") String name);
}