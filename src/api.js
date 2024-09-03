import axios from "axios";

const isTokenPresent = !!localStorage.getItem('token')

function logout() {
  localStorage.removeItem('token');
  location.reload();
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

export {
  isTokenPresent,
  logout,
  verify
}