import { useEffect, useRef, useCallback, type ReactNode } from "react";

const DESIGN_WIDTH = 1920;
const DESIGN_HEIGHT = 1080;

interface Props {
  children: ReactNode;
}

/**
 * AutoFit — 大屏自适应容器
 *
 * 以 1920×1080 为设计稿尺寸，通过 CSS transform: scale 等比缩放，
 * 始终保持画面居中且不变形。适用于电视大屏全屏展示场景。
 */
export default function AutoFit({ children }: Props) {
  const wrapRef = useRef<HTMLDivElement>(null);

  const resize = useCallback(() => {
    const el = wrapRef.current;
    if (!el) return;

    const w = window.innerWidth;
    const h = window.innerHeight;
    const scaleX = w / DESIGN_WIDTH;
    const scaleY = h / DESIGN_HEIGHT;
    const scale = Math.min(scaleX, scaleY);

    el.style.transform = `scale(${scale})`;
    el.style.transformOrigin = "left top";
    el.style.width = `${DESIGN_WIDTH}px`;
    el.style.height = `${DESIGN_HEIGHT}px`;

    // 居中偏移
    const offsetX = (w - DESIGN_WIDTH * scale) / 2;
    const offsetY = (h - DESIGN_HEIGHT * scale) / 2;
    el.style.marginLeft = `${offsetX}px`;
    el.style.marginTop = `${offsetY}px`;
  }, []);

  useEffect(() => {
    resize();
    window.addEventListener("resize", resize);
    return () => window.removeEventListener("resize", resize);
  }, [resize]);

  return (
    <div ref={wrapRef} className="autofit-root">
      {children}
    </div>
  );
}
