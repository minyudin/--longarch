import type { FC } from "react";
import type { GreenhouseItem } from "@/types/screen";

interface Props {
  greenhouses: GreenhouseItem[];
  activeId: number | null;
  onSwitch: (id: number) => void;
}

const GreenhouseSwitcher: FC<Props> = ({ greenhouses, activeId, onSwitch }) => {
  if (greenhouses.length <= 1) return null;

  return (
    <div className="gh-switcher">
      {greenhouses.map((gh) => {
        const isActive = gh.id === activeId;
        return (
          <button
            key={gh.id}
            className={`gh-switcher__btn${isActive ? " gh-switcher__btn--active" : ""}`}
            onClick={() => onSwitch(gh.id)}
          >
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
              <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
              <polyline points="9 22 9 12 15 12 15 22" />
            </svg>
            <span className="gh-switcher__name">{gh.name}</span>
            <span className="gh-switcher__count">{gh.plotCount}</span>
          </button>
        );
      })}
    </div>
  );
};

export default GreenhouseSwitcher;
