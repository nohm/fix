// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap/modal
//= require bootstrap/alert
//= require bootstrap/button
//= require bootstrap/collapse
//= require bootstrap/transition
//= require highcharts/highcharts
//= require turbolinks
//= require modernizr
//= require headroom
//= require jQuery.headroom

$(document).on('ready page:load', function () {
	// Animated autohide navbar
	$(".navbar").headroom({
  		"tolerance": 0,
  		"offset": 0,
  		"classes": {
    		"initial": "animated",
    		"pinned": "slideDown",
    		"unpinned": "slideUp"
  		}
	});
});

// Adds a loading spinner
function addLoadingSpinner() {
  $('#main').append($('<div></div>').addClass('loading-spinner'));
}

// Disables a broadcast
function disableBroadcast(path) {
  $.ajax({url: path});
}

// Adds checkboxes to a form
function addCheckboxes(label) {
  var inputs = $(".form-group");
  for (var i = 1; i < inputs.length; i++) {
    var input = inputs[i];
    try {
      var which_input = input.children[1].children[0].id;
      if (which_input != "") {
        input.innerHTML = input.innerHTML + '<div class="checkbox col-sm-2 batch-update"><label for="' + which_input + '_enable"><input name="entry[enable][' + which_input + ']" value="0" type="hidden"><input id="' + which_input + '_enable" name="entry[enable][' + which_input + ']" value="1" type="checkbox"> ' + label + '</label></div>';
      } else {
        var which_input_checkbox = input.children[1].children[0].children[0].htmlFor;
        input.innerHTML = input.innerHTML + '<div class="checkbox col-sm-2 batch-update"><label for="' + which_input_checkbox + '_enable"><input name="entry[enable][' + which_input_checkbox + ']" value="0" type="hidden"><input id="' + which_input_checkbox + '_enable" name="entry[enable][' + which_input_checkbox + ']" value="1" type="checkbox"> ' + label + '</label></div>';
      }
    }
    catch(e) {
      // Don't do anything with errors as I know how bad this is, it still works properly
    }
  }
}
