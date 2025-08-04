<template>
  <footer class="footer">
    <!-- 顶部灰色细分割线 -->
    <div class="top-divider"></div>

    <div class="footer-top">
      <div class="footer-nav">
        <div class="nav-section">
          <ul>
            <li class="nav-main">
              <h4 class="nav-title">Drive Electric</h4>
              <ul class="sub-links">
                <li><a href="#">Ekon</a></li>
                <li><a href="#">Spiro Maps</a></li>
                <li><a href="#">Spiro IoT</a></li>
                <li><a href="#">CredTrack</a></li>
              </ul>
            </li>
            <li class="nav-main">
              <a href="#" class="top-link">Tech Stack</a>
            </li>
            <li class="nav-main">
              <h4 class="nav-title">About Us</h4>
              <ul class="sub-links">
                <li><a href="#">Our Team</a></li>
                <li><a href="#">Contact Us</a></li>
              </ul>
            </li>
            <li class="nav-main"><a href="#" class="top-link">FAQ</a></li>
            <li class="nav-main">
              <a href="#" class="top-link">Trust Center</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="subscribe-section">
        <h4>Subscribe</h4>
        <p>Get product updates</p>
        <div class="input-group">
          <input
            type="email"
            placeholder="Enter your email"
            class="email-input"
            v-model="email"
          />
          <button class="send-button" @click="subscribe">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="white"
              width="16px"
              height="16px"
            >
              <path d="M0 0h24v24H0z" fill="none" />
              <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
            </svg>
          </button>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="bottom-divider"></div>

      <div class="copyright">© 2024 Spiro. All rights reserved.</div>
      <div class="social-links">
        <a href="#" aria-label="LinkedIn">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            width="20"
            height="20"
          >
            <path
              d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"
            />
          </svg>
        </a>
        <a href="#" aria-label="Facebook">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            width="20"
            height="20"
          >
            <path
              d="M22.675 0H1.325C.593 0 0 .593 0 1.325v21.351C0 23.407.593 24 1.325 24H12.82v-9.294H9.692v-3.622h3.128V8.413c0-3.1 1.893-4.788 4.659-4.788 1.325 0 2.463.099 2.795.143v3.24l-1.918.001c-1.504 0-1.795.715-1.795 1.763v2.313h3.587l-.467 3.622h-3.12V24h6.116c.73 0 1.323-.593 1.323-1.325V1.325C24 .593 23.407 0 22.675 0z"
            />
          </svg>
        </a>
        <a href="#" aria-label="Twitter">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            width="20"
            height="20"
          >
            <path
              d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.937 4.937 0 004.604 3.417 9.868 9.868 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"
            />
          </svg>
        </a>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref } from "vue";

const email = ref("");

const subscribe = () => {
  if (email.value) {
    alert(`Subscribed: ${email.value} will receive updates`);
    email.value = "";
  }
};
</script>

<style scoped>
.footer {
  background-color: white;
  color: #333;
  padding: 0 5% 30px;
  font-family: "Segoe UI", system-ui, sans-serif;
  position: relative;
}

/* 顶部分割线 - 极细灰色且横跨全屏 */
.top-divider {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 0.5px;
  background-color: #e0e0e0;
}

.footer-top {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding-top: 45px; /* 增加顶部间距 */
  padding-bottom: 25px;
}

.footer-nav {
  flex: 1;
  min-width: 300px;
}

.nav-section ul {
  display: flex;
  flex-wrap: wrap;
  list-style: none;
  padding: 0;
  margin: 0;
  gap: 45px;
}

.nav-main {
  min-width: 160px;
}

.nav-title {
  margin: 0 0 16px;
  font-size: 1.15rem;
  font-weight: 600;
  color: #1a3b5d;
}

.sub-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sub-links li {
  margin-bottom: 14px;
  display: block;
  margin: 5px 0; /* 上下间距5px */
}

a,
.top-link {
  text-decoration: none;
  color: #2a6dbd;
  font-size: 0.95rem;
  transition: color 0.2s;
}

.top-link {
  font-weight: 500;
  color: #1a3b5d;
  display: block;
  padding: 8px 0;
}

a:hover,
.top-link:hover {
  color: #003580;
  text-decoration: underline;
}

.subscribe-section {
  min-width: 300px;
  max-width: 350px;
}

.subscribe-section h4 {
  margin: 0 0 12px;
  font-size: 1.15rem;
  font-weight: 600;
  color: #1a3b5d;
}

.subscribe-section p {
  margin: 0 0 20px;
  font-size: 0.95rem;
  color: #555;
}

.input-group {
  display: flex;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.08);
}

.email-input {
  flex: 1;
  padding: 14px 16px;
  border: 1px solid #ddd;
  border-right: none;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s;
}

.email-input:focus {
  border-color: #2a6dbd;
}

.send-button {
  background-color: #2a6dbd;
  border: none;
  padding: 0 22px;
  cursor: pointer;
  transition: background-color 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.send-button:hover {
  background-color: #1d4f8c;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 25px;
  font-size: 0.85rem;
  color: #666;
  flex-wrap: wrap;
  gap: 20px;
  position: relative;
}

.bottom-divider {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background-color: #eaeaea;
}

.social-links {
  display: flex;
  gap: 22px;
}

.social-links a {
  display: flex;
  color: #666;
  transition: color 0.2s;
}

.social-links a:hover {
  color: #2a6dbd;
}

@media (max-width: 900px) {
  .footer-top {
    flex-direction: column;
    gap: 35px;
  }

  .nav-section ul {
    gap: 25px;
    row-gap: 30px;
  }

  .subscribe-section {
    max-width: 100%;
  }

  .footer-bottom {
    flex-direction: column;
    text-align: center;
  }

  .social-links {
    justify-content: center;
  }
}
</style>
