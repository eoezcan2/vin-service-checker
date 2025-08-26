<script setup>
import {isTokenPresent, logout} from '@/api';

</script>

<template>
    <nav class="navbar navbar-expand-lg fixed-top px-2 app-navbar">
      <div class="container-fluid">
        <router-link class="navbar-brand text-light" to="/">Service Checker</router-link>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon custom-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarText">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <router-link class="nav-link" to="/about">Über uns</router-link>
            </li>
          </ul>
          <span class="navbar-text d-flex align-items-center">
            <router-link class="btn custom-login text-light" to="/login" v-if="!isTokenPresent">Login</router-link>
            <span v-else class="d-flex align-items-center">
              <router-link class="me-3 text-light text-decoration-none" to="/account" >
                Fahrzeuge
              </router-link>
              <a class="btn btn-logout text-light" href="#" @click="logout">Ausloggen</a>
            </span>
          </span>
        </div>
      </div>
    </nav>
</template>

<style scoped>
/* app navbar base: gradient, rounded bottom, subtle shadow */
.app-navbar {
  background: linear-gradient(90deg, #0d6efd 0%, #0b5ed7 60%, #0a58ca 100%);
  box-shadow: 0 8px 30px rgba(11,94,215,0.12);
  border-bottom-left-radius: 12px;
  border-bottom-right-radius: 12px;
  padding: 0.5rem 1rem;
  transition: transform .12s ease, box-shadow .12s ease;
  z-index: 1030;
}

/* brand */
.navbar-brand {
  font-weight: 700;
  letter-spacing: 0.6px;
  color: #fff !important;
  font-size: 1.05rem;
}

/* nav links */
.nav-link {
  color: rgba(255,255,255,0.92) !important;
  transition: color .12s ease, transform .12s ease;
  padding: 0.4rem 0.6rem;
  border-radius: 6px;
}
.nav-link:hover {
  color: #e6f0ff !important;
  background: rgba(255,255,255,0.04);
  transform: translateY(-2px);
  text-decoration: none;
}

/* login button (when not logged in) */
.custom-login {
  background: rgba(255,255,255,0.12);
  border: 1px solid rgba(255,255,255,0.14);
  border-radius: 999px;
  padding: 0.35rem 0.8rem;
  font-weight: 600;
  box-shadow: 0 6px 18px rgba(11,94,215,0.06);
}
.custom-login:hover {
  background: rgba(255,255,255,0.18);
  transform: translateY(-2px);
}

/* logout button */
.btn-logout {
  background: linear-gradient(90deg,#ff5f6d,#ff3f4a);
  border: none;
  border-radius: 999px;
  padding: 0.35rem 0.75rem;
  font-weight: 600;
  box-shadow: 0 6px 18px rgba(255,63,74,0.12);
}
.btn-logout:hover {
  filter: brightness(0.97);
  transform: translateY(-2px);
}

/* avatar styling */
.avatar-img {
  border-radius: 50%;
  border: 2px solid rgba(255,255,255,0.28);
  box-shadow: 0 6px 18px rgba(0,0,0,0.12);
  display: inline-block;
  vertical-align: middle;
}

/* custom toggler icon for better contrast */
.custom-toggler-icon {
  width: 1.8rem;
  height: 1.2rem;
  background-size: 1.2rem 1.2rem;
  background-repeat: no-repeat;
  background-position: center;
  background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'><path stroke='rgba(255,255,255,0.95)' stroke-width='2' stroke-linecap='round' d='M4 7h22M4 15h22M4 23h22'/></svg>");
}

/* mobile: make collapsed area readable and nicely padded */
@media (max-width: 991px) {
  .navbar-collapse {
    background: linear-gradient(180deg, rgba(255,255,255,0.04), rgba(255,255,255,0.02));
    padding: 0.7rem;
    border-radius: 8px;
    margin-top: 0.5rem;
  }
  .navbar-nav {
    width: 100%;
    margin-bottom: 0.5rem;
  }
  .navbar-text {
    width: 100%;
    justify-content: flex-end;
  }
}

/* subtle lift on large screens when hovering the whole navbar */
@media (min-width: 992px) {
  .app-navbar:hover {
    transform: translateY(-3px);
  }
}
</style>