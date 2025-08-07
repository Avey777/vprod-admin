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
        <span class="brand">Andaer</span>
      </NuxtLink>
    </div>

    <!-- 导航链接 -->
    <div class="nav-links">
      <NuxtLink to="/" class="nav-link" exact-active-class="active">
        <span class="link-text">Home</span>
      </NuxtLink>
      <NuxtLink to="/" class="nav-link" active-class="active">
        <span class="link-text">Flight</span>
      </NuxtLink>
      <NuxtLink to="/" class="nav-link" active-class="active">
        <span class="link-text">Service</span>
      </NuxtLink>
      <NuxtLink to="/" class="nav-link" active-class="active">
        <span class="link-text">About Us</span>
      </NuxtLink>
      <NuxtLink to="/" class="nav-link" active-class="active">
        <span class="link-text">Contact Us</span>
      </NuxtLink>
    </div>

    <!-- 用户操作 -->
    <div class="user-actions">
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
        Home
      </NuxtLink>
      <NuxtLink to="/" class="mobile-nav-link" @click="closeMenu">
        Flight
      </NuxtLink>
      <NuxtLink to="/" class="mobile-nav-link" @click="closeMenu">
        Service
      </NuxtLink>
      <NuxtLink to="/" class="mobile-nav-link" @click="closeMenu">
        About Us
      </NuxtLink>
      <NuxtLink to="/contact" class="mobile-nav-link" @click="closeMenu">
        Contact Us
      </NuxtLink>
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
  justify-content: center;
  align-items: center;
  padding: 1rem 5%;
  background: white;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  max-width: 100vw;
  overflow-x: hidden;
}

.logo {
  margin-right: 180px;
}
.logo-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
}

.logo-icon {
  width: 20px;
  height: 20px;
  background: linear-gradient(135deg, #0a3d62 0%, #0a3d62 100%);
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
  background: linear-gradient(to right, #0a3d62, #0a3d62);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.nav-links {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.nav-link {
  position: relative;
  text-decoration: none;
  color: #334155;
  font-weight: 500;
  padding: 0.5rem 0;
  transition: all 0.3s ease;
}

.nav-link:hover {
  color: #0a3d62;
}

.link-text {
  font-size: 0.8rem;
  position: relative;
}

.link-text::after {
  content: "";
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(to right, #0a3d62, #0a3d62);
  transform: scaleX(0);
  transform-origin: right;
  transition: transform 0.3s ease;
}

.nav-link:hover .link-text::after {
  transform: scaleX(1);
}

.nav-link.active .link-text {
  font-size: 1rem;
  color: #0a3d62;
  font-weight: 600;
}

.nav-link.active .link-text::after {
  transform: scaleX(1);
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.mobile-menu-btn {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
}

.mobile-menu-btn svg {
  width: 24px;
  height: 24px;
  stroke: #334155;
}

.mobile-menu {
  display: none;
  flex-direction: column;
  position: fixed;
  top: 80px;
  left: 0;
  right: 0;
  background: white;
  padding: 1rem;
  transform: translateY(-150%);
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
  color: #334155;
  font-weight: 500;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.mobile-nav-link:hover,
.mobile-nav-link.active {
  color: #0a3d62;
  background: rgba(99, 102, 241, 0.05);
}

/* 响应式设计 */
@media (max-width: 992px) {
  .nav-links {
    display: none;
  }

  .mobile-menu-btn {
    display: block;
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
