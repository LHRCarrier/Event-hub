package com.bubbles.eventhub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.eventhub.entity.CommunityMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 社区成员Mapper接口
 */
@Mapper
public interface CommunityMemberMapper extends BaseMapper<CommunityMember> {

    @Select("SELECT * FROM community_members WHERE community_id = #{communityId} AND status = 'ACTIVE'")
    List<CommunityMember> selectByCommunityId(@Param("communityId") Integer communityId);

    @Select("SELECT * FROM community_members WHERE user_id = #{userId} AND status = 'ACTIVE'")
    List<CommunityMember> selectByUserId(@Param("userId") Integer userId);

    @Select("SELECT * FROM community_members WHERE community_id = #{communityId} AND user_id = #{userId}")
    CommunityMember selectByCommunityAndUser(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    @Select("SELECT COUNT(*) FROM community_members WHERE community_id = #{communityId} AND status = 'ACTIVE'")
    Integer countMembers(@Param("communityId") Integer communityId);

    @Select("SELECT role FROM community_members WHERE community_id = #{communityId} AND user_id = #{userId} AND status = 'ACTIVE'")
    String getMemberRole(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    @Update("UPDATE community_members SET role = #{role} WHERE member_id = #{memberId}")
    void updateRole(@Param("memberId") Integer memberId, @Param("role") String role);
}