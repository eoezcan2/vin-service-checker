const isTokenPresent = !!localStorage.getItem('token')

function logout() {
  localStorage.removeItem('token');
  location.reload();
}

export {
  isTokenPresent,
  logout
}