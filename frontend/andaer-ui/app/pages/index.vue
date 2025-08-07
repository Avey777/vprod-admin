<template>
  <div class="container">
    <!-- 全屏Banner -->
    <div class="banner">
      <div class="banner-image">
        <div class="banner-content">
          <h1 class="banner-title">Future Flight Thrills</h1>
          <p class="banner-subtitle">
            Future-Tech Flight — Pure Excitement Omnidirectional avoidance ·
            Extended endurance · Intuitive control Every flight delivers
            exhilarating thrills!
          </p>
        </div>
      </div>
    </div>
    <!-- 智能飞行新境界
    未来科技，畅享空中乐趣！全方位避障系统，超长续航，操控自如，让每一次飞行都充满惊喜 -->

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
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              animation: float 6s infinite ease-in-out;
            "
          />
          <div class="grid-overlay">
            <h3 class="grid-title">Aerial drone</h3>
            <p class="grid-desc">
              Professional level aerial photography solution, capturing
              magnificent aerial images
            </p>
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
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              animation: float 6s infinite ease-in-out;
            "
          />
          <div class="grid-overlay">
            <h3 class="grid-title">Handheld gimbal</h3>
            <p class="grid-desc">
              Stable shooting of every moment, creating smoother images
            </p>
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
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              animation: float 6s infinite ease-in-out;
            "
          />
          <div class="grid-overlay">
            <h3 class="grid-title">Play Technology</h3>
            <p class="grid-desc">
              Play high-tech drones and become future technology talents
            </p>
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
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              animation: float 6s infinite ease-in-out;
            "
          />
          <div class="grid-overlay">
            <h3 class="grid-title">Enjoy Technology</h3>
            <p class="grid-desc">Intelligent navigation, do as you please</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 五产品横向布局 -->
    <div class="products-section">
      <h2 class="section-title">Popular products</h2>
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Mavic 3 Pro</h3>
            <ul class="product-features">
              <li>Hasselblad triple camera system</li>
              <li>43 minute battery life</li>
              <li>15 kilometer map transmission</li>
              <li>Omnidirectional obstacle avoidance</li>
              <li>5.1K video shooting</li>
            </ul>
            <div class="product-price">$12,999 up</div>
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Mini 3 Pro</h3>
            <ul class="product-features">
              <li>Less than 249 grams</li>
              <li>4K HDR video</li>
              <li>Three way obstacle avoidance</li>
              <li>34 minute battery life</li>
              <li>Master lens function</li>
            </ul>
            <div class="product-price">$4,788 up</div>
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Air 2S</h3>
            <ul class="product-features">
              <li>1-inch sensor</li>
              <li>5.4K video shooting</li>
              <li>Master lens function</li>
              <li>Four way obstacle avoidance</li>
              <li>31 minute battery life</li>
            </ul>
            <div class="product-price">$6,499 up</div>
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Osmo Pocket 3</h3>
            <ul class="product-features">
              <li>1-inch sensor</li>
              <li>4K/120fps video</li>
              <li>Intelligent Follow 6.0</li>
              <li>2-inch rotating screen</li>
              <li>166 minute battery life</li>
            </ul>
            <div class="product-price">$3,999 up</div>
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Avata Pro-View</h3>
            <ul class="product-features">
              <li>Immersive flying experience</li>
              <li>Ultra wide angle 4K video</li>
              <li>motion sensing</li>
              <li>Omnidirectional obstacle avoidance</li>
              <li>18 minute battery life</li>
            </ul>
            <div class="product-price">¥8,499起</div>
          </div>
        </div>

        <!-- 产品6 -->
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
            />
          </div>
          <div class="product-info">
            <h3 class="product-name">DJI Avata Pro-View</h3>
            <ul class="product-features">
              <li>Immersive flying experience</li>
              <li>Ultra wide angle 4K video</li>
              <li>motion sensing</li>
              <li>Omnidirectional obstacle avoidance</li>
              <li>18 minute battery life</li>
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
  setTimeout(() => {
    const gridItems = document.querySelectorAll(".grid-item");
    gridItems.forEach((item, index) => {
      item.style.setProperty("--animation-delay", `${index * 0.1}s`);
      item.classList.add("animate-grid");
    });

    const productCards = document.querySelectorAll(".product-card");
    productCards.forEach((card, index) => {
      card.style.setProperty("--animation-delay", `${index * 0.1 + 0.4}s`);
      card.classList.add("animate-product");
    });
  }, 300);
});
</script>

<style scoped>
.container {
  width: 100%;
  padding: 0;
  overflow-x: hidden;
}

.banner {
  position: relative;
  height: 95vh;
  min-height: 650px;
  overflow: hidden;
  margin-bottom: 15px;
}

.banner-image {
  background-image: url("/images/banner1.jpg");
  background-size: cover;
  background-position: center;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
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
}

.banner-title {
  font-family: "Montserrat", sans-serif;
  font-size: clamp(2.2rem, 5vw, 4.5rem);
  font-weight: 700;
  margin-top: -500px; /*调整文案高度*/
  color: #ffffff;
}

.banner-subtitle {
  font-size: clamp(1.1rem, 2.5vw, 1.8rem);
  font-weight: 400;
  margin-top: 30px;
  line-height: 1.6;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  color: #ffffff;
}

.grid-section {
  margin-bottom: 80px;
  /* 控制左右空白 */
  padding: 0 0%;
}

.section-title {
  text-align: center;
  font-size: clamp(1.9rem, 4vw, 2.8rem);
  margin-bottom: 50px;
  color: #0a3d62;
  font-weight: 600;
  font-family: "Montserrat", sans-serif;
}

.grid-container {
  display: grid;
  /* 保持两列布局 */
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;

  /* 确保容器宽度铺满父元素 */
  width: 100%;
  max-width: 100%;
  /* 边距和内边距优化 */
  margin: 0;
  padding: 0px; /* 增加内边距使内容不贴边 */
  /* 确保网格项填满网格单元格 */
  justify-items: stretch;
  align-items: stretch;
  box-sizing: border-box;
  /* 添加响应式处理 */
  gap: min(2vw, 15px);
}

.grid-item {
  position: relative;
  /* 修改高度为自适应 */
  height: auto;
  /* 添加最小高度确保显示 */
  min-height: 300px;
  /* 添加宽高比保持比例 */
  aspect-ratio: 3/2;
  border-radius: 2px;
  overflow: hidden;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
  transition:
    transform 0.4s ease,
    box-shadow 0.4s ease;
  background: #f8f9fa;

  /* 添加弹性布局使内部内容居中 */
  display: flex;
  align-items: center;
  justify-content: center;
  /* 确保项目填满网格单元格 */
  width: 100%;
  min-width: 0; /* 防止内容溢出 */
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
  /*background: rgba(255, 255, 255, 0.5);*/
}

.grid-title {
  font-size: 1.5rem;
  margin-bottom: 12px;
  font-weight: 600;
  color: #0a3d62;
}

.grid-desc {
  font-size: 1rem;
  color: #555;
}

.products-section {
  margin-bottom: 100px;
  padding: 0 0%;
}

.products-container {
  display: flex;
  gap: 20px;
  overflow-x: auto;
  padding: 0 0px 50px 0;
  scrollbar-width: none;
  -ms-overflow-style: none;
  max-width: 100%;
}

.products-container::-webkit-scrollbar {
  height: 8px;
}

.products-container::-webkit-scrollbar-thumb {
  background: linear-gradient(to right, #ff6b00, #ff8c3a);
  border-radius: 10px;
}

.product-card {
  width: 400px;
  min-width: 320px;
  background: #fff;
  border-radius: 8px;
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
  height: 320px;
  background: #f0f2f5;
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
  font-size: 1.4rem;
  font-weight: 600;
  margin-bottom: 15px;
  color: #0a3d62;
}

.product-features {
  list-style: none;
  margin: 0 0 25px 0;
  flex-grow: 1;
  padding: 0;
}

.product-features li {
  padding: 8px 0;
  font-size: 1rem;
  position: relative;
  padding-left: 10px;
  color: #555;
  left: 1;
}

.product-price {
  font-size: 1.5rem;
  font-weight: 700;
  color: #ff8c3a;
  margin-bottom: 10px;
  text-align: right;
}

.grid-item,
.product-card {
  opacity: 0;
  transform: translateY(20px);
}

.animate-grid {
  animation: fadeInUp 0.6s ease-out var(--animation-delay) forwards;
}

.animate-product {
  animation: fadeInUp 0.5s ease-out var(--animation-delay) forwards;
}

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

@media (max-width: 992px) {
  .banner {
    height: 70vh;
    min-height: 500px;
  }

  .grid-item {
    height: 400px;
  }
}

@media (max-width: 768px) {
  .banner {
    height: 60vh;
  }

  .grid-container {
    grid-template-columns: 1fr;
  }

  .grid-item {
    height: 350px;
  }

  .product-card {
    min-width: 280px;
  }
}

@media (max-width: 576px) {
  .banner {
    height: 50vh;
  }

  .grid-section {
    padding: 0 20px;
  }

  .products-section {
    padding: 0 10px;
  }
}
</style>
