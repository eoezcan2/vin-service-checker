<script setup>
// Simple About Us page component
</script>

<template>
    <div class="about-container">
        <!-- Simple About Section -->
        <div class="about-section">
            <div class="about-content">
                <div class="about-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
                    </svg>
                </div>
                <h1 class="about-title">Über Service Checker</h1>
                <p class="about-description">
                    Service Checker ist eine moderne Webanwendung zur Verwaltung der Wartungshistorie von Fahrzeugen. 
                    Unsere Mission ist es, Fahrzeughaltern dabei zu helfen, den Überblick über ihre Wartungsarbeiten zu behalten 
                    und die Lebensdauer ihrer Fahrzeuge zu verlängern.
                </p>
                
                <div class="about-github">
                    <h3 class="github-title">Open Source</h3>
                    <p class="github-description">
                        Service Checker ist ein Open-Source-Projekt. Der Code ist auf GitHub verfügbar.
                    </p>
                    <a href="https://github.com/eoezcan2/vin-service-checker" target="_blank" class="github-link">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                        </svg>
                        Auf GitHub ansehen
                    </a>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Container */
.about-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 2rem 1rem;
}

/* About Section */
.about-section {
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(13, 110, 253, 0.08);
    overflow: hidden;
}

.about-content {
    padding: 3rem 2rem;
    text-align: center;
}

.about-icon {
    color: #0d6efd;
    margin-bottom: 1.5rem;
}

.about-title {
    color: #212529;
    font-weight: 700;
    font-size: 2.5rem;
    margin-bottom: 1.5rem;
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.about-description {
    color: #495057;
    font-size: 1.1rem;
    line-height: 1.7;
    margin-bottom: 2rem;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
}

/* GitHub */
.about-github {
    padding: 1.5rem;
    background: linear-gradient(135deg, #24292e, #2f363d);
    border-radius: 12px;
    color: #ffffff;
}

.github-title {
    font-weight: 600;
    font-size: 1.25rem;
    margin-bottom: 0.5rem;
}

.github-description {
    color: #b8c5d6;
    margin-bottom: 1rem;
}

.github-link {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem 1.5rem;
    background: #ffffff;
    color: #24292e;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.github-link:hover {
    background: #f8f9fa;
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
    color: #24292e;
}

/* Responsive Design */
@media (max-width: 768px) {
    .about-container {
        padding: 1rem 0.5rem;
    }
    
    .about-content {
        padding: 2rem 1rem;
    }
    
    .about-title {
        font-size: 2rem;
    }
}

@media (max-width: 480px) {
    .about-title {
        font-size: 1.75rem;
    }
    
    .about-description {
        font-size: 1rem;
    }
}
</style>