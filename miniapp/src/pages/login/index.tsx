import { View, Text, Button, Input } from '@tarojs/components'
import Taro, { useLoad, useUnload } from '@tarojs/taro'
import { useMemo, useRef, useState } from 'react'
import { wechatLogin } from '@/api/auth'
import { useAuthStore } from '@/store/auth'
import { getCurrentSolarTerm } from '@/lib/solar-terms'
import './index.scss'

/**
 * §0 · 登录页
 * ============================================================
 *  1. onLoad: 已有 token 直跳 /pages/adoptions/index
 *  2. 点按钮: 取稳定 deviceId → POST /auth/wechat-login → 存 token/userInfo
 *     → redirectTo /pages/adoptions/index
 *
 *  ⚠ 为什么不直接用 Taro.login() 的 code:
 *    wx.login() 每次返回的 code 都是新的 (一次性令牌, 5 分钟过期).
 *    后端 stub-mode 里 openId = "stub_" + code → 每次都是新 openId
 *      → 每次 SELECT user WHERE open_id=? 都查不到
 *      → 每次 INSERT 新用户, 拿到新 userId
 *      → 之前绑到旧 userId 的认养码全查不出来 ("地块消失" bug)
 *    解决: 首次登录生成稳定 UUID 存 Storage, 以后永远用它当 code. 同设备
 *    恒为同一用户. 真微信 API 对接 (resolveOpenId) 上线后, 可切回 wx code.
 * ============================================================ */

const STUB_DEVICE_KEY = 'stub_device_id'

/** 取或生成稳定的 stub 设备标识 · 保证同设备同 userId */
function getOrCreateStubDeviceId(): string {
  // FIX · 原实现 Taro.getStorageSync / setStorageSync 未 try/catch,
  //   Storage 异常 (清数据 / 空间满 / 权限) 会直接抛到 handleLogin 中断登录.
  //   读/写任一失败都回退到内存生成, 保证登录不卡.
  let id = ''
  try {
    id = (Taro.getStorageSync(STUB_DEVICE_KEY) as string) || ''
  } catch (e) {
    console.warn('[LoginPage] getStorage failed', e)
  }
  if (!id) {
    id = `dev-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`
    try {
      Taro.setStorageSync(STUB_DEVICE_KEY, id)
      console.log('[LoginPage] first launch, new stub deviceId =', id)
    } catch (e) {
      console.warn('[LoginPage] setStorage failed, running in memory only', e)
    }
  }
  return id
}

/**
 * FIX · `Taro.login()` 在以下场景会永久挂起 (既不 resolve 也不 reject):
 *   · devtools 未登录测试号
 *   · appid 非法 / 真机调试断网
 *   · 微信 session_key 刷新链路被拦截
 * stub-mode 下其 code 并不参与身份判断, 超时即可跳过, 不影响业务.
 *
 * 做法: Promise.race 加 3s 超时. 超时则按 'skip' 处理, 继续走 stub 登录.
 */
function wxLoginWithTimeout(ms = 3000): Promise<'ok' | 'skip'> {
  return new Promise((resolve) => {
    const timer = setTimeout(() => {
      console.warn(`[LoginPage] Taro.login timeout > ${ms}ms · 跳过 wx.login`)
      resolve('skip')
    }, ms)
    Taro.login()
      .then(() => {
        clearTimeout(timer)
        resolve('ok')
      })
      .catch((e) => {
        clearTimeout(timer)
        console.warn('[LoginPage] Taro.login warn (stub-mode 下可忽略):', e)
        resolve('skip')
      })
  })
}
export default function LoginPage() {
  const [loading, setLoading] = useState(false)
  const [errMsg, setErrMsg] = useState<string>('')
  const [stubInput, setStubInput] = useState('')
  const [stubApplied, setStubApplied] = useState('')
  const setAuth = useAuthStore((s) => s.setAuth)
  // N1+N2 · ref 瞬时锁, 比 state 早一帧生效; 成功路径保持锁到 switchTab 生效
  const loadingRef = useRef(false)
  // 当前节气 + 农谚 · 让封面每月打开长得不一样 (2026-04-29 前后看到 "谷雨")
  const term = useMemo(() => getCurrentSolarTerm(), [])
  // S3 · 登录成功后 320ms 的导航延迟若期间触发 40002 会清 token,
  //      http.ts 拦截器会另发起 redirectTo('/pages/login'), 两次 navigation 互相覆盖,
  //      真机表现为 "登录成功闪一下又弹回登录页". 用 ref 管 timer + 跳转前再校 token.
  const navigateTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useUnload(() => {
    if (navigateTimerRef.current) {
      clearTimeout(navigateTimerRef.current)
      navigateTimerRef.current = null
    }
  })

  useLoad(() => {
    // hydrate 已经在 app.tsx 的 useLaunch 跑过, 这里只读
    const { token } = useAuthStore.getState()
    if (token) {
      // adoptions 是 tabBar 页, 用 switchTab
      Taro.switchTab({ url: '/pages/adoptions/index' }).catch(() =>
        Taro.redirectTo({ url: '/pages/adoptions/index' }),
      )
    }
    const currentStub = getOrCreateStubDeviceId()
    setStubInput(currentStub)
    setStubApplied(currentStub)
  })

  function applyStubDeviceId() {
    const next = stubInput.trim()
    if (!next) {
      Taro.showToast({ title: '请输入 stub_device_id', icon: 'none' })
      return
    }
    try {
      Taro.setStorageSync(STUB_DEVICE_KEY, next)
      setStubApplied(next)
      Taro.showToast({ title: '已应用，登录即生效', icon: 'none' })
    } catch {
      Taro.showToast({ title: '写入失败，请重试', icon: 'none' })
    }
  }

  async function handleLogin() {
    // N2 · ref 锁比 state 早一帧生效, 兑提极快双击
    if (loadingRef.current) return
    loadingRef.current = true
    // N1 · 登录成功后还要等 600ms setTimeout 跳转; 这期间保持锁, 防重复登录
    let keepLocked = false
    setLoading(true)
    setErrMsg('')

    const t0 = Date.now()
    try {
      // 1. 先触发 wx.login · 只是为了激活 session_key (保持未来真微信 API 可用);
      //    其 code 在当前 stub-mode 下并不被用来决定身份, 见文件顶部注释.
      //   FIX · 加 3s 超时兜底, 避免 wx.login 挂起 (devtools 未登录 / appid 非法 /
      //         网络中断等) 导致整个登录按钮卡在 "Signing in…" 不动的致命 UX bug.
      const wxStatus = await wxLoginWithTimeout(3000)
      console.log(`[LoginPage] wx.login ${wxStatus} · ${Date.now() - t0}ms`)

      // 2. 取稳定 deviceId 作为后端识别码 · 同设备恒为同一 userId
      const stableCode = getOrCreateStubDeviceId()
      console.log('[LoginPage] login with stableCode=', stableCode)

      // 3. 换 token + userInfo
      const res = await wechatLogin(stableCode)
      console.log(`[LoginPage] wechatLogin ok · total ${Date.now() - t0}ms`)
      setAuth(res.token, res.userInfo)
      console.log('[LoginPage] setAuth done · userId=', res.userInfo?.userId)

      // 4. 跳认养列表 · adoptions 是 tabBar 页 · 用 switchTab
      Taro.showToast({ title: '登录成功', icon: 'success', duration: 800 })
      keepLocked = true
      // 短延迟：给 toast 一帧；导航失败必须打日志（此前 catch 里静默 → 控制台停在 wechatLogin ok，像「挂了」）
      // S3 · ref 托管 timer + 跳转前再校 token. 若期间 40002 清 token 则放弃本次导航,
      //      避免和拦截器发起的 redirectTo 竞态
      if (navigateTimerRef.current) clearTimeout(navigateTimerRef.current)
      navigateTimerRef.current = setTimeout(() => {
        navigateTimerRef.current = null
        void (async () => {
          console.log('[LoginPage] navigate → adoptions · begin')
          // S3 · 跳转前再确认 token 还在, 否则说明已被 40002 清掉, 不和拦截器抢路由
          if (!useAuthStore.getState().token) {
            console.warn('[LoginPage] token lost during navigate delay · abort switchTab')
            keepLocked = false
            loadingRef.current = false
            setLoading(false)
            return
          }
          try {
            await Taro.switchTab({ url: '/pages/adoptions/index' })
            console.log('[LoginPage] switchTab ok')
          } catch (e1) {
            console.warn('[LoginPage] switchTab failed · fallback redirectTo', e1)
            try {
              await Taro.redirectTo({ url: '/pages/adoptions/index' })
              console.log('[LoginPage] redirectTo ok')
            } catch (e2) {
              console.error('[LoginPage] redirectTo failed · fallback reLaunch', e2)
              try {
                await Taro.reLaunch({ url: '/pages/adoptions/index' })
                console.log('[LoginPage] reLaunch ok')
              } catch (e3) {
                console.error('[LoginPage] reLaunch failed · user stays on login', e3)
                keepLocked = false
                loadingRef.current = false
                setLoading(false)
              }
            }
          }
        })()
      }, 320)
    } catch (e) {
      const msg = e instanceof Error ? e.message : '登录失败'
      setErrMsg(msg)
      Taro.showToast({ title: msg, icon: 'none' })
    } finally {
      // 失败路径释放锁让用户重试; 成功路径保持到页面 unload
      if (!keepLocked) {
        setLoading(false)
        loadingRef.current = false
      }
    }
  }

  return (
    <View className='login-page'>
      {/* --- 封面印章 --- */}
      <View className='login-cover'>
        <Text className='login-cover__seal'>§ 00 · LONGARCH</Text>
        <Text className='login-cover__title'>陇上管家</Text>
        <Text className='login-cover__title-cn'>Longarch · Folio</Text>
        <Text className='login-cover__lede'>
          认养一块田，看它慢慢长大
        </Text>
        {/* 节气印章 · 让封面按月呼吸, 每月进入都看到不同的时节标记 */}
        <View className='login-cover__term'>
          <Text className='login-cover__term-mark'>〈 {term.name} 〉</Text>
          <Text className='login-cover__term-saying'>— {term.saying}</Text>
        </View>
      </View>

      {/* --- 特性表 (hairline 行, 简化为单列) --- */}
      <View className='login-features'>
        <View className='login-feature'>
          <Text className='login-feature__no'>01</Text>
          <View className='login-feature__body'>
            <Text className='login-feature__title'>实时监测</Text>
            <Text className='login-feature__sub'>温湿 · 光照 · 土壤数据</Text>
          </View>
        </View>

        <View className='login-feature'>
          <Text className='login-feature__no'>02</Text>
          <View className='login-feature__body'>
            <Text className='login-feature__title'>远程看田</Text>
            <Text className='login-feature__sub'>手机查看现场画面</Text>
          </View>
        </View>

        <View className='login-feature'>
          <Text className='login-feature__no'>03</Text>
          <View className='login-feature__body'>
            <Text className='login-feature__title'>可信溯源</Text>
            <Text className='login-feature__sub'>种 · 养 · 收 · 全程可查</Text>
          </View>
        </View>
      </View>

      {/* --- 错误提示 --- */}
      {errMsg ? <Text className='login-err'>! {errMsg}</Text> : null}

      {/* --- 底部 CTA --- */}
      <View className='login-bottom'>
        <Button
          className='login-cta'
          loading={loading}
          disabled={loading}
          onClick={handleLogin}
        >
          <Text className='login-cta__label'>
            {loading ? '进入中…' : '微信一键登录'}
          </Text>
          <Text className='login-cta__arrow'>→</Text>
        </Button>

        <Button
          className='login-adopter'
          disabled={loading}
          onClick={() => Taro.navigateTo({ url: '/pages/adopter-login/index' })}
        >
          <Text className='login-adopter__text'>认养用户入口</Text>
          <Text className='login-adopter__arrow'>→</Text>
        </Button>

        <Button
          className='login-operator'
          disabled={loading}
          onClick={() => Taro.navigateTo({ url: '/pages/operator-login/index' })}
        >
          <Text className='login-operator__text'>操作员入口</Text>
          <Text className='login-operator__arrow'>→</Text>
        </Button>

        <Button
          className='login-guest'
          disabled={loading}
          onClick={() => Taro.navigateTo({ url: '/pages/guest-login/index' })}
        >
          <Text className='login-guest__text'>分享码访问</Text>
          <Text className='login-guest__arrow'>→</Text>
        </Button>

        <Text className='login-terms'>
          继续即同意{' '}
          <Text className='login-link'>服务协议</Text>
          {'  ·  '}
          <Text className='login-link'>隐私政策</Text>
        </Text>
      </View>
    </View>
  )
}
