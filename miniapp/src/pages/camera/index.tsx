import { View, Text, WebView } from '@tarojs/components'
import Taro, { useLoad, useRouter, useUnload, useDidShow } from '@tarojs/taro'
import { useEffect, useMemo, useRef, useState } from 'react'
import './index.scss'

/**
 * §5 · 摄像头直播 (WebView + H5 flv.js/hls.js 路线)
 * ============================================================
 *  入口: /pages/camera/index?cameraId=X&cameraName=Y&flvUrl=Z(已编码)&hlsUrl=W
 *
 *  架构:
 *    摄像头 ─RTMP push→ SRS ─HTTP-FLV/HLS→ nginx (HTTPS+备案域名)
 *                                              │
 *                                              ├─ /live/xxx.flv
 *                                              ├─ /live/xxx.m3u8
 *                                              └─ /play.html   (引入 flv.js/hls.js)
 *                                                    ▲
 *                                                    │
 *                                    <web-view src=${H5_BASE}/play.html?url=xxx>
 *
 *  为什么走 web-view 而不是原生 <live-player>:
 *    · <live-player> 要求小程序有"直播"类目 (农业类目不在白名单)
 *    · <live-player> 企业主体才能用, 个人号直接没权限
 *    · <web-view> 个人号也能用, 只需要业务域名白名单 (备案 HTTPS)
 *
 *  降级占位:
 *    TARO_APP_CAMERA_H5_BASE 未配置时, 不加载 webview, 显示"待配置"提示,
 *    仍把 flvUrl 明文展示出来让用户能在 admin 大屏或电脑浏览器里测试.
 * ============================================================ */
export default function CameraPage() {
  const router = useRouter()
  const cameraId = Number(router.params.cameraId || 0)
  const flvUrl = decodeParam(router.params.flvUrl)
  const hlsUrl = decodeParam(router.params.hlsUrl)
  const cameraName = decodeParam(router.params.cameraName) || `摄像头 #${cameraId}`

  const h5Base = process.env.TARO_APP_CAMERA_H5_BASE

  const [loadError, setLoadError] = useState('')
  // L2 · webview 的 onLoad/onError 在不同基础库稳定度不一, 用 8s timeout 兜底
  const loadTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const loadedRef = useRef(false)

  useLoad(() => {
    console.log('[CameraPage] useLoad', {
      cameraId,
      cameraName,
      flvUrl,
      hlsUrl,
      h5Base,
    })
  })

  // N92 · 用户从 webview 错误页面返回时重置 loadError, 让 webview 能重新尝试加载
  useDidShow(() => {
    if (loadError) {
      setLoadError('')
      loadedRef.current = false
    }
  })

  useUnload(() => {
    if (loadTimerRef.current) clearTimeout(loadTimerRef.current)
  })

  // 组装 webview src: 优先 flv, fallback hls
  const webviewSrc = useMemo(() => {
    if (!h5Base) return ''
    if (!flvUrl && !hlsUrl) return ''
    const url = flvUrl || hlsUrl
    const qs = new URLSearchParams({
      url: url as string,
      name: cameraName,
    }).toString()
    return `${h5Base}/play.html?${qs}`
  }, [h5Base, flvUrl, hlsUrl, cameraName])

  function handleMessage(e: { detail: { data: unknown } }) {
    // H5 页可以 postMessage 回小程序 (仅在 webview 卸载/分享/后退时批量送达)
    console.log('[CameraPage] webview message', e.detail)
  }

  function handleLoadError(e: unknown) {
    console.error('[CameraPage] webview load error', e)
    setLoadError('H5 播放页加载失败, 检查业务域名是否已加白名单')
    if (loadTimerRef.current) clearTimeout(loadTimerRef.current)
  }

  function handleLoadSuccess(e: unknown) {
    console.log('[CameraPage] webview loaded', e)
    loadedRef.current = true
    if (loadTimerRef.current) {
      clearTimeout(loadTimerRef.current)
      loadTimerRef.current = null
    }
  }

  // L2 · webview 开始加载后启动 8 秒 timeout, 既兜 onError 不触发的老基础库
  //      也兜 DNS/备案/CDN 层的慢路径. 成功 onLoad 或用户主动 back 都会清掉.
  useEffect(() => {
    if (!webviewSrc) return
    if (loadTimerRef.current) clearTimeout(loadTimerRef.current)
    loadedRef.current = false
    loadTimerRef.current = setTimeout(() => {
      if (!loadedRef.current) {
        setLoadError('H5 播放页加载超时, 请检查备案域名或网络')
      }
    }, 8000)
    return () => {
      if (loadTimerRef.current) clearTimeout(loadTimerRef.current)
    }
  }, [webviewSrc])

  // ---- 渲染分支 ----

  // 1. 完全没配 H5 域名 → 占位 + 提示 + 明文 URL
  if (!h5Base) {
    return (
      <View className='camera-fallback'>
        <View className='camera-fallback__head'>
          <Text className='camera-fallback__seal'>§ 05 · 摄像头</Text>
          <Text className='camera-fallback__title'>{cameraName}</Text>
          <Text className='camera-fallback__sub'>
            直播 H5 页尚未配置 (TARO_APP_CAMERA_H5_BASE 为空)
          </Text>
        </View>

        <View className='camera-fallback__card'>
          <Text className='camera-fallback__label'>FLV URL</Text>
          <Text className='camera-fallback__url' selectable>
            {flvUrl || '—'}
          </Text>

          <Text className='camera-fallback__label'>HLS URL</Text>
          <Text className='camera-fallback__url' selectable>
            {hlsUrl || '—'}
          </Text>

          <Text className='camera-fallback__hint'>
            · 备案域名配好后, 在 .env 里设 TARO_APP_CAMERA_H5_BASE=https://yourdomain.com 即可
          </Text>
          <Text className='camera-fallback__hint'>
            · 当前可在 admin-next 大屏或浏览器 flv.js demo 里播放上述 URL 验证流通
          </Text>
        </View>
      </View>
    )
  }

  // 2. 配了 H5 但没拿到 url → 错误占位
  if (!flvUrl && !hlsUrl) {
    return (
      <View className='camera-fallback'>
        <View className='camera-fallback__head'>
          <Text className='camera-fallback__seal'>§ 05 · 摄像头 · 异常</Text>
          <Text className='camera-fallback__title'>{cameraName}</Text>
          <Text className='camera-fallback__sub'>
            未收到直播 URL 参数, 请从 task 页「查看直播」按钮重新进入
          </Text>
        </View>
      </View>
    )
  }

  // 3. H5 已配 + URL 齐全 → 全屏 webview
  return (
    <View className='camera-stage'>
      <WebView
        src={webviewSrc}
        onMessage={handleMessage}
        onLoad={handleLoadSuccess}
        onError={handleLoadError}
      />
      {loadError ? (
        <View className='camera-stage__err'>
          <Text>{loadError}</Text>
        </View>
      ) : null}
    </View>
  )
}

// ---- 辅助 ----
function decodeParam(raw: string | undefined): string {
  if (!raw) return ''
  try {
    return decodeURIComponent(raw)
  } catch {
    return raw
  }
}
