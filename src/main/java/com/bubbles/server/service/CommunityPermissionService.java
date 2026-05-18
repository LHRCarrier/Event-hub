package com.bubbles.server.service;

/**
 * 社区权限服务接口
 */
public interface CommunityPermissionService {

    enum AccessLevel {
        NONE(0),
        VIEW(1),
        MEMBER(2),
        ADMIN(3);

        public final int level;

        AccessLevel(int level) {
            this.level = level;
        }
    }

    AccessLevel checkCommunityAccess(Integer communityId, Integer userId);

    boolean checkEventCreatePermission(Integer communityId, Integer userId);

    boolean checkEventAccessPermission(Integer eventId, Integer userId);

    boolean checkRegistrationPermission(Integer eventId, Integer userId);

    boolean checkCommunityAdminPermission(Integer communityId, Integer userId);

    boolean checkCommunityMemberPermission(Integer communityId, Integer userId);
}