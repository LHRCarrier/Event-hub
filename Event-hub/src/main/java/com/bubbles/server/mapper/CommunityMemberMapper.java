package com.bubbles.server.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bubbles.pojo.entity.CommunityMember;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 社区成员Mapper接口
 */
@Mapper
public interface CommunityMemberMapper extends BaseMapper<CommunityMember> {

    List<CommunityMember> selectByCommunityId(@Param("communityId") Integer communityId);

    List<CommunityMember> selectByUserId(@Param("userId") Integer userId);

    CommunityMember selectByCommunityAndUser(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    Integer countMembers(@Param("communityId") Integer communityId);

    String getMemberRole(@Param("communityId") Integer communityId, @Param("userId") Integer userId);

    void updateRole(@Param("memberId") Integer memberId, @Param("role") String role);
}