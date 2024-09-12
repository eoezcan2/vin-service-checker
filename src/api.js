import axios from "axios";
import router from "@/router";

const isTokenPresent = !!localStorage.getItem('token')

function logout() {
  localStorage.removeItem('token');
  location.reload();
}

async function safeRequest(url, method, data) {
  await verify();
  return axios({
    method,
    url: `http://localhost:8080/${url}`,
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
  axios.get('http://localhost:8080/verify', {
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

function validateLogin() {
  if (!isTokenPresent) {
    router.push('/login')
  } else {
    console.log(localStorage.getItem('token'))
  }
}

export {
  isTokenPresent,
  logout,
  verify,
  safeRequest,
  validateLogin
}

