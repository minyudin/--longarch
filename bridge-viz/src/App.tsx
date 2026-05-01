import { Routes, Route } from "react-router-dom";
import { lazy, Suspense, useState } from "react";
import LoaderScreen from "@/components/LoaderScreen";
import AutoFit from "@/components/AutoFit";

const Overview = lazy(() => import("@/pages/Overview"));
const PlotDetail = lazy(() => import("@/pages/PlotDetail"));

export default function App() {
  const [revealing, setRevealing] = useState(false);
  const [loaderDone, setLoaderDone] = useState(false);

  return (
    <>
      {/* 主内容始终挂载，Loader 期间就已预加载 + 请求数据 */}
      <AutoFit>
        <Suspense fallback={null}>
          <div className={`page-reveal${revealing ? " page-reveal--visible" : ""}`}>
            <Routes>
              <Route path="/" element={<Overview />} />
              <Route path="/plot/:plotId" element={<PlotDetail />} />
            </Routes>
          </div>
        </Suspense>
      </AutoFit>

      {/* Loader 覆盖层：淡出与 Overview 淡入同步（交叉溶解），800ms 后卸载 */}
      {!loaderDone && (
        <LoaderScreen
          onFinish={() => {
            setRevealing(true);
            setTimeout(() => setLoaderDone(true), 800);
          }}
        />
      )}
    </>
  );
}