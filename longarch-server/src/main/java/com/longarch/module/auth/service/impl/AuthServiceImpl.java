package com.longarch.module.auth.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.longarch.common.enums.ErrorCode;
import com.longarch.common.exception.BizException;
import com.longarch.common.config.RateLimitProperties;
import com.longarch.common.service.RateLimitService;
import com.longarch.module.auth.dto.AdminLoginReq;
import com.longarch.module.auth.dto.BindMobileReq;
import com.longarch.module.auth.dto.GuestLoginReq;
import com.longarch.module.auth.dto.WechatLoginReq;

import java.time.LocalDateTime;
import com.longarch.module.auth.entity.User;
import com.longarch.module.auth.mapper.UserMapper;
import com.longarch.module.adoption.entity.AdoptionCode;
import com.longarch.module.adoption.mapper.AdoptionCodeMapper;
import com.longarch.module.auth.service.AuthService;
import com.longarch.module.auth.vo.BindMobileVO;
import com.longarch.module.auth.vo.UserInfoVO;
import com.longarch.module.auth.vo.WechatLoginVO;
import com.longarch.common.enums.RolePermissionConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;
    private final AdoptionCodeMapper adoptionCodeMapper;
    private final RateLimitService rateLimitService;
    private final RateLimitProperties rateLimitProperties;

    @Value("${wechat.miniapp.stub-mode:true}")
    private boolean stubMode;

    @Override
    public WechatLoginVO wechatLogin(WechatLoginReq req) {
        String wechatLimitKey = buildWechatLimitKey(req);
        RateLimitProperties.Rule wechatRule = rateLimitProperties.getWechatLogin();
        long wechatReqCount = rateLimitService.incrementAndGet(wechatLimitKey, wechatRule.getWindowSeconds());
        if (wechatReqCount > wechatRule.getLimit()) {
            rateLimitService.recordHit("wechatLogin");
            log.warn("Rate limit hit: scene=wechatLogin, key={}, count={}, limit={}, window={}s",
                    wechatLimitKey, wechatReqCount, wechatRule.getLimit(), wechatRule.getWindowSeconds());
            throw new BizException(ErrorCode.TOO_MANY_REQUESTS, "登录请求过于频繁，请稍后重试");
        }

        // Stub模式：直接用code当openId
        String openId = stubMode ? "stub_" + req.getCode() : resolveOpenId(req.getCode());

        log.info("wechatLogin openId={}, stubMode={}", openId, stubMode);

        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getOpenId, openId));

        if (user == null) {
            user = new User();
            user.setOpenId(openId);
            user.setUserNo("U" + IdUtil.getSnowflakeNextIdStr());
            user.setNickname("用户" + user.getUserNo().substring(user.getUserNo().length() - 6));
            user.setRoleType("adopter");
            user.setStatus(1);
            user.setBindMobile(0);
            userMapper.insert(user);
            log.info("New user registered: userId={}, userNo={}", user.getId(), user.getUserNo());
        }

        if (user.getStatus() == 0) {
            throw new BizException(ErrorCode.FORBIDDEN, "账号已被禁用");
        }

        // 若传了 inviteCode，尝试预绑定认养码
        if (req.getInviteCode() != null && !req.getInviteCode().isBlank()) {
            log.info("inviteCode provided: {}, userId={}", req.getInviteCode(), user.getId());
        }

        StpUtil.login(user.getId());
        StpUtil.getSession().set("roleType", user.getRoleType());

        WechatLoginVO vo = new WechatLoginVO();
        vo.setToken(StpUtil.getTokenValue());
        vo.setRefreshToken(IdUtil.fastSimpleUUID());
        vo.setExpiresIn(7200);

        UserInfoVO userInfo = buildUserInfoVO(user);
        vo.setUserInfo(userInfo);
        return vo;
    }

    @Override
    public WechatLoginVO guestLogin(GuestLoginReq req) {
        AdoptionCode code = adoptionCodeMapper.selectOne(
                new LambdaQueryWrapper<AdoptionCode>()
                        .eq(AdoptionCode::getCode, req.getCode())
                        .eq(AdoptionCode::getStatus, "active"));

        if (code == null) {
            throw new BizException(ErrorCode.ADOPTION_CODE_INVALID, "分享码无效或已过期");
        }

        if (!"guest".equals(code.getCodeType()) && !"share".equals(code.getCodeType())) {
            throw new BizException(ErrorCode.INVALID_PARAM, "该码不是游客/分享码");
        }

        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (now.isBefore(code.getValidFrom()) || now.isAfter(code.getValidTo())) {
            throw new BizException(ErrorCode.ADOPTION_CODE_EXPIRED, "分享码已过期");
        }

        User user;
        if (code.getBindUserId() != null) {
            user = userMapper.selectById(code.getBindUserId());
        } else {
            // 自动创建临时 guest 用户并绑定
            user = new User();
            user.setOpenId("guest_" + code.getCode() + "_" + IdUtil.fastSimpleUUID().substring(0, 8));
            user.setUserNo("U" + IdUtil.getSnowflakeNextIdStr());
            user.setNickname("游客" + user.getUserNo().substring(user.getUserNo().length() - 6));
            user.setRoleType("guest");
            user.setStatus(1);
            user.setBindMobile(0);
            userMapper.insert(user);

            code.setBindUserId(user.getId());
            adoptionCodeMapper.updateById(code);

            log.info("Guest user created and bound: userId={}, codeId={}", user.getId(), code.getId());
        }

        if (user == null || user.getStatus() == 0) {
            throw new BizException(ErrorCode.FORBIDDEN, "账号不可用");
        }

        StpUtil.login(user.getId());
        StpUtil.getSession().set("roleType", user.getRoleType());

        WechatLoginVO vo = new WechatLoginVO();
        vo.setToken(StpUtil.getTokenValue());
        vo.setRefreshToken(IdUtil.fastSimpleUUID());
        vo.setExpiresIn(7200);
        vo.setUserInfo(buildUserInfoVO(user));
        return vo;
    }

    @Override
    public BindMobileVO bindMobile(BindMobileReq req) {
        Long userId = StpUtil.getLoginIdAsLong();
        log.info("bindMobile userId={}, mobile={}", userId, req.getMobile());

        // Stub: 跳过短信验证码校验，直接绑定
        User existing = userMapper.selectOne(
                new LambdaQueryWrapper<User>()
                        .eq(User::getMobile, req.getMobile())
                        .ne(User::getId, userId));
        if (existing != null) {
            throw new BizException(ErrorCode.INVALID_PARAM, "该手机号已被其他账号绑定");
        }

        User user = userMapper.selectById(userId);
        user.setMobile(req.getMobile());
        user.setBindMobile(1);
        userMapper.updateById(user);

        BindMobileVO vo = new BindMobileVO();
        vo.setBindSuccess(true);
        return vo;
    }

    @Override
    public UserInfoVO getCurrentUser() {
        Long userId = StpUtil.getLoginIdAsLong();
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.RESOURCE_NOT_FOUND, "用户不存在");
        }
        return buildUserInfoVO(user);
    }

    private UserInfoVO buildUserInfoVO(User user) {
        UserInfoVO vo = new UserInfoVO();
        vo.setUserId(user.getId());
        vo.setUserNo(user.getUserNo());
        vo.setNickname(user.getNickname());
        vo.setRealName(user.getRealName());
        vo.setMobile(user.getMobile());
        vo.setAvatarUrl(user.getAvatarUrl());
        vo.setRoleType(user.getRoleType());
        vo.setStatus(user.getStatus());
        vo.setBindMobile(user.getBindMobile() == 1);

        RolePermissionConfig config = RolePermissionConfig.fromRoleType(user.getRoleType());
        UserInfoVO.RoleProfile profile = new UserInfoVO.RoleProfile();
        profile.setRoleName(config.getRoleName());
        profile.setRoleDesc(config.getRoleDesc());
        vo.setRoleProfile(profile);
        vo.setPermissions(config.getPermissions());
        vo.setMenuScopes(config.getMenuScopes());

        return vo;
    }

    @Override
    public WechatLoginVO devLogin(String openId) {
        if (!stubMode) {
            throw new BizException(ErrorCode.FORBIDDEN, "仅开发模式可用");
        }
        if (openId == null || openId.isBlank()) {
            throw new BizException(ErrorCode.INVALID_PARAM, "openId不能为空");
        }

        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getOpenId, openId));
        if (user == null) {
            throw new BizException(ErrorCode.RESOURCE_NOT_FOUND, "用户不存在，openId=" + openId);
        }
        if (user.getStatus() == 0) {
            throw new BizException(ErrorCode.FORBIDDEN, "账号已被禁用");
        }

        StpUtil.login(user.getId());
        StpUtil.getSession().set("roleType", user.getRoleType());

        WechatLoginVO vo = new WechatLoginVO();
        vo.setToken(StpUtil.getTokenValue());
        vo.setRefreshToken(IdUtil.fastSimpleUUID());
        vo.setExpiresIn(7200);
        vo.setUserInfo(buildUserInfoVO(user));
        return vo;
    }

    private String resolveOpenId(String code) {
        // TODO: 对接真实微信 code2session
        return "real_" + code;
    }

    // ============================================================
    //  管理员后台密码登录
    //  · 仅 roleType=admin · BCrypt · 失败 5 次锁 15 分钟
    // ============================================================
    private static final int MAX_FAILED = 5;
    private static final int LOCK_MINUTES = 15;

    @Override
    public WechatLoginVO adminLogin(AdminLoginReq req) {
        String mobile = req.getMobile();
        String adminLimitKey = "rl:auth:admin:" + mobile;
        RateLimitProperties.Rule adminRule = rateLimitProperties.getAdminLogin();
        long adminReqCount = rateLimitService.incrementAndGet(adminLimitKey, adminRule.getWindowSeconds());
        if (adminReqCount > adminRule.getLimit()) {
            rateLimitService.recordHit("adminLogin");
            log.warn("Rate limit hit: scene=adminLogin, key={}, count={}, limit={}, window={}s",
                    adminLimitKey, adminReqCount, adminRule.getLimit(), adminRule.getWindowSeconds());
            throw new BizException(ErrorCode.TOO_MANY_REQUESTS, "登录请求过于频繁，请稍后重试");
        }
        log.info("adminLogin attempt mobile={}", mobile);

        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getMobile, mobile));

        // 统一以"账号或密码错误"响应, 避免账号枚举
        if (user == null || !"admin".equals(user.getRoleType())) {
            throw new BizException(ErrorCode.INVALID_PARAM, "账号或密码错误");
        }

        // 账号禁用
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BizException(ErrorCode.FORBIDDEN, "账号已被禁用");
        }

        // 锁定检查
        LocalDateTime now = LocalDateTime.now();
        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(now)) {
            throw new BizException(ErrorCode.FORBIDDEN,
                    "账号已锁定, 请于 " + user.getLockedUntil() + " 后重试");
        }

        // 密码校验
        String hash = user.getPasswordHash();
        boolean ok = hash != null && !hash.isBlank()
                && BCrypt.checkpw(req.getPassword(), hash);

        if (!ok) {
            int failed = (user.getFailedCount() == null ? 0 : user.getFailedCount()) + 1;
            User patch = new User();
            patch.setId(user.getId());
            if (failed >= MAX_FAILED) {
                patch.setLockedUntil(now.plusMinutes(LOCK_MINUTES));
                patch.setFailedCount(0);
                log.warn("Admin account locked due to {} failures: userId={} mobile={}",
                        MAX_FAILED, user.getId(), mobile);
            } else {
                patch.setFailedCount(failed);
            }
            userMapper.updateById(patch);
            throw new BizException(ErrorCode.INVALID_PARAM, "账号或密码错误");
        }

        // 登录成功: 清零失败计数 + 记录最近登录
        User patch = new User();
        patch.setId(user.getId());
        patch.setFailedCount(0);
        patch.setLockedUntil(null);
        patch.setLastLoginAt(now);
        patch.setLastLoginIp(resolveClientIp());
        userMapper.updateById(patch);

        // 发 token
        StpUtil.login(user.getId());
        StpUtil.getSession().set("roleType", user.getRoleType());

        WechatLoginVO vo = new WechatLoginVO();
        vo.setToken(StpUtil.getTokenValue());
        vo.setRefreshToken(IdUtil.fastSimpleUUID());
        vo.setExpiresIn(7200);
        // 回填 user 的更新字段供 VO 构建
        user.setLastLoginAt(now);
        vo.setUserInfo(buildUserInfoVO(user));

        log.info("adminLogin success userId={} mobile={}", user.getId(), mobile);
        return vo;
    }

    // ============================================================
    //  登出
    //  · StpUtil.logout() 会清 Redis session + 写 Set-Cookie: satoken=; Max-Age=0
    //  · 未登录为幂等空操作
    // ============================================================
    @Override
    public void logout() {
        if (StpUtil.isLogin()) {
            Object loginId = StpUtil.getLoginId();
            StpUtil.logout();
            log.info("logout userId={}", loginId);
        }
    }

    /** 从当前 HTTP 请求取客户端 IP (尽力而为, 找不到返回 null) */
    private String resolveClientIp() {
        try {
            org.springframework.web.context.request.RequestAttributes attrs =
                    org.springframework.web.context.request.RequestContextHolder
                            .getRequestAttributes();
            if (attrs instanceof org.springframework.web.context.request.ServletRequestAttributes sra) {
                jakarta.servlet.http.HttpServletRequest request = sra.getRequest();
                String forwarded = request.getHeader("X-Forwarded-For");
                if (forwarded != null && !forwarded.isBlank()) {
                    return forwarded.split(",")[0].trim();
                }
                return request.getRemoteAddr();
            }
        } catch (Exception ignored) {
            // 静默
        }
        return null;
    }

    private String buildWechatLimitKey(WechatLoginReq req) {
        String code = req.getCode() != null ? req.getCode() : "";
        if (stubMode) {
            // stub 模式下 code 为稳定设备锚点，按 code 限流即可
            return "rl:auth:wechat:stub:" + code;
        }
        // 真实微信 code 一次性且短时有效，不能仅按 code 限流；改为 IP 维度兜底
        String ip = resolveClientIp();
        if (ip == null || ip.isBlank()) {
            ip = "unknown";
        }
        return "rl:auth:wechat:ip:" + ip;
    }
}
