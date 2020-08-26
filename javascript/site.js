
// Without jQuery
// Define a convenience method and use it
var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

// Show an element
var show = function (elem) {
  elem.style.display = 'block';
};

// Hide an element
var hide = function (elem) {
  elem.style.display = 'none';
};

// Toggle element visibility
var toggle = function (elem) {

  // If the element is visible, hide it
  if (window.getComputedStyle(elem).display === 'block') {
    hide(elem);
    return;
  }

  // Otherwise, show it
  show(elem);

};


ready(() => { 
  //document.querySelector("#more_metadata");

  //var box = document.querySelector(".box");
//box.classList.add("focus");
//box.classList.remove("focus");

// Remove the "focus" class and add "blurred"
//document.querySelector(".box").classList.replace("focus", "blurred"); 


var to_hide = document.querySelector("#more_metadata");
hide(to_hide);


});

document.addEventListener('click', function (event) {

  // Make sure clicked element is our toggle
  if (!event.target.classList.contains('toggle')) return;

  // Prevent default link behavior
  event.preventDefault();

  // Get the content
  var content = document.querySelector(event.target.hash);
  if (!content) return;

  // Toggle the content
  toggle(content);

}, false);



