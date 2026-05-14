package com.longarch.module.auth.service;

import com.longarch.module.auth.dto.AdminLoginReq;
import com.longarch.module.auth.dto.BindMobileReq;
import com.longarch.module.auth.dto.GuestLoginReq;
import com.longarch.module.auth.dto.WechatLoginReq;
import com.longarch.module.auth.vo.BindMobileVO;
import com.longarch.module.auth.vo.UserInfoVO;
import com.longarch.module.auth.vo.WechatLoginVO;

public interface AuthService {

    WechatLoginVO wechatLogin(WechatLoginReq req);

    WechatLoginVO guestLogin(GuestLoginReq req);

    BindMobileVO bindMobile(BindMobileReq req);

    UserInfoVO getCurrentUser();

    WechatLoginVO devLogin(String openId);

    /**
     * 管理员后台密码登录
     * 对齐: 仅 roleType=admin · BCrypt 校验 · 失败 5 次锁 15 分钟
     */
    WechatLoginVO adminLogin(AdminLoginReq req);

    /**
     * 登出
     *  · 调用 StpUtil.logout() 清除 Redis 中的 session
     *  · Sa-Token 自动向响应写入 Set-Cookie: satoken=; Max-Age=0 擦除浏览器 cookie
     *  · 未登录调用为幂等空操作 (不抛异常)
     */
    void logout();
}
