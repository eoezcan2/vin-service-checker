<script setup>
// Footer component with about us and other relevant information
</script>

<template>
  <footer class="app-footer">
    <div class="footer-content">
      <div class="footer-section">
        <h5 class="footer-title">Service Checker</h5>
        <p class="footer-description">
          Ihre zuverlässige Lösung für die Verwaltung und Überwachung der Wartungshistorie Ihrer Fahrzeuge.
        </p>
        <div class="social-links">
          <a href="#" class="social-link" title="Facebook">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
            </svg>
          </a>
          <a href="#" class="social-link" title="Twitter">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
            </svg>
          </a>
          <a href="#" class="social-link" title="LinkedIn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
            </svg>
          </a>
        </div>
      </div>

      <div class="footer-section">
        <h6 class="footer-subtitle">Über uns</h6>
        <ul class="footer-links">
          <li><router-link to="/about" class="footer-link">Über Service Checker</router-link></li>
          <li><a href="#" class="footer-link">Unser Team</a></li>
          <li><a href="#" class="footer-link">Karriere</a></li>
          <li><a href="#" class="footer-link">Presse</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h6 class="footer-subtitle">Services</h6>
        <ul class="footer-links">
          <li><a href="#" class="footer-link">Fahrzeugverwaltung</a></li>
          <li><a href="#" class="footer-link">Wartungserinnerungen</a></li>
          <li><a href="#" class="footer-link">Service-Historie</a></li>
          <li><a href="#" class="footer-link">Kostenverfolgung</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h6 class="footer-subtitle">Support</h6>
        <ul class="footer-links">
          <li><a href="#" class="footer-link">Hilfe-Center</a></li>
          <li><a href="#" class="footer-link">Kontakt</a></li>
          <li><a href="#" class="footer-link">FAQ</a></li>
          <li><a href="#" class="footer-link">Feedback</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h6 class="footer-subtitle">Rechtliches</h6>
        <ul class="footer-links">
          <li><a href="#" class="footer-link">Datenschutz</a></li>
          <li><a href="#" class="footer-link">AGB</a></li>
          <li><a href="#" class="footer-link">Impressum</a></li>
          <li><a href="#" class="footer-link">Cookie-Richtlinie</a></li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="footer-bottom-content">
        <p class="copyright">
          © {{ new Date().getFullYear() }} Service Checker. Alle Rechte vorbehalten.
        </p>
        <div class="footer-bottom-links">
          <a href="#" class="footer-bottom-link">Datenschutz</a>
          <a href="#" class="footer-bottom-link">AGB</a>
          <a href="#" class="footer-bottom-link">Impressum</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
/* Footer Container */
.app-footer {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  color: #ffffff;
  margin-top: auto;
  position: relative;
}

/* Main Footer Content */
.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 3rem 1rem 2rem;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

/* Footer Sections */
.footer-section {
  display: flex;
  flex-direction: column;
}

.footer-title {
  color: #ffffff;
  font-weight: 700;
  font-size: 1.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #0d6efd, #0b5ed7);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.footer-subtitle {
  color: #ffffff;
  font-weight: 600;
  font-size: 1rem;
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.footer-description {
  color: #b8c5d6;
  font-size: 0.9rem;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

/* Social Links */
.social-links {
  display: flex;
  gap: 1rem;
  margin-top: auto;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  color: #ffffff;
  text-decoration: none;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.social-link:hover {
  background: linear-gradient(135deg, #0d6efd, #0b5ed7);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(13, 110, 253, 0.3);
}

/* Footer Links */
.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-links li {
  margin-bottom: 0.75rem;
}

.footer-link {
  color: #b8c5d6;
  text-decoration: none;
  font-size: 0.9rem;
  transition: all 0.3s ease;
  position: relative;
  padding-left: 0;
}

.footer-link:hover {
  color: #ffffff;
  padding-left: 8px;
}

.footer-link::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  width: 0;
  height: 2px;
  background: linear-gradient(90deg, #0d6efd, #0b5ed7);
  transition: width 0.3s ease;
  transform: translateY(-50%);
}

.footer-link:hover::before {
  width: 6px;
}

/* Footer Bottom */
.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 1.5rem 1rem;
  background: rgba(0, 0, 0, 0.2);
}

.footer-bottom-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.copyright {
  color: #b8c5d6;
  font-size: 0.85rem;
  margin: 0;
}

.footer-bottom-links {
  display: flex;
  gap: 1.5rem;
}

.footer-bottom-link {
  color: #b8c5d6;
  text-decoration: none;
  font-size: 0.85rem;
  transition: color 0.3s ease;
}

.footer-bottom-link:hover {
  color: #ffffff;
}

/* Responsive Design */
@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    padding: 2rem 1rem 1.5rem;
  }
  
  .footer-title {
    font-size: 1.25rem;
  }
  
  .footer-bottom-content {
    flex-direction: column;
    text-align: center;
  }
  
  .footer-bottom-links {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .footer-content {
    grid-template-columns: 1fr;
    gap: 1rem;
    padding: 1.5rem 1rem 1rem;
  }
  
  .social-links {
    justify-content: center;
  }
  
  .footer-bottom-links {
    flex-direction: column;
    gap: 0.5rem;
  }
}
</style>
