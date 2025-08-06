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
  background: linear-gradient(white, white);
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
  color: #334155;
  font-weight: 500;
  padding: 0.5rem 0;
  transition: all 0.3s ease;
}

.nav-link:hover {
  color: #6366f1;
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
  color: #6366f1;
}

.nav-link.active .link-text::after {
  transform: scaleX(1);
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
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
    color: #334155;
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
