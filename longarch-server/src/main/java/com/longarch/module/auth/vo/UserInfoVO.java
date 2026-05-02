package com.longarch.module.auth.vo;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class UserInfoVO {

    private Long userId;
    private String userNo;
    private String nickname;
    private String realName;
    private String mobile;
    private String avatarUrl;
    private String roleType;
    private Integer status;
    private Boolean bindMobile;

    private RoleProfile roleProfile;
    private Map<String, Boolean> permissions;
    private List<String> menuScopes;

    @Data
    public static class RoleProfile {
        private String roleName;
        private String roleDesc;
    }
}
