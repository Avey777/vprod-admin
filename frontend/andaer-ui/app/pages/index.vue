<template>
  <div class="dji-page">
    <!-- 主视觉区域 -->
    <section class="hero">
      <h2>重新定义飞行</h2>
      <p>
        大疆创新致力于持续推动人类进步，提供突破性的无人机技术与影像解决方案
      </p>
      <div class="hero-buttons">
        <button class="btn btn-primary">探索产品</button>
        <button class="btn btn-outline">了解更多</button>
      </div>
    </section>

    <!-- 产品展示区域 -->
    <div class="section-title">
      <h2>旗舰产品</h2>
    </div>
    <div class="products">
      <div
        v-for="(product, index) in products"
        :key="index"
        class="product-card"
      >
        <div class="product-image">
          <img :src="product.image" :alt="product.name" />
        </div>
        <div class="product-info">
          <h3>{{ product.name }}</h3>
          <p>{{ product.description }}</p>
          <div class="product-price">
            <div class="price">{{ product.price }}</div>
            <button class="add-to-cart" @click="addToCart(product)">
              <i class="fas fa-plus"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 特色区域 -->
    <div class="section-title">
      <h2>技术优势</h2>
    </div>
    <section class="features">
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">
            <i class="fas fa-camera"></i>
          </div>
          <h3>专业影像</h3>
          <p>提供电影级影像质量，满足专业摄影需求</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">
            <i class="fas fa-rocket"></i>
          </div>
          <h3>智能飞行</h3>
          <p>先进的避障系统与飞行辅助功能</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">
            <i class="fas fa-battery-full"></i>
          </div>
          <h3>持久续航</h3>
          <p>长续航电池技术，提升飞行体验</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">
            <i class="fas fa-shield-alt"></i>
          </div>
          <h3>安全可靠</h3>
          <p>多重安全保障，确保飞行安全</p>
        </div>
      </div>
    </section>

    <!-- 轮播图 -->
    <div class="section-title">
      <h2>新品发布</h2>
    </div>
    <div class="carousel">
      <div
        class="carousel-inner"
        :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
      >
        <div
          v-for="(slide, index) in slides"
          :key="index"
          class="carousel-item"
        >
          <img :src="slide.image" :alt="slide.title" />
          <div class="carousel-caption">
            <h3>{{ slide.title }}</h3>
            <p>{{ slide.description }}</p>
          </div>
        </div>
      </div>
      <div class="carousel-controls">
        <button class="carousel-btn" @click="prevSlide">
          <i class="fas fa-chevron-left"></i>
        </button>
        <button class="carousel-btn" @click="nextSlide">
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
      <div class="carousel-indicators">
        <div
          v-for="(slide, index) in slides"
          :key="index"
          class="indicator"
          :class="{ active: currentSlide === index }"
          @click="currentSlide = index"
        ></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

// 购物车商品数量
const cartCount = ref(0);

// 产品数据
const products = ref([
  {
    id: 1,
    name: "DJI Mavic 3 Pro",
    description: "旗舰三摄航拍无人机，专业影像创作利器，哈苏相机系统",
    price: "¥13,888",
    image:
      "https://images.unsplash.com/photo-1579820010410-c10411aaaa88?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 2,
    name: "DJI Air 2S",
    description: "一英寸传感器，5.4K视频拍摄，大师镜头智能功能",
    price: "¥6,499",
    image:
      "https://images.unsplash.com/photo-1602088113235-229c19758e9f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 3,
    name: "DJI Mini 3 Pro",
    description: "轻于249g，专业级航拍性能，4K HDR视频",
    price: "¥4,788",
    image:
      "https://images.unsplash.com/photo-1620001689041-5f2c8c9a0d8f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 4,
    name: "DJI FPV",
    description: "沉浸式飞行体验，穿越机新标杆，150°超广视角",
    price: "¥7,999",
    image:
      "https://images.unsplash.com/photo-1619380061814-58f03707f082?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
  },
]);

// 轮播图数据
const slides = ref([
  {
    title: "DJI Inspire 3",
    description: "电影级专业无人机，8K全画幅航拍系统，全新智能返航",
    image:
      "https://images.unsplash.com/photo-1579820010410-c10411aaaa88?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80",
  },
  {
    title: "DJI Matrice 350 RTK",
    description: "旗舰行业无人机，为专业作业而生，55分钟超长续航",
    image:
      "https://images.unsplash.com/photo-1508614589041-895b88991e3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80",
  },
  {
    title: "DJI Avata",
    description: "沉浸式飞行体验，第一视角探索世界，自带桨叶保护罩",
    image:
      "https://images.unsplash.com/photo-1620001689041-5f2c8c9a0d8f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80",
  },
]);

// 当前轮播图索引
const currentSlide = ref(0);

// 添加到购物车
const addToCart = (product) => {
  cartCount.value++;
  alert(`${product.name} 已添加到购物车`);
};

// 上一张轮播图
const prevSlide = () => {
  currentSlide.value =
    (currentSlide.value - 1 + slides.value.length) % slides.value.length;
};

// 下一张轮播图
const nextSlide = () => {
  currentSlide.value = (currentSlide.value + 1) % slides.value.length;
};

// 自动轮播逻辑
onMounted(() => {
  const interval = setInterval(() => {
    nextSlide();
  }, 5000);

  // 清除定时器
  return () => clearInterval(interval);
});
</script>

<style scoped>
.dji-page {
  --dji-red: #e51c23;
  --dji-dark: #0c0c0c;
  --dji-gray: #1a1a1a;
  --dji-light: #f0f0f0;
  --dji-text: #e0e0e0;

  background-color: var(--dji-dark);
  color: var(--dji-text);
  overflow-x: hidden;
  min-height: 100vh;
  padding: 20px;
}

.dji-page * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "Arial", "PingFang SC", "Microsoft YaHei", sans-serif;
}

/* 主视觉区域 */
.dji-page .hero {
  height: 70vh;
  background:
    linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
    url("https://images.unsplash.com/photo-1508615070457-7baeba4003ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80")
      center/cover no-repeat;
  border-radius: 15px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 0 20px;
  margin-bottom: 50px;
  position: relative;
  overflow: hidden;
}

.dji-page .hero:after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 150px;
  background: linear-gradient(transparent, var(--dji-dark));
}

.dji-page .hero h2 {
  font-size: 4.5rem;
  font-weight: 700;
  margin-bottom: 20px;
  letter-spacing: 2px;
  text-transform: uppercase;
  background: linear-gradient(45deg, #fff, #aaa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  z-index: 2;
}

.dji-page .hero p {
  font-size: 1.5rem;
  max-width: 700px;
  margin-bottom: 40px;
  line-height: 1.6;
  z-index: 2;
}

.dji-page .hero-buttons {
  display: flex;
  gap: 20px;
  z-index: 2;
}

.dji-page .btn {
  padding: 14px 35px;
  border-radius: 30px;
  font-size: 16px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.dji-page .btn-primary {
  background-color: var(--dji-red);
  color: white;
  border: none;
}

.dji-page .btn-primary:hover {
  background-color: #c4141a;
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(229, 28, 35, 0.3);
}

.dji-page .btn-outline {
  background-color: transparent;
  color: white;
  border: 2px solid white;
}

.dji-page .btn-outline:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateY(-3px);
}

/* 产品展示区域 */
.dji-page .section-title {
  text-align: center;
  padding: 40px 0;
  position: relative;
  margin-bottom: 20px;
}

.dji-page .section-title h2 {
  font-size: 2.5rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 2px;
  margin-bottom: 15px;
  background: linear-gradient(45deg, #fff, #aaa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.dji-page .section-title:after {
  content: "";
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 4px;
  background-color: var(--dji-red);
  border-radius: 2px;
}

.dji-page .products {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 60px;
}

.dji-page .product-card {
  background-color: var(--dji-gray);
  border-radius: 15px;
  overflow: hidden;
  transition:
    transform 0.4s,
    box-shadow 0.4s;
  position: relative;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}

.dji-page .product-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5);
}

.dji-page .product-image {
  height: 250px;
  overflow: hidden;
}

.dji-page .product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s;
}

.dji-page .product-card:hover .product-image img {
  transform: scale(1.1);
}

.dji-page .product-info {
  padding: 20px;
}

.dji-page .product-info h3 {
  font-size: 1.4rem;
  margin-bottom: 10px;
  color: white;
}

.dji-page .product-info p {
  color: #aaa;
  margin-bottom: 15px;
  line-height: 1.5;
  min-height: 70px;
}

.dji-page .product-price {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dji-page .price {
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--dji-red);
}

.dji-page .add-to-cart {
  background-color: rgba(229, 28, 35, 0.2);
  color: var(--dji-red);
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dji-page .add-to-cart:hover {
  background-color: var(--dji-red);
  color: white;
  transform: rotate(90deg);
}

/* 特色区域 */
.dji-page .features {
  background-color: var(--dji-gray);
  padding: 50px 30px;
  border-radius: 15px;
  margin-bottom: 60px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.dji-page .features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
  max-width: 1200px;
  margin: 0 auto;
}

.dji-page .feature-card {
  text-align: center;
  padding: 30px;
  border-radius: 10px;
  transition: transform 0.3s;
  background: rgba(0, 0, 0, 0.3);
}

.dji-page .feature-card:hover {
  transform: translateY(-10px);
  background: rgba(229, 28, 35, 0.1);
}

.dji-page .feature-icon {
  font-size: 3rem;
  color: var(--dji-red);
  margin-bottom: 20px;
  transition: transform 0.3s;
}

.dji-page .feature-card:hover .feature-icon {
  transform: scale(1.2);
}

.dji-page .feature-card h3 {
  font-size: 1.4rem;
  margin-bottom: 15px;
  color: white;
}

.dji-page .feature-card p {
  color: #aaa;
  line-height: 1.6;
}

/* 轮播图 */
.dji-page .carousel {
  margin: 0 auto 50px;
  position: relative;
  overflow: hidden;
  border-radius: 15px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
  max-width: 1200px;
}

.dji-page .carousel-inner {
  display: flex;
  transition: transform 0.5s ease;
}

.dji-page .carousel-item {
  min-width: 100%;
  position: relative;
}

.dji-page .carousel-item img {
  width: 100%;
  display: block;
  max-height: 500px;
  object-fit: cover;
}

.dji-page .carousel-caption {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
  padding: 30px;
  color: white;
}

.dji-page .carousel-caption h3 {
  font-size: 1.8rem;
  margin-bottom: 10px;
  color: white;
}

.dji-page .carousel-controls {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 100%;
  display: flex;
  justify-content: space-between;
  padding: 0 20px;
}

.dji-page .carousel-btn {
  background: rgba(0, 0, 0, 0.5);
  border: none;
  color: white;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  font-size: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.3s;
}

.dji-page .carousel-btn:hover {
  background: rgba(0, 0, 0, 0.8);
}

.dji-page .carousel-indicators {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 10px;
}

.dji-page .indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  cursor: pointer;
  transition: background 0.3s;
}

.dji-page .indicator.active {
  background: var(--dji-red);
  transform: scale(1.2);
}

/* 响应式设计 */
@media (max-width: 992px) {
  .dji-page .hero h2 {
    font-size: 3.5rem;
  }

  .dji-page .hero p {
    font-size: 1.2rem;
  }
}

@media (max-width: 768px) {
  .dji-page .hero {
    height: 60vh;
  }

  .dji-page .hero h2 {
    font-size: 2.5rem;
  }

  .dji-page .hero p {
    font-size: 1rem;
  }

  .dji-page .hero-buttons {
    flex-direction: column;
    gap: 15px;
  }

  .dji-page .btn {
    width: 100%;
  }

  .dji-page .section-title h2 {
    font-size: 2rem;
  }
}
</style>
