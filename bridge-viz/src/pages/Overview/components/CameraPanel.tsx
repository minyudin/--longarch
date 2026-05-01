import { useEffect, useRef, useState, useCallback } from "react";
import flvjs from "flv.js";
import type { CameraInfo } from "@/types/screen";

interface Props {
  camera: CameraInfo | null;
  loading?: boolean;
}

const MAX_RETRY = 3;
const RETRY_DELAY = 5000;

export default function CameraPanel({ camera, loading }: Props) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const playerRef = useRef<flvjs.Player | null>(null);
  const retryCountRef = useRef(0);
  const retryTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const [playError, setPlayError] = useState<string | null>(null);

  const destroyPlayer = useCallback(() => {
    if (retryTimerRef.current) {
      clearTimeout(retryTimerRef.current);
      retryTimerRef.current = null;
    }
    if (playerRef.current) {
      try {
        playerRef.current.pause();
        playerRef.current.unload();
        playerRef.current.detachMediaElement();
        playerRef.current.destroy();
      } catch {
        /* ignore */
      }
      playerRef.current = null;
    }
  }, []);

  const initPlayer = useCallback(() => {
    if (!camera || camera.status !== "online" || !camera.flvUrl) return;
    if (!videoRef.current) return;
    if (!flvjs.isSupported()) {
      setPlayError("当前浏览器不支持 FLV 播放");
      return;
    }

    destroyPlayer();
    setPlayError(null);

    const player = flvjs.createPlayer(
      { type: "flv", url: camera.flvUrl, isLive: true },
      {
        enableWorker: false,
        enableStashBuffer: false,
        stashInitialSize: 128,
        lazyLoadMaxDuration: 3 * 60,
        autoCleanupSourceBuffer: true,
      }
    );

    player.attachMediaElement(videoRef.current);
    player.load();
    const playPromise = player.play();
    if (playPromise && typeof playPromise.catch === "function") {
      playPromise.catch(() => { /* autoplay blocked */ });
    }

    player.on(flvjs.Events.ERROR, (_type: string, _detail: string, info: { msg?: string }) => {
      const msg = info?.msg || "视频流连接失败";
      if (retryCountRef.current < MAX_RETRY) {
        retryCountRef.current += 1;
        retryTimerRef.current = setTimeout(() => initPlayer(), RETRY_DELAY);
        setPlayError(`${msg}，第 ${retryCountRef.current} 次重连中...`);
      } else {
        setPlayError(`${msg}，已达最大重试次数`);
      }
    });

    playerRef.current = player;
  }, [camera, destroyPlayer]);

  useEffect(() => {
    retryCountRef.current = 0;
    initPlayer();
    return destroyPlayer;
  }, [initPlayer, destroyPlayer]);

  // ── HUD 公共叠加层 ──
  const hudOverlay = (
    <>
      {/* 四角准星 */}
      <span className="cam__corner cam__corner--tl" />
      <span className="cam__corner cam__corner--tr" />
      <span className="cam__corner cam__corner--bl" />
      <span className="cam__corner cam__corner--br" />
      {/* 扫描线 */}
      <div className="cam__scanlines" />
      {/* 中央十字准线 */}
      <div className="cam__crosshair">
        <span className="cam__crosshair-h" />
        <span className="cam__crosshair-v" />
        <span className="cam__crosshair-ring" />
      </div>
    </>
  );

  // ── 顶部 HUD 条 ──
  const hudTop = (name: string, isLive: boolean) => (
    <div className="cam__hud-top">
      <div className="cam__hud-left">
        <span className={`cam__dot ${isLive ? "cam__dot--live" : "cam__dot--off"}`} />
        <span className="cam__tag">{isLive ? "REC" : "OFF"}</span>
        <span className="cam__name">{name}</span>
      </div>
      <div className="cam__hud-right">
        <span className="cam__meta">1080P</span>
        <span className="cam__meta">H.265</span>
        <span className="cam__meta">30FPS</span>
      </div>
    </div>
  );

  // ── 底部数据条 ──
  const hudBottom = (
    <div className="cam__hud-bottom">
      <div className="cam__signal">
        <span className="cam__signal-bar" />
        <span className="cam__signal-bar" />
        <span className="cam__signal-bar" />
        <span className="cam__signal-bar" />
      </div>
      <span className="cam__ts">{new Date().toLocaleTimeString("zh-CN", { hour12: false })}</span>
    </div>
  );

  // ── 加载态 ──
  if (loading) {
    return (
      <div className="cam cam--skeleton">
        <div className="cam__static-noise" />
        {hudOverlay}
        <div className="cam__center-msg">
          <span className="cam__loader-ring" />
          <span className="cam__center-text">CONNECTING...</span>
        </div>
      </div>
    );
  }

  // ── 无摄像头 ──
  if (!camera) {
    return (
      <div className="cam cam--empty">
        <div className="cam__static-noise" />
        {hudOverlay}
        {hudTop("NO SIGNAL", false)}
        <div className="cam__center-msg">
          <span className="cam__center-icon">⊘</span>
          <span className="cam__center-text">NO CAMERA BOUND</span>
          <span className="cam__center-sub">设备未绑定</span>
        </div>
        {hudBottom}
      </div>
    );
  }

  // ── 摄像头离线 ──
  if (camera.status !== "online") {
    return (
      <div className="cam cam--offline">
        <div className="cam__static-noise" />
        {hudOverlay}
        {hudTop(camera.cameraName, false)}
        <div className="cam__center-msg">
          <span className="cam__center-icon cam__center-icon--danger">◉</span>
          <span className="cam__center-text">SIGNAL LOST</span>
          <span className="cam__center-sub">设备离线 · 等待重连</span>
        </div>
        {hudBottom}
      </div>
    );
  }

  // ── 正常 / 播放失败 ──
  return (
    <div className="cam">
      <video
        ref={videoRef}
        className="cam__video"
        muted
        autoPlay
        playsInline
      />
      {hudOverlay}
      {hudTop(camera.cameraName, !playError)}
      {playError && (
        <div className="cam__center-msg cam__center-msg--error">
          <span className="cam__loader-ring" />
          <span className="cam__center-text">{playError}</span>
        </div>
      )}
      {hudBottom}
    </div>
  );
}
