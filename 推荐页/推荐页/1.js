(() => {
  const progress = document.getElementById("scrollProgress");
  const dot = document.getElementById("cursorDot");
  const ring = document.getElementById("cursorRing");
  const cards = Array.from(document.querySelectorAll(".card"));

  const supportsFinePointer = window.matchMedia("(pointer: fine)").matches;

  function updateProgress() {
    const doc = document.documentElement;
    const max = doc.scrollHeight - window.innerHeight;
    const ratio = max > 0 ? (window.scrollY / max) * 100 : 0;
    if (progress) progress.style.width = `${Math.max(0, Math.min(100, ratio))}%`;
  }

  function revealOnScroll() {
    const vh = window.innerHeight;
    cards.forEach((card) => {
      const rect = card.getBoundingClientRect();
      if (rect.top < vh * 0.92) {
        card.style.opacity = "1";
        card.style.transform = "translateY(0)";
      }
    });
  }

  function setupTilt(card) {
    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width;
      const y = (e.clientY - rect.top) / rect.height;
      const rx = (0.5 - y) * 3.5;
      const ry = (x - 0.5) * 5;
      card.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg)`;
    });
    card.addEventListener("mouseleave", () => {
      card.style.transform = "";
    });
  }

  function setupCursor() {
    if (!supportsFinePointer || !dot || !ring) return;

    let ringX = 0;
    let ringY = 0;
    let targetX = 0;
    let targetY = 0;

    const show = () => {
      dot.style.opacity = "1";
      ring.style.opacity = "1";
    };
    const hide = () => {
      dot.style.opacity = "0";
      ring.style.opacity = "0";
    };

    window.addEventListener("mouseenter", show);
    window.addEventListener("mouseleave", hide);

    window.addEventListener("mousemove", (e) => {
      targetX = e.clientX;
      targetY = e.clientY;
      dot.style.left = `${targetX}px`;
      dot.style.top = `${targetY}px`;
      show();
    });

    const animateRing = () => {
      ringX += (targetX - ringX) * 0.15;
      ringY += (targetY - ringY) * 0.15;
      ring.style.left = `${ringX}px`;
      ring.style.top = `${ringY}px`;
      requestAnimationFrame(animateRing);
    };
    animateRing();

    const interactive = document.querySelectorAll("a, button, .card, .preview");
    interactive.forEach((el) => {
      el.addEventListener("mouseenter", () => {
        ring.style.transform = "translate(-50%, -50%) scale(1.35)";
        ring.style.borderColor = "rgba(196, 80, 42, 0.85)";
      });
      el.addEventListener("mouseleave", () => {
        ring.style.transform = "translate(-50%, -50%) scale(1)";
        ring.style.borderColor = "rgba(196, 80, 42, 0.55)";
      });
    });
  }

  window.addEventListener("scroll", () => {
    updateProgress();
    revealOnScroll();
  });
  window.addEventListener("resize", updateProgress);

  cards.forEach(setupTilt);
  setupCursor();
  updateProgress();
  revealOnScroll();
})();
