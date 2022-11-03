// Menu manipulation

// Add toggle listeners to listen for clicks.
// NOTE: use the turbo page load event "turbo:load"
//       instead of the JS page load event "DOMContentLoaded"
document.addEventListener("turbo:load", function() {
  let account = document.querySelector("#account");
  account.addEventListener("click", function(event) {
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
});
