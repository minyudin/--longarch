import { View, Text, Button } from '@tarojs/components'
import Taro, { useUnload, useRouter, useDidHide } from '@tarojs/taro'
import { useRef, useState } from 'react'
import { usePageRefresh } from '@/hooks/usePageRefresh'
import { getTaskDetail, getQueueStatus, cancelTask } from '@/api/task'
import type { OperationTaskDetail, TaskStatusValue } from '@/types'
import './index.scss'

/**
 * §4.1 · 任务详情 + 轮询状态机
 * ============================================================
 *  入口: /pages/task-detail/index?taskId=N
 *
 *  轮询策略:
 *    · pending/queued/running → 每 3 秒轮询
 *    · success/failed/cancelled (终态) → 停止
 *    · 页面 unload 时也停止
 * ============================================================ */

const STATUS_STEPS: TaskStatusValue[] = ['pending', 'queued', 'running', 'success']

const STATUS_LABEL: Record<TaskStatusValue, string> = {
  pending: '待处理',
  queued: '已排队',
  running: '执行中',
  success: '已完成',
  failed: '已失败',
  cancelled: '已取消',
}

const STATUS_HINT: Record<TaskStatusValue, string> = {
  pending: '调度中心正在评估',
  queued: '已进入执行队列, 等待设备空闲',
  running: '硬件正在执行中',
  success: '任务已成功完成',
  failed: '任务执行失败',
  cancelled: '任务已取消',
}

function isTerminal(status: TaskStatusValue): boolean {
  return status === 'success' || status === 'failed' || status === 'cancelled'
}

export default function TaskDetailPage() {
  const router = useRouter()
  const taskId = Number(router.params.taskId || 0)

  const [detail, setDetail] = useState<OperationTaskDetail | null>(null)
  const [loading, setLoading] = useState(false)
  const [err, setErr] = useState('')
  const [cancelling, setCancelling] = useState(false)

  const pollTimer = useRef<ReturnType<typeof setInterval> | null>(null)
  // H1 · setInterval 回调里读不到最新 state (closure stale), 用 ref 做单一真相源
  const detailRef = useRef<OperationTaskDetail | null>(null)
  // M4 · 防止双击取消的瞬时锁 (state 更新有一帧延迟)
  const cancellingRef = useRef(false)

  function applyDetail(d: OperationTaskDetail) {
    detailRef.current = d
    setDetail(d)
  }

  // G1 · usePageRefresh 管 useLoad + useDidShow (自动跳首次 show, 避免双拉).
  //      用户从其他页面返回详情页时自动刷新 (例如取消任务后返回).
  // S2 · fetchDetail 内部根据状态决定是否 startPolling, 终态任务不会起 poll.
  usePageRefresh(() => {
    if (!taskId) {
      setErr('参数缺失 · taskId')
      return
    }
    fetchDetail()
  })

  // S2 · 页面被背景化 (用户 navigateTo 跳其它页 或 切到微信后台) 时必须暂停轮询,
  //      否则每 3 秒会持续打空 /queue-status 一直到用户手动返回 或 页面真 unload.
  //      后端压力 + 不要流量浪费 + 拦截器在后台碰到 40002 会误弹 redirect toast.
  useDidHide(() => {
    stopPolling()
  })

  useUnload(() => {
    stopPolling()
  })

  function stopPolling() {
    if (pollTimer.current) {
      clearInterval(pollTimer.current)
      pollTimer.current = null
    }
  }

  function startPolling() {
    stopPolling()
    pollTimer.current = setInterval(async () => {
      try {
        const qs = await getQueueStatus(taskId)
        const cur = detailRef.current
        // 状态变化或尚未拉到详情 → 拉详情; 否则只同步 queueNo / waitMinutes.
        //   FIX · 原本不更新 queueNo, 导致用户排在队列里前进 (比如 5 → 3)
        //         界面一直显 5 直到状态切到 running. 现按 qs 直接 delta 应用.
        if (!cur || qs.taskStatus !== cur.taskStatus) {
          const d = await getTaskDetail(taskId)
          applyDetail(d)
          if (isTerminal(d.taskStatus)) stopPolling()
        } else {
          if (
            qs.queueNo !== cur.queueNo ||
            qs.estimatedWaitMinutes !== cur.estimatedWaitMinutes
          ) {
            applyDetail({
              ...cur,
              queueNo: qs.queueNo,
              estimatedWaitMinutes: qs.estimatedWaitMinutes,
            })
          }
          if (isTerminal(qs.taskStatus)) stopPolling()
        }
      } catch {
        // 忽略一次轮询错 · 不中断
      }
    }, 3000)
  }

  async function fetchDetail() {
    setLoading(true)
    setErr('')
    try {
      const d = await getTaskDetail(taskId)
      applyDetail(d)
      if (!isTerminal(d.taskStatus)) {
        startPolling()
      }
    } catch (e) {
      setErr(e instanceof Error ? e.message : '加载失败')
    } finally {
      setLoading(false)
    }
  }

  async function handleCancel() {
    if (!detail || !detail.cancelable) return
    // M4 · ref 瞬时锁, 比 state 早一帧生效
    if (cancellingRef.current) return
    cancellingRef.current = true
    try {
      const res = await Taro.showModal({
        title: '确认取消任务?',
        content: `${detail.actionName} · ${detail.taskNo}`,
        confirmText: '确认取消',
        cancelText: '再想想',
      })
      if (!res.confirm) return
      setCancelling(true)
      try {
        await cancelTask(taskId, '用户主动取消')
        Taro.showToast({ title: '已取消', icon: 'success', duration: 1200 })
        stopPolling()
        await fetchDetail()
      } catch (e) {
        Taro.showToast({
          title: e instanceof Error ? e.message : '取消失败',
          icon: 'none',
        })
      } finally {
        setCancelling(false)
      }
    } finally {
      cancellingRef.current = false
    }
  }

  if (err) {
    // M3 · 失败态给出重试按钮, 避免用户只能退出页面重进
    return (
      <View className='td-page'>
        <View className='td-err-box'>
          <Text className='td-err-box__seal'>§ ERR</Text>
          <Text className='td-err-box__msg'>{err}</Text>
          <Button
            className='td-err-box__retry'
            loading={loading}
            disabled={loading}
            onClick={fetchDetail}
          >
            <Text>{loading ? '重试中…' : '重试 ↻'}</Text>
          </Button>
          <Button
            className='td-err-box__back'
            onClick={() => Taro.navigateBack()}
          >
            <Text>← 返回</Text>
          </Button>
        </View>
      </View>
    )
  }

  if (!detail && loading) {
    return (
      <View className='td-page'>
        <Text className='td-loading'>加载中...</Text>
      </View>
    )
  }

  if (!detail) {
    return (
      <View className='td-page'>
        <Text className='td-empty'>任务未找到</Text>
      </View>
    )
  }

  const activeStepIdx = STATUS_STEPS.indexOf(detail.taskStatus as TaskStatusValue)
  const isFailed = detail.taskStatus === 'failed'
  const isCancelled = detail.taskStatus === 'cancelled'
  const isRunning = detail.taskStatus === 'running'

  return (
    <View className='td-page'>
      {/* --- 页头 · Folio 印章 --- */}
      <View className='td-head'>
        <Text className='td-head__seal'>§ 04 · 任务详情</Text>
        <Text className='td-head__title'>{detail.actionName}</Text>
        <Text className='td-head__lede'>— {detail.taskNo}</Text>
      </View>

      {/* --- 状态块 (左色带 + 墨字) --- */}
      <View
        className={`td-status td-status--${
          detail.taskStatus === 'success'
            ? 'success'
            : isFailed
            ? 'fail'
            : isCancelled
            ? 'cancel'
            : isRunning
            ? 'running'
            : 'waiting'
        }`}
      >
        <Text className='td-status__label'>当前状态</Text>
        <Text className='td-status__value'>
          {STATUS_LABEL[detail.taskStatus as TaskStatusValue] || detail.taskStatus}
        </Text>
        <Text className='td-status__hint'>
          — {STATUS_HINT[detail.taskStatus as TaskStatusValue]}
        </Text>
        {detail.queueNo && !isTerminal(detail.taskStatus as TaskStatusValue) ? (
          <Text className='td-status__queue'>
            排队 #{detail.queueNo}
            {detail.estimatedWaitMinutes
              ? ` · 约 ${detail.estimatedWaitMinutes} 分钟`
              : ''}
          </Text>
        ) : null}
      </View>

      {/* --- 进度步骤 (仅非失败/取消时展示) --- */}
      {!isFailed && !isCancelled ? (
        <View className='td-steps'>
          {STATUS_STEPS.map((step, idx) => {
            const done = idx <= activeStepIdx
            const current = idx === activeStepIdx
            return (
              <View
                key={step}
                className={`td-step ${done ? 'td-step--done' : ''} ${
                  current ? 'td-step--current' : ''
                }`}
              >
                <View className='td-step__dot'>
                  <Text>{done ? '✓' : idx + 1}</Text>
                </View>
                <Text className='td-step__label'>{STATUS_LABEL[step]}</Text>
              </View>
            )
          })}
        </View>
      ) : null}

      {/* --- 失败原因 --- */}
      {isFailed && detail.failReason ? (
        <View className='td-fail-reason'>
          <Text className='td-fail-reason__label'>失败原因</Text>
          <Text className='td-fail-reason__msg'>{detail.failReason}</Text>
        </View>
      ) : null}

      {/* --- 元信息 --- */}
      <View className='td-meta'>
        <MetaRow k='任务编号' v={detail.taskNo} mono />
        <MetaRow k='操作' v={detail.actionName} />
        <MetaRow k='地块' v={`#${detail.plotId}`} />
        <MetaRow k='设备' v={`#${detail.deviceId}`} />
        <MetaRow k='调度模式' v={detail.schedulingMode} />
        <MetaRow k='提交时间' v={detail.createdAt} mono />
        {detail.queuedAt ? <MetaRow k='排队时间' v={detail.queuedAt} mono /> : null}
        {detail.startedAt ? <MetaRow k='开始时间' v={detail.startedAt} mono /> : null}
        {detail.finishedAt ? <MetaRow k='完成时间' v={detail.finishedAt} mono /> : null}
      </View>

      {/* --- 操作按钮 --- */}
      {detail.cancelable ? (
        <Button
          className='td-action td-action--cancel'
          loading={cancelling}
          disabled={cancelling}
          onClick={handleCancel}
        >
          <Text>取消任务</Text>
        </Button>
      ) : null}

      <Button
        className='td-action td-action--back'
        onClick={() => Taro.navigateBack()}
      >
        <Text>← 返回</Text>
      </Button>
    </View>
  )
}

// ---- 小组件: 元信息行 ----
function MetaRow({ k, v, mono }: { k: string; v: string; mono?: boolean }) {
  return (
    <View className='meta-row'>
      <Text className='meta-row__key'>{k}</Text>
      <Text className={`meta-row__val ${mono ? 'meta-row__val--mono' : ''}`}>
        {v}
      </Text>
    </View>
  )
}
