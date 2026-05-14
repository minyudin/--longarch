import { request } from './http'
import type { LoginResponse, UserInfo } from '@/types'

/**
 * Auth API · Miniapp
 * ============================================================
 *  与 longarch-server 的 AuthController 一一对应
 * ============================================================ */

/**
 * API-01 微信登录
 * @param code       wx.login() 返回的 code (stub-mode 下任何字符串均可)
 * @param inviteCode 可选的认养码/邀请码
 */
export function wechatLogin(code: string, inviteCode?: string) {
  return request<LoginResponse>({
    url: '/auth/wechat-login',
    method: 'POST',
    data: { code, inviteCode },
    silent: true, // 登录失败由调用方自行处理 UI
  })
}

/**
 * 游客/分享码登录
 * @param code 分享码/游客码
 */
export function guestLogin(code: string) {
  return request<LoginResponse>({
    url: '/auth/guest-login',
    method: 'POST',
    data: { code },
    silent: true,
  })
}

/**
 * API-02 绑定手机号
 */
export function bindMobile(mobile: string, smsCode: string) {
  return request<{ bound: boolean }>({
    url: '/auth/bind-mobile',
    method: 'POST',
    data: { mobile, smsCode },
  })
}

/**
 * API-03 获取当前用户信息
 */
export function getCurrentUser() {
  return request<UserInfo>({
    url: '/users/me',
    method: 'GET',
  })
}

/**
 * 登出
 */
export function logout() {
  return request<void>({
    url: '/auth/logout',
    method: 'POST',
  })
}
