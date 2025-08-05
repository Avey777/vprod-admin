<template>
  <nav class="navbar">
    <!-- Logo 区域 -->
    <div class="logo">
      <NuxtLink to="/" class="logo-link">
        <div class="logo-icon">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
          </svg>
        </div>
        <span class="brand">Andaer<span class="highlight">UI</span></span>
      </NuxtLink>
    </div>

    <!-- 导航链接 -->
    <div class="nav-links">
      <NuxtLink to="/" class="nav-link" exact-active-class="active">
        <span class="link-text">首页</span>
      </NuxtLink>
      <NuxtLink to="/products" class="nav-link" active-class="active">
        <span class="link-text">产品</span>
      </NuxtLink>
      <NuxtLink to="/services" class="nav-link" active-class="active">
        <span class="link-text">服务</span>
      </NuxtLink>
      <NuxtLink to="/about" class="nav-link" active-class="active">
        <span class="link-text">关于我们</span>
      </NuxtLink>
      <NuxtLink to="/contact" class="nav-link" active-class="active">
        <span class="link-text">联系我们</span>
      </NuxtLink>
    </div>

    <!-- 用户操作 -->
    <div class="user-actions">
      <button class="search-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <circle cx="11" cy="11" r="8" />
          <line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
      </button>
      <button class="cart-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <circle cx="9" cy="21" r="1" />
          <circle cx="20" cy="21" r="1" />
          <path
            d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"
          />
        </svg>
        <span class="cart-count">3</span>
      </button>
      <button class="auth-btn">登录/注册</button>
      <button class="mobile-menu-btn" @click="toggleMenu">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <line x1="3" y1="12" x2="21" y2="12" />
          <line x1="3" y1="6" x2="21" y2="6" />
          <line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      </button>
    </div>

    <!-- 移动端菜单 -->
    <div class="mobile-menu" :class="{ open: menuOpen }">
      <NuxtLink to="/" class="mobile-nav-link" @click="closeMenu">
        <span>首页</span>
      </NuxtLink>
      <NuxtLink to="/products" class="mobile-nav-link" @click="closeMenu">
        <span>产品</span>
      </NuxtLink>
      <NuxtLink to="/services" class="mobile-nav-link" @click="closeMenu">
        <span>服务</span>
      </NuxtLink>
      <NuxtLink to="/about" class="mobile-nav-link" @click="closeMenu">
        <span>关于我们</span>
      </NuxtLink>
      <NuxtLink to="/contact" class="mobile-nav-link" @click="closeMenu">
        <span>联系我们</span>
      </NuxtLink>
      <div class="mobile-auth">
        <button class="mobile-login-btn">登录</button>
        <button class="mobile-signup-btn">注册</button>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: "AppNavbar",
  data() {
    return {
      menuOpen: false,
    };
  },
  methods: {
    toggleMenu() {
      this.menuOpen = !this.menuOpen;
    },
    closeMenu() {
      this.menuOpen = false;
    },
  },
};
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  color: white;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.logo-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
}

.logo-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem;
}

.logo-icon svg {
  width: 24px;
  height: 24px;
  fill: white;
}

.brand {
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(to right, #8b5cf6, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.highlight {
  background: linear-gradient(to right, #ec4899, #f97316);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.nav-link {
  position: relative;
  text-decoration: none;
  color: #cbd5e1;
  font-weight: 500;
  padding: 0.5rem 0;
  transition: all 0.3s ease;
}

.nav-link:hover {
  color: white;
}

.nav-link:hover .link-text::after {
  transform: scaleX(1);
}

.link-text {
  position: relative;
}

.link-text::after {
  content: "";
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(to right, #6366f1, #8b5cf6);
  transform: scaleX(0);
  transform-origin: right;
  transition: transform 0.3s ease;
}

.nav-link.active .link-text {
  color: white;
}

.nav-link.active .link-text::after {
  transform: scaleX(1);
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.search-btn,
.cart-btn,
.mobile-menu-btn {
  background: transparent;
  border: none;
  color: #cbd5e1;
  cursor: pointer;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  position: relative;
}

.search-btn:hover,
.cart-btn:hover,
.mobile-menu-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.search-btn svg,
.cart-btn svg,
.mobile-menu-btn svg {
  width: 20px;
  height: 20px;
  stroke: currentColor;
  fill: none;
  stroke-width: 2;
  stroke-linecap: round;
  stroke-linejoin: round;
}

.cart-count {
  position: absolute;
  top: -2px;
  right: -2px;
  background: #ef4444;
  color: white;
  font-size: 0.7rem;
  font-weight: 700;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.auth-btn {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
  border: none;
  border-radius: 30px;
  padding: 0.5rem 1.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(99, 102, 241, 0.3);
}

.auth-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 8px rgba(99, 102, 241, 0.4);
}

.mobile-menu-btn {
  display: none;
}

.mobile-menu {
  display: none;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .nav-links {
    display: none;
  }

  .auth-btn {
    display: none;
  }

  .mobile-menu-btn {
    display: flex;
  }

  .mobile-menu {
    display: flex;
    flex-direction: column;
    position: fixed;
    top: 80px;
    left: 0;
    right: 0;
    background: #0f172a;
    padding: 1rem;
    transform: translateY(-100%);
    transition: transform 0.3s ease;
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
    z-index: 90;
  }

  .mobile-menu.open {
    transform: translateY(0);
  }

  .mobile-nav-link {
    padding: 1rem;
    text-decoration: none;
    color: #cbd5e1;
    font-weight: 500;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.2s ease;
  }

  .mobile-nav-link:hover {
    color: white;
    background: rgba(255, 255, 255, 0.05);
  }

  .mobile-auth {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
    padding: 1rem 0;
  }

  .mobile-login-btn,
  .mobile-signup-btn {
    flex: 1;
    padding: 0.75rem;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .mobile-login-btn {
    background: transparent;
    border: 1px solid #6366f1;
    color: #6366f1;
  }

  .mobile-signup-btn {
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
    border: none;
    color: white;
  }

  .mobile-login-btn:hover,
  .mobile-signup-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px rgba(99, 102, 241, 0.3);
  }
}

@media (max-width: 576px) {
  .navbar {
    padding: 1rem;
  }

  .brand {
    font-size: 1.25rem;
  }

  .logo-icon {
    width: 36px;
    height: 36px;
  }
}
</style>
