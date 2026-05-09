import { View, Text } from '@tarojs/components'
import Taro from '@tarojs/taro'
import { useEffect, useRef, useState } from 'react'
import { TAB_BAR_SYNC_EVT } from './events'
import { useAuthStore } from '@/store/auth'
import './index.scss'

/**
 * Custom TabBar · Folio 风
 * ============================================================
 *  位置: src/custom-tab-bar/index.tsx (Taro 约定路径)
 *  当 app.config.ts 的 tabBar.custom === true 时自动启用
 *
 *  设计原则:
 *    - 纯 hairline · 无圆角 · 无阴影
 *    - § 编号 + 衬线字
 *    - 选中项墨色, 未选次级灰
 * ============================================================ */

interface TabItem {
  pagePath: string
  text: string
  seal: string        // §01 · §02 编号
}

const ALL_TABS: TabItem[] = [
  { pagePath: '/pages/operator-workbench/index', text: '工作台', seal: '§ 01' },
  { pagePath: '/pages/adoptions/index', text: '认养', seal: '§ 01' },
  { pagePath: '/pages/ai-assist/index', text: 'AI询问', seal: '§ 02' },
  { pagePath: '/pages/me/index', text: '我的', seal: '§ 03' },
]

function getVisibleTabs(roleType: string | undefined | null): TabItem[] {
  if (roleType === 'operator') {
    return [
      { pagePath: '/pages/operator-workbench/index', text: '工作台', seal: '§ 01' },
      { pagePath: '/pages/me/index', text: '我的', seal: '§ 02' },
    ]
  }
  // M6 · guest 是分享码进入的临时用户: 没有认养订单, AI 询问也用不到.
  //      主体验在 plot 详情页 (guest-login 已 redirectTo 过去), 但用户从 plot 按返回
  //      键会落到 tabBar 页; 此时若用 adopter 的 3 个 tab, "认养" 列表永远空, "AI询问"
  //      也不便访问地块上下文. 只留 "我的" 作为身份 / 退出入口, 避免体验错位.
  if (roleType === 'guest') {
    return [
      { pagePath: '/pages/me/index', text: '我的', seal: '§ 01' },
    ]
  }
  return [
    { pagePath: '/pages/adoptions/index', text: '认养', seal: '§ 01' },
    { pagePath: '/pages/ai-assist/index', text: 'AI询问', seal: '§ 02' },
    { pagePath: '/pages/me/index', text: '我的', seal: '§ 03' },
  ]
}

const TRANSITION_KEY = 'tab_transition_overlay'
const TRANSITION_MS = 980

type TransitionPayload = {
  showUntil: number
  title: string
  seal: string
}

// 挂载前就算出当前选中, 避免 "先 selected=0, useEffect 后再跳 idx" 的首帧闪烁
function computeInitialSelected(tabs: TabItem[]): number {
  try {
    const pages = Taro.getCurrentPages()
    const current = pages[pages.length - 1]
    if (!current) return 0
    const path = `/${(current as { route?: string }).route || ''}`
    const idx = tabs.findIndex((t) => t.pagePath === path)
    return idx >= 0 ? idx : 0
  } catch {
    return 0
  }
}

export default function CustomTabBar() {
  const roleType = useAuthStore((s) => s.userInfo?.roleType)
  const tabs = getVisibleTabs(roleType)

  // useState 接受函数 (lazy init), 首次渲染前算一次 · 第一道防线
  const [selected, setSelected] = useState<number>(() => computeInitialSelected(tabs))
  const [showTransition, setShowTransition] = useState(false)
  const [transitionTitle, setTransitionTitle] = useState('Module')
  const [transitionSeal, setTransitionSeal] = useState('§ ·')
  /** handleTap 启动的全屏转场兜底收起，避免 switchTab 失败 / 子页 tabBar 未接力时永久遮罩 */
  const tapFallbackTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const storageRelayTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  function clearTapFallbackTimer() {
    if (tapFallbackTimerRef.current) {
      clearTimeout(tapFallbackTimerRef.current)
      tapFallbackTimerRef.current = null
    }
  }

  function clearStorageRelayTimer() {
    if (storageRelayTimerRef.current) {
      clearTimeout(storageRelayTimerRef.current)
      storageRelayTimerRef.current = null
    }
  }

  // 第二道防线:
  //  · 挂载完成后再兜底算一次 (此时页面栈通常已刷新)
  //  · 订阅 tab 页 useDidShow 发的事件, 由页面主动告知 idx (最可靠)
  useEffect(() => {
    // 兜底: 与 lazy init 不同, 这里是 commit 后, getCurrentPages 更可靠
    const fresh = computeInitialSelected(tabs)
    setSelected((prev) => (prev === fresh ? prev : fresh))

    const handler = (payload: unknown) => {
      // 新契约: pagePath 优先; 兼容旧的 idx (万一有漏改页面)
      if (typeof payload === 'string') {
        const idx = tabs.findIndex((t) => t.pagePath === payload)
        if (idx >= 0) setSelected((prev) => (prev === idx ? prev : idx))
        return
      }
      if (typeof payload === 'number') {
        const idx = payload
        if (idx < 0 || idx >= tabs.length) return
        setSelected((prev) => (prev === idx ? prev : idx))
      }
    }
    Taro.eventCenter.on(TAB_BAR_SYNC_EVT, handler)

    // 跨页面接力：新页面 tabBar 挂载后，从 storage 读取正在进行中的转场
    try {
      const payload = Taro.getStorageSync(TRANSITION_KEY) as TransitionPayload | undefined
      if (payload?.showUntil && payload.showUntil > Date.now()) {
        setTransitionTitle(payload.title || 'Module')
        setTransitionSeal(payload.seal || '§ ·')
        setShowTransition(true)
        const remain = Math.max(120, payload.showUntil - Date.now())
        clearStorageRelayTimer()
        storageRelayTimerRef.current = setTimeout(() => {
          storageRelayTimerRef.current = null
          setShowTransition(false)
          try {
            Taro.removeStorageSync(TRANSITION_KEY)
          } catch {}
        }, remain)
      }
    } catch {}

    return () => {
      Taro.eventCenter.off(TAB_BAR_SYNC_EVT, handler)
      clearStorageRelayTimer()
      clearTapFallbackTimer()
    }
  }, [roleType]) // role 变更时重算一次

  // role 切换时(登出/换号)同步 selected 到当前 route 的正确 idx
  useEffect(() => {
    const fresh = computeInitialSelected(tabs)
    setSelected(fresh)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [roleType])

  function handleTap(idx: number) {
    if (idx === selected) return
    clearTapFallbackTimer()
    // 1. 先改本实例选中态 · 同步落地, 视觉反馈立即
    setSelected(idx)
    const target = tabs[idx]
    const payload: TransitionPayload = {
      showUntil: Date.now() + TRANSITION_MS,
      title: target.text,
      seal: target.seal,
    }
    setTransitionTitle(payload.title)
    setTransitionSeal(payload.seal)
    setShowTransition(true)
    try {
      Taro.setStorageSync(TRANSITION_KEY, payload)
    } catch {}
    // 无论目标页 tabBar 是否接力成功，超时后必须收起转场层（否则全屏 z-index 遮罩卡死）
    tapFallbackTimerRef.current = setTimeout(() => {
      tapFallbackTimerRef.current = null
      setShowTransition(false)
      try {
        Taro.removeStorageSync(TRANSITION_KEY)
      } catch {}
    }, TRANSITION_MS + 400)

    const restoreSelection = () => {
      const back = computeInitialSelected(tabs)
      setSelected(back)
    }

    // 2. 再发起 switchTab · 新页面的 tabBar 实例会在 useDidShow 里收到 sync 事件
    Taro.switchTab({ url: target.pagePath })
      .then(() => {
        // 目标页已切换；转场仍由 storage 接力或兜底定时器收束，这里不提前关以免闪断
      })
      .catch(() =>
        Taro.redirectTo({ url: target.pagePath }).catch(() => {
          clearTapFallbackTimer()
          setShowTransition(false)
          try {
            Taro.removeStorageSync(TRANSITION_KEY)
          } catch {}
          restoreSelection()
        }),
      )
  }

  return (
    <>
      {showTransition ? (
        <View className='tab-transition' aria-hidden>
          <View className='tab-transition__inner'>
            <View className='tab-transition__ring'>
              <View className='tab-transition__ring-outer' />
              <View className='tab-transition__ring-inner' />
            </View>
            <View className='tab-transition__mark'>
              <Text className='tab-transition__mark-chapter'>{transitionSeal}</Text>
              <Text className='tab-transition__mark-sep'>·</Text>
              <Text className='tab-transition__mark-title'>{transitionTitle}</Text>
            </View>
          </View>
        </View>
      ) : null}
      <View className='tab-bar'>
        {tabs.map((tab, idx) => {
          const active = idx === selected
          return (
            <View
              key={tab.pagePath}
              className={`tab-bar__item ${active ? 'tab-bar__item--active' : ''}`}
              onClick={() => handleTap(idx)}
            >
              <Text className='tab-bar__seal'>{tab.seal}</Text>
              <Text className='tab-bar__label'>{tab.text}</Text>
            </View>
          )
        })}
      </View>
    </>
  )
}
