import axios from "axios";
import { ref, computed } from 'vue';

// API base URL - use environment variable or fallback to localhost
const API_BASE_URL = process.env.VUE_APP_API_URL || 'http://localhost:8080';

// Reactive token state
const token = ref(localStorage.getItem('token') || null);

// Computed property for token presence
const isTokenPresent = computed(() => !!token.value);

// Function to set token
function setToken(newToken) {
  token.value = newToken;
  if (newToken) {
    localStorage.setItem('token', newToken);
  } else {
    localStorage.removeItem('token');
  }
}

function logout() {
  setToken(null);
  location.reload();
}

async function safeRequest(url, method, data) {
  try {
    await verify();
    const response = await axios({
      method,
      url: `${API_BASE_URL}/${url}`,
      data,
      headers: {
        'Authorization': `Bearer ${token.value}`
      }
    });
    return response;
  } catch (error) {
    if (error.response && error.response.status === 401) {
      logout();
    }
    throw error;
  }
}

async function verify() {
  if (!token.value) {
    throw new Error('No token available');
  }
  
  try {
    const response = await axios.get(`${API_BASE_URL}/verify`, {
      headers: {
        Authorization: `Bearer ${token.value}`
      }
    });
    return response.data;
  } catch (error) {
    if (error.response && error.response.status === 401) {
      setToken(null);
      throw new Error('Token expired or invalid');
    }
    throw error;
  }
}

// Function to login and set token
function login(newToken) {
  setToken(newToken);
}

// Unauthenticated API calls for login/register
async function unauthenticatedRequest(url, method, data) {
  const response = await axios({
    method,
    url: `${API_BASE_URL}/${url}`,
    data,
    headers: {
      'Content-Type': 'application/json'
    }
  });
  return response;
}

export {
  isTokenPresent,
  token,
  login,
  logout,
  verify,
  safeRequest,
  setToken,
  unauthenticatedRequest
}

