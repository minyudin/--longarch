import { View, Text, Button } from '@tarojs/components'
import Taro, { useRouter, usePullDownRefresh } from '@tarojs/taro'
import { useRef, useState } from 'react'
import { usePageRefresh } from '@/hooks/usePageRefresh'
import GrowthStageBar from '@/components/GrowthStageBar'
import {
  resolveThreshold,
  thresholdCursorPercent,
  isValueSafe,
} from '@/lib/sensor-thresholds'
import {
  getPlotDetail,
  getSensorSummary,
  getFarmingRecords,
  getOperationLogs,
} from '@/api/plot'
import { getLatestAnalysis, triggerAnalysis } from '@/api/ai'
import { useAuthStore } from '@/store/auth'
import type {
  PlotDetail,
  SensorSummary,
  FarmingRecord,
  OperationTaskListItem,
  TaskStatusValue,
  AiAnalysis,
} from '@/types'
import SensorChart from './SensorChart'
import './index.scss'

/**
 * §2 · 地块详情 · Plot Detail
 * ============================================================
 *  入口: /pages/plot/index?plotId=X&plotName=Y
 *
 *  数据:
 *    - GET /plots/{id}                (PlotDetail + currentCropBatch)
 *    - GET /plots/{id}/sensor-summary  (当前传感器读数)
 *    - GET /plots/{id}/farming-records (最近农事)
 *    - GET /plots/{id}/operation-logs  (最近操作)
 *
 *  页面结构:
 *    · 页头 (封面印章)
 *    · 作物批次块
 *    · 传感器当前值网格
 *    · 传感器历史折线 (SensorChart)
 *    · 最近农事 hairline 列表
 *    · 最近操作 hairline 列表
 *    · 底部 CTA: 申请操作 → /pages/task
 * ============================================================ */

const TASK_STATUS_LABEL: Record<TaskStatusValue, { text: string; tone: string }> = {
  pending: { text: '待处理', tone: 'sand' },
  queued: { text: '已排队', tone: 'fog' },
  running: { text: '执行中', tone: 'sage' },
  success: { text: '已完成', tone: 'sage' },
  failed: { text: '已失败', tone: 'clay' },
  cancelled: { text: '已取消', tone: 'ink-faint' },
}

export default function PlotPage() {
  const router = useRouter()
  const plotId = Number(router.params.plotId || 0)

  let plotNameFromQuery = `地块 #${plotId}`
  if (router.params.plotName) {
    try {
      plotNameFromQuery = decodeURIComponent(router.params.plotName)
    } catch {
      plotNameFromQuery = router.params.plotName
    }
  }

  const [detail, setDetail] = useState<PlotDetail | null>(null)
  const [sensors, setSensors] = useState<SensorSummary | null>(null)
  const [records, setRecords] = useState<FarmingRecord[]>([])
  const [logs, setLogs] = useState<OperationTaskListItem[]>([])
  const [analysis, setAnalysis] = useState<AiAnalysis | null>(null)
  const [analyzing, setAnalyzing] = useState(false)
  const [loading, setLoading] = useState(false)
  const [err, setErr] = useState('')

  // M4 · ref 瞬时锁 + refresh 代际守卫
  const analyzingRef = useRef(false)
  const refreshSeqRef = useRef(0)

  // G1 · usePageRefresh 管 useLoad + useDidShow (自动跳首次 show, 避免双拉).
  //      从 task / ai-chat / task-detail navigateBack 回本页时自动刷新,
  //      让最新创建/取消的操作记录 + AI 分析能及时反映在时间线上.
  usePageRefresh(() => {
    // 预条件检查: 无 token 或 plotId 丢失则不拉 (token 失效 http 拦截器会负责跳登录)
    if (!useAuthStore.getState().token) {
      Taro.redirectTo({ url: '/pages/login/index' })
      return
    }
    if (!plotId) {
      setErr('参数缺失: plotId')
      return
    }
    refreshAll()
  })

  usePullDownRefresh(() => {
    refreshAll().finally(() => Taro.stopPullDownRefresh())
  })

  async function refreshAll() {
    const seq = ++refreshSeqRef.current
    setLoading(true)
    setErr('')
    try {
      const [d, s, r, l, a] = await Promise.all([
        getPlotDetail(plotId),
        getSensorSummary(plotId).catch(() => null),
        getFarmingRecords(plotId, 1, 5).catch(() => null),
        getOperationLogs(plotId, 1, 5).catch(() => null),
        getLatestAnalysis(plotId).catch(() => null),
      ])
      // 代际守卫: 期间有更新的 refresh 就丢弃本次结果
      if (seq !== refreshSeqRef.current) return
      setDetail(d)
      setSensors(s)
      setRecords(r?.list || [])
      setLogs(l?.list || [])
      // FIX · handleAnalyzeAgain 在跑时 (触发 LLM 可能 10s+), 这里 getLatestAnalysis
      //   可能返回触发前的旧快照. 若先于触发完成落 state, 会把新结果覆盖成旧的.
      //   analyzingRef.current=true 时不更新 analysis, 让 handleAnalyzeAgain 负责.
      if (!analyzingRef.current) setAnalysis(a)
    } catch (e) {
      if (seq !== refreshSeqRef.current) return
      setErr(e instanceof Error ? e.message : '加载失败')
    } finally {
      if (seq === refreshSeqRef.current) setLoading(false)
    }
  }

  async function handleAnalyzeAgain() {
    if (analyzingRef.current) return
    analyzingRef.current = true
    setAnalyzing(true)
    try {
      const a = await triggerAnalysis(plotId)
      setAnalysis(a)
      Taro.showToast({ title: 'AI 分析完成', icon: 'success', duration: 900 })
    } catch (e) {
      Taro.showToast({
        title: e instanceof Error ? e.message : '分析失败',
        icon: 'none',
      })
    } finally {
      setAnalyzing(false)
      analyzingRef.current = false
    }
  }

  const cropBatch = detail?.currentCropBatch
  const title = detail?.plotName || plotNameFromQuery

  function openAiChat() {
    const name = encodeURIComponent(title)
    Taro.navigateTo({
      url: `/pages/ai-chat/index?plotId=${plotId}&plotName=${name}`,
    })
  }

  function openTaskPage() {
    const name = encodeURIComponent(title)
    Taro.navigateTo({
      url: `/pages/task/index?plotId=${plotId}&plotName=${name}`,
    })
  }

  function openShareCodes() {
    const name = encodeURIComponent(title)
    Taro.navigateTo({
      url: `/pages/share-codes/index?plotId=${plotId}&plotName=${name}`,
    })
  }

  return (
    <View className='plot-page'>
      {/* --- 页头 --- */}
      <View className='plot-head'>
        <Text className='plot-head__seal'>§ 02 · 地块详情</Text>
        <Text className='plot-head__title'>{title}</Text>
        {detail ? (
          <Text className='plot-head__lede'>
            — {fmtArea(detail.areaSize, detail.areaUnit)}
            {detail.farmName ? ` · ${detail.farmName}` : ''}
            {detail.plotNo ? ` · ${detail.plotNo}` : ''}
          </Text>
        ) : null}
      </View>

      {err ? <Text className='plot-page__err'>! {err}</Text> : null}

      {/* --- §00 AI 分析结论 (如果有) --- */}
      <View className='plot-section'>
        <View className='plot-section__title-row'>
          <Text className='plot-section__title'>§ 00 · AI 分析</Text>
          <Text
            className={`plot-section__action ${analyzing ? 'plot-section__action--dim' : ''}`}
            onClick={handleAnalyzeAgain}
          >
            {analyzing ? '分析中 …' : '重新分析 ↻'}
          </Text>
        </View>

        {analysis ? (
          <View className={`ai-card ai-card--${analysis.riskLevel}`}>
            <View className='ai-card__head'>
              <Text className='ai-card__tag'>
                {analysis.analysisType === 'periodic' ? '定时' : '手动'}
              </Text>
              <Text className={`folio-tag folio-tag--${riskTone(analysis.riskLevel)}`}>
                {String(analysis.riskLevel).toUpperCase()}
              </Text>
              <Text className='ai-card__time'>
                {analysis.createdAt ? analysis.createdAt.slice(5, 16) : ''}
              </Text>
            </View>
            <Text className='ai-card__result'>{analysis.analysisResult}</Text>
            {analysis.suggestedActions && analysis.suggestedActions.length > 0 ? (
              <View className='ai-card__actions'>
                {analysis.suggestedActions.map((a, i) => (
                  <Text key={i} className='ai-card__action'>· {a}</Text>
                ))}
              </View>
            ) : null}
          </View>
        ) : (
          <Text className='plot-empty'>
            — 暂无 AI 分析 · 点右上「重新分析」触发 —
          </Text>
        )}
      </View>

      {/* --- §01 作物批次 --- */}
      {cropBatch ? (
        <View className='plot-section'>
          <Text className='plot-section__title'>§ 01 · 作物批次</Text>
          {/* 生长阶段进度条 · 视觉锚点 (播种→出苗→生长→开花→成熟) */}
          <GrowthStageBar stage={cropBatch.growthStage} />
          <MetaRow k='作物' v={cropBatch.cropName || '—'} />
          {cropBatch.varietyName ? (
            <MetaRow k='品种' v={cropBatch.varietyName} />
          ) : null}
          {cropBatch.sowingAt ? (
            <MetaRow k='播种' v={cropBatch.sowingAt.slice(0, 10)} mono />
          ) : null}
          {cropBatch.expectedHarvestAt ? (
            <MetaRow k='预计收获' v={cropBatch.expectedHarvestAt.slice(0, 10)} mono />
          ) : null}
          <MetaRow k='批次号' v={cropBatch.batchNo} mono />
        </View>
      ) : !loading && detail ? (
        <View className='plot-section'>
          <Text className='plot-section__title'>§ 01 · 作物批次</Text>
          <Text className='plot-empty'>— 暂无活跃作物批次 —</Text>
        </View>
      ) : null}

      {/* --- §02 传感器 · 当前值 --- */}
      <View className='plot-section'>
        <Text className='plot-section__title'>§ 02 · 传感数据 · 当前</Text>
        {sensors && sensors.summary && sensors.summary.length > 0 ? (
          <View className='sensor-grid'>
            {sensors.summary.map((s) => {
              // 阈值检测: 已知传感器类型 → 渲染色带 · 未知类型 → 仅数字
              const threshold = resolveThreshold(s.sensorType)
              const num = typeof s.value === 'number' ? s.value : Number(s.value)
              const hasNum = Number.isFinite(num)
              const alert = threshold && hasNum ? !isValueSafe(num, threshold) : false
              const cursorLeft = threshold && hasNum ? thresholdCursorPercent(num, threshold) : 50
              return (
                <View
                  key={s.sensorType}
                  className={`sensor-cell ${alert ? 'sensor-cell--alert' : ''}`}
                >
                  <Text className='sensor-cell__label'>
                    {s.label || sensorLabel(s.sensorType)}
                  </Text>
                  <View className='sensor-cell__value'>
                    <Text className='sensor-cell__num'>
                      {hasNum ? String(s.value) : '—'}
                    </Text>
                    {s.unit ? (
                      <Text className='sensor-cell__unit'>{s.unit}</Text>
                    ) : null}
                  </View>
                  {threshold && hasNum ? (
                    <View className='sensor-cell__threshold'>
                      <View className='sensor-cell__threshold-band'>
                        <View
                          className='sensor-cell__threshold-cursor'
                          style={{ left: `${cursorLeft}%` }}
                        />
                      </View>
                      <View className='sensor-cell__threshold-range'>
                        <Text className='sensor-cell__threshold-tick'>{threshold.displayMin}</Text>
                        <Text className='sensor-cell__threshold-tick'>{threshold.displayMax}</Text>
                      </View>
                    </View>
                  ) : null}
                  <Text className='sensor-cell__time'>
                    {s.sampleAt ? s.sampleAt.slice(5, 16) : '—'}
                  </Text>
                </View>
              )
            })}
          </View>
        ) : (
          <Text className='plot-empty'>— 暂无传感器数据 —</Text>
        )}
      </View>

      {/* --- §03 传感器 · 历史曲线 --- */}
      {plotId ? (
        <View className='plot-section'>
          <Text className='plot-section__title'>§ 03 · 传感数据 · 历史</Text>
          <SensorChart plotId={plotId} sensors={sensors} />
        </View>
      ) : null}

      {/* --- §04 最近农事 --- */}
      <View className='plot-section'>
        <Text className='plot-section__title'>§ 04 · 农事记录</Text>
        {records.length > 0 ? (
          <View className='timeline'>
            {records.map((r) => (
              <View key={r.recordId} className='timeline-row'>
                <View className='timeline-row__head'>
                  <Text className='timeline-row__title'>{r.recordTitle}</Text>
                  <Text className={`folio-tag folio-tag--${recordTone(r.recordType)}`}>
                    {recordTypeLabel(r.recordType)}
                  </Text>
                </View>
                <Text className='timeline-row__meta'>
                  {r.recordTime ? r.recordTime.slice(0, 16) : '—'}
                  {r.operatorName ? ` · ${r.operatorName}` : ''}
                </Text>
                {r.description ? (
                  <Text className='timeline-row__desc'>{r.description}</Text>
                ) : null}
              </View>
            ))}
          </View>
        ) : (
          <Text className='plot-empty'>— 暂无农事记录 —</Text>
        )}
      </View>

      {/* --- §05 最近操作 --- */}
      <View className='plot-section'>
        <Text className='plot-section__title'>§ 05 · 操作记录</Text>
        {logs.length > 0 ? (
          <View className='timeline'>
            {logs.map((t) => {
              const si = TASK_STATUS_LABEL[t.taskStatus] || {
                text: t.taskStatus,
                tone: 'ink-faint',
              }
              return (
                <View
                  key={t.taskId}
                  className='timeline-row'
                  onClick={() =>
                    Taro.navigateTo({
                      url: `/pages/task-detail/index?taskId=${t.taskId}`,
                    })
                  }
                >
                  <View className='timeline-row__head'>
                    <Text className='timeline-row__title'>{t.actionName}</Text>
                    <Text className={`folio-tag folio-tag--${si.tone}`}>
                      {si.text}
                    </Text>
                  </View>
                  <Text className='timeline-row__meta'>
                    {t.createdAt ? t.createdAt.slice(0, 16) : '—'} · T-…{t.taskNo.slice(-6)}
                  </Text>
                </View>
              )
            })}
          </View>
        ) : (
          <Text className='plot-empty'>— 暂无操作记录 —</Text>
        )}
      </View>

      {/* --- 底部 CTA · 问 AI + 申请操作 --- */}
      <View className='plot-ctas'>
        <Button
          className='plot-cta plot-cta--ghost'
          onClick={openAiChat}
        >
          <Text className='plot-cta__text'>问 AI</Text>
          <Text className='plot-cta__arrow'>→</Text>
        </Button>
        <Button className='plot-cta' onClick={openTaskPage}>
          <Text className='plot-cta__text'>申请操作</Text>
          <Text className='plot-cta__arrow'>→</Text>
        </Button>
        <Button className='plot-cta plot-cta--ghost' onClick={openShareCodes}>
          <Text className='plot-cta__text'>分享码</Text>
          <Text className='plot-cta__arrow'>→</Text>
        </Button>
      </View>
    </View>
  )
}

// ---- 小组件: meta 行 ----
function MetaRow({
  k,
  v,
  mono,
  tone,
}: {
  k: string
  v: string
  mono?: boolean
  tone?: 'sage' | 'fog' | 'sand' | 'clay'
}) {
  return (
    <View className='meta-row'>
      <Text className='meta-row__key'>{k}</Text>
      <Text
        className={`meta-row__val ${mono ? 'meta-row__val--mono' : ''} ${
          tone ? `meta-row__val--${tone}` : ''
        }`}
      >
        {v}
      </Text>
    </View>
  )
}

// ---- 传感器中文标签 ----
function sensorLabel(type: string): string {
  const MAP: Record<string, string> = {
    temperature: '气温',
    humidity: '空气湿度',
    light: '光照',
    co2: 'CO₂',
    soil_temperature: '土壤温度',
    soil_moisture: '土壤湿度',
    soil_ph: '土壤 pH',
    ph: '土壤 pH',
    nitrogen: '氮',
    phosphorus: '磷',
    potassium: '钾',
  }
  return MAP[type] || type
}

// ---- 农事类型 → 中文 + tone ----
function recordTypeLabel(type: string): string {
  const MAP: Record<string, string> = {
    sowing: '播种',
    irrigation: '灌溉',
    fertilization: '施肥',
    pruning: '修剪',
    pest_control: '防治',
    harvest: '收获',
    inspection: '巡查',
    note: '备注',
  }
  return MAP[type] || type
}

function recordTone(type: string): string {
  const MAP: Record<string, string> = {
    sowing: 'sage',
    irrigation: 'fog',
    fertilization: 'sand',
    pruning: 'plum',
    pest_control: 'clay',
    harvest: 'moss',
    inspection: 'muted',
    note: 'muted',
  }
  return MAP[type] || 'muted'
}

function fmtArea(size: number | string | null | undefined, unit: string): string {
  // N83 · PlotDetail.areaSize 类型是 number | string, 但契约外 (旧数据/空地块) 可能
  //       回 null/undefined; 不防御会渲染成 "null 亩" / "undefined 亩" 错位
  if (size == null) return `— ${unit}`
  const n = typeof size === 'string' ? Number(size) : size
  if (!Number.isFinite(n)) return `${size} ${unit}`
  const unitLabel: Record<string, string> = { mu: '亩', hectare: '公顷', m2: 'm²' }
  return `${n.toFixed(1)} ${unitLabel[unit] || unit}`
}

function riskTone(r: string): string {
  if (r === 'high') return 'clay'
  if (r === 'medium') return 'sand'
  return 'sage'
}
