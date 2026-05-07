import { FormEvent, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { useAuthStore } from '@/stores/auth'
import { adminLogin, fetchPlatformConfig } from '@/api'
import { qk } from '@/lib/queryKeys'
import { STALE } from '@/lib/queryClient'
import { toast } from '@/lib/toast'
import { useGsapButton } from '@/lib/useGsapButton'
import './LoginPage.scss'

/**
 * LoginPage · §0 Entry (Admin)
 * ============================================================
 *  生产级管理员登录
 *  · mobile + password · BCrypt · 失败 5 次锁 15 分钟
 *  · 仅 roleType=admin 可通过 (前后端双重校验)
 *  · 纸本编辑美学 · 无圆角无阴影 · hairline 边框
 * ============================================================ */

const MOBILE_RE = /^1[3-9]\d{9}$/

export default function LoginPage() {
  const [mobile, setMobile] = useState('')
  const [password, setPassword] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [errMsg, setErrMsg] = useState<string | null>(null)
  const submitRef = useRef<HTMLButtonElement | null>(null)

  const setUserInfo = useAuthStore((s) => s.setUserInfo)
  const clearStore = useAuthStore((s) => s.logout)
  const navigate = useNavigate()

  // 平台配置 · 一次性元数据
  const { data: cfg } = useQuery({
    queryKey: qk.platformConfig(),
    queryFn: fetchPlatformConfig,
    staleTime: STALE.STATIC,
    retry: false,
  })
  const platformName = cfg?.platformName ?? ''
  useGsapButton(submitRef, { disabled: submitting })

  function validate(): string | null {
    if (!mobile) return '请填写手机号'
    if (!MOBILE_RE.test(mobile)) return '手机号格式不正确'
    if (!password) return '请填写密码'
    if (password.length < 6) return '密码长度至少 6 位'
    return null
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    if (submitting) return
    const err = validate()
    if (err) {
      setErrMsg(err)
      return
    }
    setErrMsg(null)
    setSubmitting(true)
    try {
      const data = await adminLogin({ mobile, password })
      // 后端已限制 roleType=admin, 此处再做前端防御
      if (data.userInfo?.roleType !== 'admin') {
        clearStore()
        setErrMsg('此账号无管理后台权限')
        toast.error('此账号无管理后台权限')
        return
      }
      // token 已落到 HttpOnly cookie, 仅需写 userInfo 到 store
      setUserInfo(data.userInfo)
      toast.success(`已登录 · ${data.userInfo?.nickname || mobile}`)
      navigate('/dashboard')
    } catch (e) {
      // 拦截器已 toast, 这里再把错误文字挂到表单下方提示
      const msg = e instanceof Error ? e.message : '登录失败'
      setErrMsg(msg)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <main className="login-page">
      <form className="login-card" onSubmit={handleSubmit} noValidate>
        <header className="login-card__head">
          <span className="login-card__seal">ADMIN · Sign in</span>
          <h1 className="login-card__title">
            Longarch
            <span className="login-card__title-cn">陇上</span>
          </h1>
          <p className="login-card__lede">
            {platformName || '陇上认养 · 智慧农业运营后台'}
          </p>
        </header>

        <section className="login-card__body">
          <h4 className="login-card__section-title">
            账号登录 <em>· mobile &amp; password</em>
          </h4>

          <div className="form-field">
            <label className="form-field__label" htmlFor="login-mobile">
              MOBILE <em>· 手机号</em>
            </label>
            <input
              id="login-mobile"
              type="tel"
              autoComplete="username"
              inputMode="numeric"
              maxLength={11}
              className="form-field__input"
              value={mobile}
              onChange={(e) => {
                setMobile(e.target.value.replace(/\D/g, ''))
                if (errMsg) setErrMsg(null)
              }}
              placeholder="1XX XXXX XXXX"
              data-testid="login-mobile"
              disabled={submitting}
            />
          </div>

          <div className="form-field">
            <label className="form-field__label" htmlFor="login-password">
              PASSWORD <em>· 密码</em>
            </label>
            <input
              id="login-password"
              type="password"
              autoComplete="current-password"
              className="form-field__input"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value)
                if (errMsg) setErrMsg(null)
              }}
              placeholder="··········"
              data-testid="login-password"
              disabled={submitting}
            />
          </div>

          {errMsg && (
            <p className="form-field__err" data-testid="login-err">
              <em>!</em> {errMsg}
            </p>
          )}

          <button
            ref={submitRef}
            type="submit"
            className="login-submit"
            disabled={submitting}
            data-testid="login-submit"
          >
            <span className="login-submit__label">
              {submitting ? 'SIGNING IN…' : 'SIGN IN'}
            </span>
            <span className="login-submit__arrow">{submitting ? '…' : '→'}</span>
          </button>
        </section>

        <footer className="login-card__foot">
          <small>Admin access only · 请使用管理员账号登录</small>
        </footer>
      </form>
    </main>
  )
}
