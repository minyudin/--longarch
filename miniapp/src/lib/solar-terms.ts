/**
 * 二十四节气 · Solar Terms
 * ============================================================
 *  给定日期返回当前节气 + 配套农谚.
 *  精度: ±1 天 (不对接紫金山天文台真精确日期, 足以做 UI 时节呼应).
 *
 *  设计意图 · "《农政全书》书页 volume mark":
 *    登录页/认养页 lede 下方放一行 "〈 谷雨 〉· 雨生百谷",
 *    让 app 在不同月份打开长得不一样, 而不是静态"档案馆".
 * ============================================================ */

export interface SolarTerm {
  /** 节气名, 如 "谷雨" */
  name: string
  /** 配套农谚, 短句, 不超过 12 字 */
  saying: string
  /** 节气开始的 (月份 · 月内日期) · 公历, 每年 ±1 天波动 (忽略) */
  month: number
  day: number
}

// 按公历从 1/1 往后排序 · 方便"找今天所在的节气"反向遍历
const TERMS: SolarTerm[] = [
  { month: 1,  day: 6,  name: '小寒', saying: '雁北乡' },
  { month: 1,  day: 20, name: '大寒', saying: '极寒将尽' },
  { month: 2,  day: 4,  name: '立春', saying: '一年之计在于春' },
  { month: 2,  day: 19, name: '雨水', saying: '春雨贵如油' },
  { month: 3,  day: 6,  name: '惊蛰', saying: '春雷响，万物长' },
  { month: 3,  day: 21, name: '春分', saying: '昼夜平分，寒暑各半' },
  { month: 4,  day: 5,  name: '清明', saying: '清明前后，种瓜点豆' },
  { month: 4,  day: 20, name: '谷雨', saying: '雨生百谷' },
  { month: 5,  day: 6,  name: '立夏', saying: '夏始于此' },
  { month: 5,  day: 21, name: '小满', saying: '麦粒将熟' },
  { month: 6,  day: 6,  name: '芒种', saying: '有芒之谷可稼种' },
  { month: 6,  day: 21, name: '夏至', saying: '夏之极也' },
  { month: 7,  day: 7,  name: '小暑', saying: '温风至' },
  { month: 7,  day: 23, name: '大暑', saying: '腐草为萤' },
  { month: 8,  day: 8,  name: '立秋', saying: '凉风至' },
  { month: 8,  day: 23, name: '处暑', saying: '暑气止' },
  { month: 9,  day: 8,  name: '白露', saying: '蒹葭苍苍' },
  { month: 9,  day: 23, name: '秋分', saying: '平分秋色' },
  { month: 10, day: 8,  name: '寒露', saying: '露凝而寒' },
  { month: 10, day: 24, name: '霜降', saying: '霜始降' },
  { month: 11, day: 8,  name: '立冬', saying: '冬藏之始' },
  { month: 11, day: 22, name: '小雪', saying: '初雪渐至' },
  { month: 12, day: 7,  name: '大雪', saying: '雪盛' },
  { month: 12, day: 22, name: '冬至', saying: '一阳生' },
]

/**
 * 取 "now 所在的当前节气".
 *
 *  规则: 从列表尾 (12月冬至) 往前找, 第一个开始日 ≤ 今天的节气.
 *  月初早于 1/6 小寒 → 回退到上一年的大寒 (跨年兼容).
 */
export function getCurrentSolarTerm(now: Date = new Date()): SolarTerm {
  const m = now.getMonth() + 1
  const d = now.getDate()

  for (let i = TERMS.length - 1; i >= 0; i--) {
    const t = TERMS[i]
    if (t.month < m || (t.month === m && t.day <= d)) {
      return t
    }
  }
  // 今天在 1/1 ~ 1/5 之间 → 仍处于去年大寒节气内
  return TERMS[TERMS.length - 1]
}

/**
 * 取 "now 之后即将到来的下一个节气" (用于 "距离下一个节气 X 天" 类提示, 可选).
 */
export function getNextSolarTerm(now: Date = new Date()): SolarTerm {
  const current = getCurrentSolarTerm(now)
  const idx = TERMS.findIndex((t) => t.name === current.name)
  return TERMS[(idx + 1) % TERMS.length]
}
