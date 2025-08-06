<template>
  <div class="container">
    <!-- 全屏Banner -->
    <div class="banner">
      <div class="banner-image">
        <div class="banner-content">
          <h1 class="banner-title">智能航拍新体验</h1>
          <p class="banner-subtitle">
            智能航拍无人机，带来专业级影像体验。全方位避障系统，超长续航，让创作无拘无束。
          </p>
        </div>
      </div>
    </div>

    <!-- 四宫格布局 -->
    <div class="grid-section">
      <div class="grid-container">
        <!-- 航拍无人机 -->
        <div class="grid-item">
          <div
            class="drone-img"
            style="
              background-image: url(&quot;/images/grid1.webp&quot;);
              background-size: cover;
              background-position: center;
              position: absolute; /* 相对 grid-item 定位 */
              top: 0;
              left: 0;
              width: 100%; /* 继承父容器宽度 */
              height: 100%; /* 继承父容器高度 */
              animation: float 6s infinite ease-in-out;
            "
          />
          <div class="grid-overlay">
            <h3 class="grid-title">航拍无人机</h3>
            <p class="grid-desc">专业级航拍解决方案，捕捉壮丽航拍画面</p>
          </div>
        </div>

        <!-- 手持云台 -->
        <div class="grid-item">
          <div
            class="drone-img"
            style="
              background-image: url(&quot;/images/grid2.webp&quot;);
              background-size: cover;
              background-position: center;
              position: absolute; /* 相对 grid-item 定位 */
              top: 0;
              left: 0;
              width: 100%; /* 继承父容器宽度 */
              height: 100%; /* 继承父容器高度 */
              animation: float 6s infinite ease-in-out;
            "
          ></div>
          <div class="grid-overlay">
            <h3 class="grid-title">手持云台</h3>
            <p class="grid-desc">稳定拍摄每一刻，创作更流畅影像</p>
          </div>
        </div>

        <!-- 教育机器人 -->
        <div class="grid-item">
          <div
            class="drone-img"
            style="
              background-image: url(&quot;/images/grid3.jpg&quot;);
              background-size: cover;
              background-position: center;
              position: absolute; /* 相对 grid-item 定位 */
              top: 0;
              left: 0;
              width: 100%; /* 继承父容器宽度 */
              height: 100%; /* 继承父容器高度 */
              animation: float 6s infinite ease-in-out;
            "
          ></div>
          <div class="grid-overlay">
            <h3 class="grid-title">少年科技</h3>
            <p class="grid-desc">创新教育解决方案，培养未来科技人才</p>
          </div>
        </div>

        <!-- 农业科技 -->
        <div class="grid-item">
          <div
            class="drone-img"
            style="
              background-image: url(&quot;/images/grid4.jpg&quot;);
              background-size: cover;
              background-position: center;
              position: absolute; /* 相对 grid-item 定位 */
              top: 0;
              left: 0;
              width: 100%; /* 继承父容器宽度 */
              height: 100%; /* 继承父容器高度 */
              animation: float 6s infinite ease-in-out;
            "
          ></div>
          <div class="grid-overlay">
            <h3 class="grid-title">畅玩科技</h3>
            <p class="grid-desc">智能导航，随心所欲</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 五产品横向布局 -->
    <div class="products-section">
      <h2 class="section-title">热销产品</h2>
      <div class="products-container">
        <!-- 产品1 -->
        <div class="product-card">
          <div class="product-image">
            <div
              class="product-bg"
              style="
                background-image: url(&quot;/images/p1.webp&quot;);
                background-size: cover;
                background-position: center;
                width: 100%;
                height: 100%;
              "
            ></div>
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Mavic 3 Pro</h3>
            <ul class="product-features">
              <li>哈苏三摄系统</li>
              <li>43分钟续航</li>
              <li>15公里图传</li>
              <li>全向避障</li>
              <li>5.1K 视频拍摄</li>
            </ul>
            <div class="product-price">¥12,999起</div>
          </div>
        </div>

        <!-- 产品2 -->
        <div class="product-card">
          <div class="product-image">
            <div
              class="product-bg"
              style="
                background-image: url(&quot;/images/p2.png&quot;);
                background-size: cover;
                background-position: center;
                width: 100%;
                height: 100%;
              "
            ></div>
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Mini 3 Pro</h3>
            <ul class="product-features">
              <li>轻于249克</li>
              <li>4K HDR视频</li>
              <li>三向避障</li>
              <li>34分钟续航</li>
              <li>大师镜头功能</li>
            </ul>
            <div class="product-price">¥4,788起</div>
          </div>
        </div>

        <!-- 产品3 -->
        <div class="product-card">
          <div class="product-image">
            <div
              class="product-bg"
              style="
                background-image: url(&quot;/images/p3.png&quot;);
                background-size: cover;
                background-position: center;
                width: 100%;
                height: 100%;
              "
            ></div>
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Air 2S</h3>
            <ul class="product-features">
              <li>1英寸传感器</li>
              <li>5.4K视频拍摄</li>
              <li>大师镜头功能</li>
              <li>四向避障</li>
              <li>31分钟续航</li>
            </ul>
            <div class="product-price">¥6,499起</div>
          </div>
        </div>

        <!-- 产品4 -->
        <div class="product-card">
          <div class="product-image">
            <div
              class="product-bg"
              style="
                background-image: url(&quot;/images/p4.png&quot;);
                background-size: cover;
                background-position: center;
                width: 100%;
                height: 100%;
              "
            ></div>
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Osmo Pocket 3</h3>
            <ul class="product-features">
              <li>1英寸传感器</li>
              <li>4K/120fps视频</li>
              <li>智能跟随6.0</li>
              <li>2英寸旋转屏</li>
              <li>166分钟续航</li>
            </ul>
            <div class="product-price">¥3,999起</div>
          </div>
        </div>

        <!-- 产品5 -->
        <div class="product-card">
          <div class="product-image">
            <div
              class="product-bg"
              style="
                background-image: url(&quot;/images/p5.png&quot;);
                background-size: cover;
                background-position: center;
                width: 100%;
                height: 100%;
              "
            ></div>
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Avata Pro-View</h3>
            <ul class="product-features">
              <li>沉浸式飞行体验</li>
              <li>超广角4K视频</li>
              <li>体感操控</li>
              <li>全向避障</li>
              <li>18分钟续航</li>
            </ul>
            <div class="product-price">¥8,499起</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from "vue";

onMounted(() => {
  // 确保在DOM完全渲染后执行动画
  setTimeout(() => {
    const gridItems = document.querySelectorAll(".grid-item");
    gridItems.forEach((item, index) => {
      // 使用CSS类代替直接操作style
      item.style.setProperty("--animation-delay", `${index * 0.1}s`);
      item.classList.add("animate-grid");
    });

    const productCards = document.querySelectorAll(".product-card");
    productCards.forEach((card, index) => {
      // 使用CSS变量控制延迟
      card.style.setProperty("--animation-delay", `${index * 0.1 + 0.4}s`);
      card.classList.add("animate-product");
    });
  }, 300); // 300ms延迟确保浏览器完成初始渲染
});
</script>

<style scoped>
/* === 关键修复 === */
/* 初始状态设置 */
.grid-item {
  position: relative;
}
.product-card {
  opacity: 0;
  transform: translateY(20px);
}

/* 动画类 */
.animate-grid {
  animation: fadeInUp 0.6s ease-out var(--animation-delay) forwards;
}

.animate-product {
  animation: fadeInUp 0.5s ease-out var(--animation-delay) forwards;
}

/* === 布局优化 === */
.container {
  width: 100vw;
  max-width: none;
  padding: 0;
  overflow-x: hidden;
}

.products-container {
  display: flex;
  flex-wrap: nowrap;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
}

.product-card {
  min-width: 320px;
  scroll-snap-align: start;
}

/* === 基础样式 === */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "Roboto", "Helvetica Neue", Arial, sans-serif;
}

/* 全屏Banner */
.banner {
  position: relative;
  height: 80vh;
  min-height: 650px;
  overflow: hidden;
  margin-bottom: 20px;
  background: #f8f9fa;
}

.banner-image {
  background-image: url("/images/banner1.jpg");
  background-size: cover;
  background-position: center;
  width: 100%;
  height: 100%;
  /*background: linear-gradient(135deg, #f0f5ff, #e6f0ff);*/
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}
.banner-image::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background:
    radial-gradient(
      circle at 70% 30%,
      rgba(255, 255, 255, 0.3) 0%,
      transparent 40%
    ),
    radial-gradient(
      circle at 30% 70%,
      rgba(255, 255, 255, 0.2) 0%,
      transparent 50%
    );
}

.banner-content {
  text-align: center;
  color: #0a3d62;
  z-index: 2;
  max-width: 900px;
  padding: 0 20px;
  animation: fadeInUp 1s ease-out;
  margin-top: -500px;
  transform: translateY(-8%);
}

.banner-title {
  font-family: "Montserrat", sans-serif;
  font-size: 4.5rem;
  font-weight: 700;
  margin-top: 0;
  margin-bottom: 15px;
  letter-spacing: 1px;
  color: #ffffff;
}

.banner-subtitle {
  font-size: 1.8rem;
  font-weight: 400;
  margin-bottom: 30px;
  line-height: 1.6;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  color: #ffffff;
}

/* 四宫格布局 */
.grid-section {
  margin-bottom: 80px;
  /*padding: 0 5%;*/
}

.section-title {
  text-align: center;
  font-size: 2.8rem;
  margin-bottom: 50px;
  color: #0a3d62;
  font-weight: 600;
  position: relative;
  font-family: "Montserrat", sans-serif;
}

.grid-container {
  grid-template-columns: repeat(auto-fit, minmax(850px, 1fr));
  display: grid;
  gap: 10px;
}

.grid-item {
  position: relative;
  height: 800px;
  border-radius: 2px;
  overflow: hidden;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
  transition:
    transform 0.4s ease,
    box-shadow 0.4s ease;
  background: #f8f9fa;
  /*border: 1px solid #eee;*/
}

.grid-item:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.grid-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 30px;
  color: #333;
  z-index: 2;
  transition: transform 0.4s ease;
  background: rgba(255, 255, 255, 0);
}

.grid-item:hover .grid-overlay {
  transform: translateY(-10px);
}

.grid-title {
  font-size: 1.8rem;
  margin-bottom: 12px;
  font-weight: 600;
  font-family: "Montserrat", sans-serif;
  color: #0a3d62;
}

.grid-desc {
  font-size: 1.1rem;
  color: #555;
  margin-bottom: 20px;
}

/* 无人机图片样式 */
.drone-img {
  position: absolute;
  z-index: 1;
  transition: transform 0.5s ease;
}

/* 热销产品布局 */
.products-section {
  margin-bottom: 100px;
  padding: 0 20px;
}

.products-container {
  display: flex;
  gap: 10px;
  overflow-x: auto;
  padding-bottom: 30px;
  scroll-snap-type: x mandatory;
  justify-content: center;
}

.products-container::-webkit-scrollbar {
  height: 8px;
}

.products-container::-webkit-scrollbar-thumb {
  background: linear-gradient(to right, #ff6b00, #ff8c3a);
  border-radius: 10px;
}

.product-card {
  /*aspect-ratio: 3/4;
  width: 100%;*/
  width: clamp(320px, 30vw, 480px);
  background: #fff;
  border-radius: 2px;
  overflow: hidden;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
  transition: transform 0.4s ease;
  display: flex;
  flex-direction: column;
  scroll-snap-align: start;
}

.product-card:hover {
  transform: translateY(-15px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.product-image {
  height: 300px;
  background: #f0f2f5;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.product-info {
  padding: 25px;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.product-name {
  font-size: 1.7rem;
  font-weight: 600;
  margin-bottom: 15px;
  color: #0a3d62;
  font-family: "Montserrat", sans-serif;
}

.product-features {
  list-style: none;
  margin-bottom: 25px;
  flex-grow: 1;
}

.product-features li {
  padding: 8px 0;
  font-size: 1rem;
  position: relative;
  padding-left: 25px;
  color: #555;
}

.product-price {
  font-size: 1.7rem;
  font-weight: 700;
  color: #ff8c3a;
  margin-bottom: 20px;
  text-align: right;
}

/* 动画关键帧 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-15px);
  }
  100% {
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .banner-title {
    font-size: 3.8rem;
  }
  .banner-subtitle {
    font-size: 1.6rem;
  }
  .grid-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 992px) {
  .banner {
    height: 80vh;
  }
  .banner-title {
    font-size: 3.2rem;
  }
  .section-title {
    font-size: 2.5rem;
  }
}

@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: 1fr;
  }
  .products-container {
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  }
  .banner {
    height: 70vh;
  }
  .banner-title {
    font-size: 2.5rem;
  }
  .banner-subtitle {
    font-size: 1.3rem;
  }
  .section-title {
    font-size: 2.2rem;
  }
}

@media (max-width: 576px) {
  .banner {
    height: 85vh;
  }
  .banner-title {
    font-size: 2.2rem;
  }
  .banner-subtitle {
    font-size: 1.1rem;
  }
  .section-title {
    font-size: 1.9rem;
  }
}
</style>
