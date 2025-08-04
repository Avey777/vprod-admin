<template>
  <div class="home">
    <!-- 英雄区域 -->
    <section class="hero">
      <div class="container">
        <div class="hero-content">
          <h1 class="hero-title">
            打造惊艳的<span class="highlight">用户体验</span>
          </h1>
          <p class="hero-subtitle">
            AndaerUI
            提供现代化的界面组件库，帮助您快速构建美观、高性能的应用程序
          </p>
          <div class="hero-cta">
            <NuxtLink to="/get-started" class="cta-btn primary"
              >开始使用</NuxtLink
            >
            <NuxtLink to="/demo" class="cta-btn secondary">查看演示</NuxtLink>
          </div>
        </div>
        <div class="hero-image">
          <div class="gradient-circle"></div>
          <div class="mockup">
            <div class="mockup-header"></div>
            <div class="mockup-content">
              <div class="mockup-item"></div>
              <div class="mockup-item"></div>
              <div class="mockup-item"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 特性展示 -->
    <section class="features">
      <div class="container">
        <h2 class="section-title">强大的功能特性</h2>
        <p class="section-subtitle">
          探索我们精心设计的组件库，提升您的开发体验
        </p>

        <div class="features-grid">
          <div class="feature-card">
            <div class="feature-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="10" />
                <line x1="12" y1="8" x2="12" y2="12" />
                <line x1="12" y1="16" x2="12.01" y2="16" />
              </svg>
            </div>
            <h3>响应式设计</h3>
            <p>
              所有组件完美适配各种屏幕尺寸，从手机到桌面设备都能提供一致的用户体验
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 2.69l5 4.5V18h-2v-6H9v6H7V7.19l5-4.5z" />
              </svg>
            </div>
            <h3>主题定制</h3>
            <p>轻松定制主题颜色、字体和样式，满足您的品牌需求</p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <polyline points="23 4 23 10 17 10" />
                <polyline points="1 20 1 14 7 14" />
                <path
                  d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"
                />
              </svg>
            </div>
            <h3>无缝集成</h3>
            <p>与Vue、Nuxt、React等主流框架无缝集成，开箱即用</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home {
  padding-top: 80px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.hero {
  padding: 6rem 0;
  position: relative;
  overflow: hidden;
}

.hero::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
  z-index: -1;
  clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
}

.hero-content {
  max-width: 600px;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  line-height: 1.2;
  margin-bottom: 1.5rem;
  color: #0f172a;
}

.highlight {
  background: linear-gradient(to right, #6366f1, #8b5cf6);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: #475569;
  margin-bottom: 2rem;
  line-height: 1.6;
}

.hero-cta {
  display: flex;
  gap: 1rem;
}

.cta-btn {
  padding: 1rem 2rem;
  border-radius: 8px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
}

.cta-btn.primary {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
  box-shadow: 0 4px 6px rgba(99, 102, 241, 0.3);
}

.cta-btn.primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(99, 102, 241, 0.4);
}

.cta-btn.secondary {
  background: transparent;
  color: #6366f1;
  border: 2px solid #6366f1;
}

.cta-btn.secondary:hover {
  background: rgba(99, 102, 241, 0.05);
  transform: translateY(-3px);
}

.hero-image {
  position: absolute;
  top: 50%;
  right: 0;
  transform: translateY(-50%);
  width: 50%;
  max-width: 600px;
}

.gradient-circle {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: radial-gradient(
    circle,
    rgba(99, 102, 241, 0.2) 0%,
    rgba(99, 102, 241, 0) 70%
  );
  z-index: -1;
}

.mockup {
  width: 320px;
  height: 400px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  margin-left: auto;
  margin-right: 10%;
}

.mockup-header {
  height: 50px;
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
}

.mockup-content {
  padding: 1.5rem;
}

.mockup-item {
  height: 60px;
  background: #f8fafc;
  border-radius: 8px;
  margin-bottom: 1rem;
}

.mockup-item:last-child {
  margin-bottom: 0;
}

.features {
  padding: 6rem 0;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 1rem;
}

.section-subtitle {
  text-align: center;
  color: #64748b;
  max-width: 600px;
  margin: 0 auto 3rem;
  font-size: 1.1rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  width: 70px;
  height: 70px;
  border-radius: 18px;
  background: rgba(99, 102, 241, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.feature-icon svg {
  width: 32px;
  height: 32px;
  stroke: #6366f1;
  stroke-width: 1.5;
}

.feature-card h3 {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #0f172a;
}

.feature-card p {
  color: #64748b;
  line-height: 1.6;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .hero {
    padding: 4rem 0;
  }

  .hero-title {
    font-size: 2.5rem;
  }

  .hero-image {
    position: relative;
    width: 100%;
    max-width: none;
    transform: none;
    margin-top: 3rem;
  }

  .mockup {
    margin: 0 auto;
  }
}

@media (max-width: 576px) {
  .hero-title {
    font-size: 2rem;
  }

  .hero-cta {
    flex-direction: column;
  }
}
</style>
