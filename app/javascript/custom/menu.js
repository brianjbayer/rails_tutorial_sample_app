// Menu manipulation

// Adds a toggle listener
function addToggleClickListener(
  clicked_selector,
  toggled_selector,
  toggle_class) {
  let selected_element = document.querySelector(clicked_selector);
  selected_element.addEventListener("click", function (event) {
    event.preventDefault();
    let listened_element = document.querySelector(toggled_selector);
    listened_element.classList.toggle(toggle_class);
  });
}

// Add toggle listeners to listen for clicks
document.addEventListener("turbo:load", function() {
  addToggleClickListener("#hamburger", "#navbar-menu", "collapse");
  addToggleClickListener("#account", "#dropdown-menu", "active");
});
