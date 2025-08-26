<script setup>
    import VinSearch from '../vin-search.vue'
</script>

<template>
    <div class="home-container">
        <!-- Hero Section -->
        <div class="hero-section">
            <div class="hero-content">
                <div class="hero-icon">
                    <img src="/coolcar.png" alt="CoolCar" width="80" height="80" class="me-2"/>
                </div>
                <h1 class="hero-title">Finde das Servicebuch deines Fahrzeuges</h1>
                <p class="hero-subtitle">Ihre zuverlässige Lösung für die Verwaltung und Überwachung der Wartungshistorie Ihrer Fahrzeuge</p>
                <div class="search-section">
                    <VinSearch class="search-component"/>
                </div>
            </div>
        </div>

        <!-- Mission Section -->
        <div class="content-section">
            <div class="section-header">
                <h2 class="section-title">Unsere Mission</h2>
                <p class="section-subtitle">Wir machen Fahrzeugwartung einfach und transparent</p>
            </div>
            <div class="mission-content">
                <p class="mission-text">
                    Service Checker wurde entwickelt, um Fahrzeughaltern dabei zu helfen, den Überblick über ihre Wartungshistorie zu behalten. 
                    Wir glauben daran, dass regelmäßige Wartung nicht nur die Lebensdauer Ihres Fahrzeugs verlängert, sondern auch Ihre Sicherheit 
                    und den Werterhalt gewährleistet.
                </p>
            </div>
        </div>

        <!-- Features Section -->
        <div class="content-section">
            <div class="section-header">
                <h2 class="section-title">Unsere Features</h2>
                <p class="section-subtitle">Alles, was Sie für die perfekte Fahrzeugverwaltung brauchen</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🚗</div>
                    <h3 class="feature-title">Fahrzeugverwaltung</h3>
                    <p class="feature-description">Verwalten Sie alle Ihre Fahrzeuge an einem Ort mit detaillierten Informationen und VIN-Tracking.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔧</div>
                    <h3 class="feature-title">Wartungshistorie</h3>
                    <p class="feature-description">Behalten Sie den Überblick über alle Wartungsarbeiten, Ölwechsel und Reparaturen.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">💰</div>
                    <h3 class="feature-title">Kostenverfolgung</h3>
                    <p class="feature-description">Verfolgen Sie alle Ausgaben für Wartung und Reparaturen für bessere Budgetplanung.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">📅</div>
                    <h3 class="feature-title">Wartungserinnerungen</h3>
                    <p class="feature-description">Erhalten Sie rechtzeitige Erinnerungen für anstehende Wartungsarbeiten.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">📊</div>
                    <h3 class="feature-title">Detaillierte Berichte</h3>
                    <p class="feature-description">Generieren Sie umfassende Berichte über die Wartungshistorie Ihrer Fahrzeuge.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3 class="feature-title">Sichere Daten</h3>
                    <p class="feature-description">Ihre Daten sind sicher und werden mit modernster Verschlüsselung geschützt.</p>
                </div>
            </div>
        </div>

        <!-- Technology Section -->
        <div class="content-section">
            <div class="section-header">
                <h2 class="section-title">Technologie</h2>
                <p class="section-subtitle">Moderne Technologien für beste Performance</p>
            </div>
            <div class="tech-grid">
                <div class="tech-item">
                    <span class="tech-icon"><img src="/logo.png" alt="Vue.js" width="30" height="30" class="me-2"/></span>
                    <span class="tech-name">Vue.js</span>
                </div>
                <div class="tech-item">
                    <span class="tech-icon"><img src="/bootstrap.png" alt="Bootstrap" width="30" height="30" class="me-2"/></span>
                    <span class="tech-name">Bootstrap</span>
                </div>
                <div class="tech-item">
                    <span class="tech-icon"><img src="/springboot.png" alt="Spring Boot" width="30" height="30" class="me-2"/></span>
                    <span class="tech-name">Spring Boot</span>
                </div>
                <div class="tech-item">
                    <span class="tech-icon"><img src="/nodejs.png" alt="Node.js" width="30" height="30" class="me-2"/></span>
                    <span class="tech-name">Node.js</span>
                </div>
            </div>
        </div>


    </div>
</template>

<style scoped>
/* Container */
.home-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
}

/* Hero Section */
.hero-section {
    text-align: center;
    padding: 4rem 2rem;
    background: linear-gradient(135deg, #ffffff, #f8f9fa);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(13, 110, 253, 0.08);
    margin-bottom: 3rem;
}

.hero-content {
    max-width: 800px;
    margin: 0 auto;
}

.hero-icon {
    margin-bottom: 1.5rem;
}

.hero-title {
    color: #212529;
    font-weight: 700;
    font-size: 3rem;
    margin-bottom: 1rem;
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.hero-subtitle {
    color: #6c757d;
    font-size: 1.2rem;
    line-height: 1.6;
    margin-bottom: 2rem;
}

.search-section {
    margin-top: 2rem;
}

.search-component {
    max-width: 100%;
    margin: 0 auto;
}

/* Content Sections */
.content-section {
    margin-bottom: 4rem;
}

.section-header {
    text-align: center;
    margin-bottom: 3rem;
}

.section-title {
    color: #212529;
    font-weight: 700;
    font-size: 2.5rem;
    margin-bottom: 0.5rem;
    background: linear-gradient(135deg, #0d6efd, #0b5ed7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.section-subtitle {
    color: #6c757d;
    font-size: 1.1rem;
    margin: 0;
}

/* Mission Section */
.mission-content {
    background: #ffffff;
    border-radius: 16px;
    padding: 2rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
}

.mission-text {
    color: #495057;
    font-size: 1.1rem;
    line-height: 1.7;
    margin: 0;
    text-align: center;
}

/* Features Grid */
.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
}

.feature-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 2rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
    text-align: center;
    transition: all 0.3s ease;
}

.feature-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
}

.feature-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
}

.feature-title {
    color: #212529;
    font-weight: 600;
    font-size: 1.25rem;
    margin-bottom: 1rem;
}

.feature-description {
    color: #6c757d;
    line-height: 1.6;
    margin: 0;
}

/* Technology Grid */
.tech-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
}

.tech-item {
    background: #ffffff;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(0, 0, 0, 0.08);
    text-align: center;
    transition: all 0.3s ease;
}

.tech-item:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

.tech-icon {
    font-size: 2rem;
    display: block;
    margin-bottom: 0.5rem;
}

.tech-name {
    color: #212529;
    font-weight: 600;
    font-size: 1rem;
}



/* Responsive Design */
@media (max-width: 768px) {
    .home-container {
        padding: 1rem 0.5rem;
    }
    
    .hero-section {
        padding: 2rem 1rem;
    }
    
    .hero-title {
        font-size: 2rem;
    }
    
    .section-title {
        font-size: 2rem;
    }
    
    .features-grid {
        grid-template-columns: 1fr;
    }
    
    .tech-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 480px) {
    .hero-title {
        font-size: 1.75rem;
    }
    
    .section-title {
        font-size: 1.75rem;
    }
    
    .tech-grid {
        grid-template-columns: 1fr;
    }
    
    .feature-card {
        padding: 1.5rem;
    }
}
</style>