package com.bubbles.server.mapper;

import com.bubbles.pojo.entity.CommunityApplication;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 社区加入申请Mapper接口
 */
@Mapper
public interface CommunityApplicationMapper extends BaseMapper<CommunityApplication> {

    List<CommunityApplication> selectByCommunityAndStatus(@Param("communityId") Integer communityId, @Param("status") String status);

    List<CommunityApplication> selectByUserId(@Param("userId") Integer userId);

    int countPendingApplications(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    IPage<CommunityApplication> selectPageByCommunityAndStatus(IPage<CommunityApplication> page, 
            @Param("communityId") Integer communityId, @Param("status") String status);

    IPage<CommunityApplication> selectPageByUserId(IPage<CommunityApplication> page, @Param("userId") Integer userId);

    int countPendingApplicationsByCommunity(@Param("communityId") Integer communityId);
}