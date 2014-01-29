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
