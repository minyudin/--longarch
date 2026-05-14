import { View, Text, Input, Button, ScrollView } from '@tarojs/components'
import Taro, { useLoad, useDidShow, useUnload } from '@tarojs/taro'
import { useMemo, useRef, useState } from 'react'
import { aiGeneralChat, genSessionId, INTENT_LABEL } from '@/api/ai'
import { useRequireRole } from '@/hooks/useRequireRole'
import type { AiChatResponse } from '@/types'
import { TAB_BAR_SYNC_EVT } from '@/custom-tab-bar/events'
import './index.scss'

type Msg =
  | { kind: 'user'; id: string; text: string }
  | { kind: 'ai'; id: string; response: AiChatResponse }
  | { kind: 'system'; id: string; text: string }

function mkId(prefix: string): string {
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`
}

export default function AiAssistPage() {
  const sessionIdRef = useRef(genSessionId())
  const [messages, setMessages] = useState<Msg[]>([])
  const [input, setInput] = useState('')
  const [sending, setSending] = useState(false)
  const sendingRef = useRef(false)
  const [scrollTop, setScrollTop] = useState(0)
  // M1 · scrollToBottom setTimeout 未 cleanup, 累计后 unmount 会 setState 告警, 用 ref 托管
  const scrollTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const hints = useMemo(
    () => ['番茄怎么科学浇水?', '黄瓜施肥频率建议?', '高温天气怎么管理大棚?', '常见病虫害怎么预防?'],
    [],
  )

  // G2 · adopter/guest 可用, operator → 工作台; 无 token → 登录页 (hook 管 useLoad+useDidShow 两堆守卫)
  useRequireRole(['adopter', 'guest'])

  useLoad(() => {
    // G2 hook 已管守卫, 这里只负责欢迎语初始化
    setMessages([
      {
        kind: 'system',
        id: 'welcome',
        text: '这里是全局 AI 询问，不绑定具体地块，回答基础农业问题与通用建议。',
      },
    ])
  })

  useDidShow(() => {
    // tabBar 同步 · 角色守卫交给 useRequireRole
    Taro.eventCenter.trigger(TAB_BAR_SYNC_EVT, '/pages/ai-assist/index')
  })

  useUnload(() => {
    if (scrollTimerRef.current) {
      clearTimeout(scrollTimerRef.current)
      scrollTimerRef.current = null
    }
  })

  function scrollToBottom() {
    // M1 · ref 托管 setTimeout, unload 时清; 避免 unmount 后 setState
    if (scrollTimerRef.current) clearTimeout(scrollTimerRef.current)
    scrollTimerRef.current = setTimeout(() => {
      scrollTimerRef.current = null
      setScrollTop((x) => x + 99999)
    }, 30)
  }

  async function handleSend() {
    const text = input.trim()
    if (!text || sendingRef.current) return
    sendingRef.current = true
    setSending(true)
    setInput('')
    setMessages((prev) => [...prev, { kind: 'user', id: mkId('u'), text }])
    scrollToBottom()
    try {
      const resp = await aiGeneralChat({ sessionId: sessionIdRef.current, message: text })
      setMessages((prev) => [...prev, { kind: 'ai', id: mkId('a'), response: resp }])
      scrollToBottom()
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'AI 服务暂不可用'
      setMessages((prev) => [...prev, { kind: 'system', id: mkId('s'), text: msg }])
      setInput(text)
    } finally {
      sendingRef.current = false
      setSending(false)
    }
  }

  return (
    <View className='ai-assist-page'>
      <View className='ai-assist-head'>
        <Text className='ai-assist-head__seal'>§ 02 · AI 问答</Text>
        <Text className='ai-assist-head__title'>AI询问</Text>
        <Text className='ai-assist-head__lede'>— 基础农业问答 · 不绑定地块</Text>
      </View>

      <ScrollView className='ai-assist-thread' scrollY scrollTop={scrollTop} scrollWithAnimation>
        {messages.map((m) => {
          if (m.kind === 'user') {
            return (
              <View key={m.id} className='bubble bubble--user'>
                <Text className='bubble__text'>{m.text}</Text>
              </View>
            )
          }
          if (m.kind === 'system') {
            return (
              <View key={m.id} className='bubble-sys'>
                <Text>{m.text}</Text>
              </View>
            )
          }
          return (
            <View key={m.id} className='bubble bubble--ai'>
              {m.response.intent && m.response.intent !== 'general_query' ? (
                <Text className='bubble__intent'>意图 · {INTENT_LABEL[m.response.intent] || m.response.intent}</Text>
              ) : null}
              <Text className='bubble__text'>{m.response.reply}</Text>
              {m.response.suggestion ? <Text className='bubble__hint'>— {m.response.suggestion}</Text> : null}
            </View>
          )
        })}
      </ScrollView>

      <View className='ai-assist-hints'>
        {hints.map((h) => (
          <Text key={h} className='ai-assist-hints__item' onClick={() => setInput(h)}>
            {h}
          </Text>
        ))}
      </View>

      <View className='ai-assist-input'>
        <Input
          className='ai-assist-input__field'
          value={input}
          placeholder='输入农业问题，例如：番茄叶片发黄怎么办'
          maxlength={200}
          disabled={sending}
          onInput={(e: { detail: { value: string } }) => setInput(e.detail.value)}
          confirmType='send'
          onConfirm={handleSend}
        />
        <Button className='ai-assist-input__send' disabled={sending || !input.trim()} onClick={handleSend}>
          <Text>{sending ? '…' : 'SEND'}</Text>
        </Button>
      </View>
    </View>
  )
}

