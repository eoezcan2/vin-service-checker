import axios from "axios";

// API base URL - use environment variable or fallback to localhost
const API_BASE_URL = process.env.VUE_APP_API_URL || 'http://localhost:8080';

const isTokenPresent = !!localStorage.getItem('token')

function logout() {
  localStorage.removeItem('token');
  location.reload();
}

async function safeRequest(url, method, data) {
  await verify();
  return axios({
    method,
    url: `${API_BASE_URL}/${url}`,
    data,
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
  }).then(response => {
    console.log(response)
    return response;
  }).catch(error => {
    if (error.response.status === 401) {
      logout();
    }
    return error.response;
  });
}

async function verify() {
  if (!localStorage.getItem('token')) return;
  axios.get(`${API_BASE_URL}/verify`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    }
  }).then(response => {
    console.log(response)
  }).catch(error => {
    console.log(error)
    if (error) localStorage.removeItem('token');
  });
}

export {
  isTokenPresent,
  logout,
  verify,
  safeRequest
}

