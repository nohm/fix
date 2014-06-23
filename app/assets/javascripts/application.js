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

//= require framework
//= require init
//= require_self
//= require_tree

app.init();

$(document).on('ready page:load', function () {
	// Headroom.js
	$(".navbar").headroom({
  		"tolerance": 0,
  		"offset": 0,
  		"classes": {
    		"initial": "animated",
    		"pinned": "slideDown",
    		"unpinned": "slideUp"
  		}
	});
  // Chosen.js
  $.each($('select'), function(key, value) {
    $('#' + value.id).chosen({});
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

$(document).keypress(function (e) {
  if (e.which == 13 && e.target.nodeName != "TEXTAREA") return false;
});
