<template>
  <footer class="footer">
    <div class="footer-top">
      <div class="footer-nav">
        <div class="nav-section">
          <ul>
            <li class="nav-main">
              <h4 class="nav-title">Safe Flight</h4>
              <ul class="sub-links">
                <li>
                  <a href="#"
                    ><i class="fas fa-bolt" />Safe Flight Guidelines</a
                  >
                </li>
              </ul>
            </li>
            <li class="nav-main">
              <h4 class="nav-title">Help and Support</h4>
              <ul class="sub-links">
                <li>
                  <a href="#"
                    ><i class="fas fa-users" /> After sales service policy</a
                  >
                </li>
                <li>
                  <a href="#"
                    ><i class="fas fa-envelope" /> Security and Privacy</a
                  >
                </li>
              </ul>
            </li>
            <li class="nav-main">
              <h4 class="nav-title">About Us</h4>
              <ul class="sub-links">
                <li>
                  <a href="#"><i class="fas fa-users" /> Our Team</a>
                </li>
                <li>
                  <a href="#"><i class="fas fa-envelope" /> Contact Us</a>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>

      <div class="subscribe-section">
        <h4>Andaer is walking with you</h4>
        <p>Get the latest product news and industry insights</p>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="bottom-divider" />

      <div class="copyright">
        © {{ currentYear }} Andaer Electric Solutions. All rights reserved.
      </div>
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
            viewBox="0 0 24 24"
            width="24"
            height="24"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"
              fill="currentColor"
            />
          </svg>
        </a>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: "AppFooter",
  data() {
    return {
      currentYear: new Date().getFullYear(),
    };
  },
};
</script>

<style scoped>
.footer {
  background-color: white;
  color: #333;
  padding: 0 5% 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.footer-top {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding-top: 45px;
  padding-bottom: 25px;
  gap: 40px;
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
  gap: 30px 100px;
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
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.sub-links li {
  display: block;
}

a,
.top-link {
  text-decoration: none;
  color: #2a6dbd;
  font-size: 0.95rem;
  transition: color 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

a:hover,
.top-link:hover {
  color: #003580;
  text-decoration: underline;
}

.subscribe-section {
  min-width: 300px;
  max-width: 350px;
  margin: 0 auto;
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

.copyright {
  color: #666;
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
    gap: 15px;
  }

  .social-links {
    justify-content: center;
  }
}
</style>
