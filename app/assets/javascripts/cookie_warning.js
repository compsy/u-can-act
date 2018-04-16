$(document).ready(function() {
  var cookies_enabled = navigator.cookieEnabled;
  if (!cookies_enabled) {
    $('.cookie-warning').show()
  }
})
