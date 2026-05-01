import { useEffect, useRef, useState, useCallback, useMemo } from "react";

/**
 * LoaderScreen — 完整沿用 Elite Cybersecurity Portfolio 入场动画
 *
 * 背景层（从后到前）：
 *   1. 多层径向渐变光晕（CSS ::before）
 *   2. Matrix 数字雨画布（canvas, initMatrix 完整移植）
 *   3. 网格叠加层（grid-overlay, CSS animation: gridMove）
 *   4. 扫描线（scan-line, CSS animation: scanDown）
 *   5. 漂浮代码粒子（initParticles 完整移植）
 *   6. 垂直扫描线（hack-lines）
 *
 * 终端动画：
 *   - 所有行一开始就在 DOM，CSS fadeInTerminal + nth-child delay 逐行丝滑淡入
 *   - 进度条每 80ms 随机递增（与原版 initLoader 一致）
 *   - 100% 后延迟 500ms → 整体淡出 600ms → onFinish
 */

const TERMINAL_LINES = [
  { prompt: "root@longarch:~$", command: "./init_dashboard.sh" },
  { prompt: "", command: "", output: "[INFO] Scanning sensor network...", success: false },
  { prompt: "", command: "", output: "[INFO] MQTT broker connection: ", successText: "ACTIVE", success: true },
  { prompt: "", command: "", output: "[INFO] Camera stream protocols: ", successText: "ENABLED", success: true },
  { prompt: "", command: "", output: "[INFO] Data pipeline status: ", successText: "ONLINE", success: true },
  { prompt: "", command: "", output: "[SUCCESS] System secured. Dashboard ready.", success: true, allSuccess: true },
  { prompt: "root@longarch:~$", command: "" },
];

const PARTICLE_CHARS = ["0", "1", "{", "}", "[", "]", "<", ">", "/", "*"];
const MATRIX_CHARS = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン";

interface Props {
  onFinish: () => void;
}

export default function LoaderScreen({ onFinish }: Props) {
  const [progress, setProgress] = useState(0);
  const [fading, setFading] = useState(false);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const matrixRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const finished = useRef(false);

  const finish = useCallback(() => {
    if (finished.current) return;
    finished.current = true;
    setFading(true);
    onFinish(); // 立即通知父级开始揭示主内容，实现交叉溶解
  }, [onFinish]);

  // ── Matrix 数字雨（完整移植 initMatrix）──────────────────
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const fontSize = 14;
    const columns = Math.floor(canvas.width / fontSize);
    const drops: number[] = Array.from({ length: columns }, () => 1);

    function draw() {
      ctx!.fillStyle = "rgba(10, 14, 26, 0.05)";
      ctx!.fillRect(0, 0, canvas!.width, canvas!.height);
      ctx!.fillStyle = "#00ff88";
      ctx!.font = `${fontSize}px monospace`;

      for (let i = 0; i < drops.length; i++) {
        const char = MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)];
        ctx!.fillText(char, i * fontSize, drops[i] * fontSize);
        if (drops[i] * fontSize > canvas!.height && Math.random() > 0.975) {
          drops[i] = 0;
        }
        drops[i]++;
      }
    }

    matrixRef.current = setInterval(draw, 35);

    const onResize = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };
    window.addEventListener("resize", onResize);

    return () => {
      if (matrixRef.current) clearInterval(matrixRef.current);
      window.removeEventListener("resize", onResize);
    };
  }, []);

  // ── 进度条随机递增（每 80ms，与原版 initLoader 完全一致）──
  useEffect(() => {
    intervalRef.current = setInterval(() => {
      setProgress((prev) => {
        const next = prev + Math.random() * 15 + 5;
        if (next >= 100) {
          clearInterval(intervalRef.current!);
          setTimeout(finish, 500);
          return 100;
        }
        return next;
      });
    }, 80);
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [finish]);

  // ── 预生成粒子参数（完整移植 initParticles）─────────────
  const particles = useMemo(
    () =>
      Array.from({ length: 30 }, () => ({
        char: PARTICLE_CHARS[Math.floor(Math.random() * PARTICLE_CHARS.length)],
        left: `${Math.random() * 100}%`,
        delay: `${Math.random() * 8}s`,
        duration: `${6 + Math.random() * 4}s`,
      })),
    [],
  );

  return (
    <div className={`loader-screen${fading ? " hidden" : ""}`}>
      {/* ── 背景层 ────────────────────────────────── */}
      {/* 1. Matrix 数字雨画布 */}
      <canvas ref={canvasRef} className="matrix-canvas" />
      {/* 2. 网格叠加 */}
      <div className="grid-overlay" />
      {/* 3. 扫描线 */}
      <div className="scan-line" />
      {/* 4. 漂浮代码粒子 */}
      <div className="hack-particles">
        {particles.map((p, i) => (
          <div
            key={i}
            className="particle"
            style={{
              left: p.left,
              animationDelay: p.delay,
              animationDuration: p.duration,
            }}
          >
            {p.char}
          </div>
        ))}
      </div>
      {/* 5. 垂直扫描线 */}
      <div className="hack-lines">
        <div className="hack-line" />
        <div className="hack-line" />
        <div className="hack-line" />
      </div>

      {/* ── 前景：终端 + 进度条 ─────────────────── */}
      <div className="loader-container">
        <div className="hack-terminal">
          <div className="terminal-header">
            <div className="terminal-dots">
              <span className="dot red" />
              <span className="dot yellow" />
              <span className="dot green" />
            </div>
            <span className="terminal-title">LONGARCH DASHBOARD // SYSTEM INIT</span>
          </div>
          <div className="terminal-body">
            {TERMINAL_LINES.map((line, i) => (
              <div className="terminal-line" key={i}>
                {line.prompt && <span className="prompt">{line.prompt}</span>}
                {line.command && <span className="command">{line.command}</span>}
                {line.output && (
                  <span className={`output${line.allSuccess ? " success" : ""}`}>
                    {line.output}
                    {line.successText && <span className="success">{line.successText}</span>}
                  </span>
                )}
                {i === TERMINAL_LINES.length - 1 && <span className="cursor">_</span>}
              </div>
            ))}
          </div>
        </div>

        <div className="loader-progress-container">
          <div
            className="loader-progress-bar"
            style={{ width: `${progress}%` }}
          />
        </div>
        <div className="loader-percentage">{Math.floor(progress)}%</div>
      </div>
    </div>
  );
}
