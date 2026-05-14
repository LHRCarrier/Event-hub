package com.bubbles.eventhub.mapper;

import com.bubbles.eventhub.entity.CommunityApplication;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 社区加入申请Mapper接口
 */
@Mapper
public interface CommunityApplicationMapper extends BaseMapper<CommunityApplication> {

    @Select("SELECT * FROM community_applications WHERE community_id = #{communityId} AND status = #{status}")
    List<CommunityApplication> selectByCommunityAndStatus(@Param("communityId") Integer communityId, @Param("status") String status);

    @Select("SELECT * FROM community_applications WHERE user_id = #{userId} ORDER BY apply_time DESC")
    List<CommunityApplication> selectByUserId(@Param("userId") Integer userId);

    @Select("SELECT COUNT(*) FROM community_applications WHERE community_id = #{communityId} AND user_id = #{userId} AND status = 'PENDING'")
    int countPendingApplications(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    IPage<CommunityApplication> selectPageByCommunityAndStatus(IPage<CommunityApplication> page, 
            @Param("communityId") Integer communityId, @Param("status") String status);

    IPage<CommunityApplication> selectPageByUserId(IPage<CommunityApplication> page, @Param("userId") Integer userId);

    @Select("SELECT COUNT(*) FROM community_applications WHERE community_id = #{communityId} AND status = 'PENDING'")
    int countPendingApplicationsByCommunity(@Param("communityId") Integer communityId);
}