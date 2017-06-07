// This is a manifest file that'll be compiled into application.js, which will
// include all the files listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or
// any plugin's vendor/assets/javascripts directory can be referenced here using
// a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at
// the bottom of the compiled file. JavaScript code in this file should be added
// after the last require_* statement.
//
// Read Sprockets README
// (https://github.com/rails/sprockets#sprockets-directives) for details about
// supported directives.
//
//= require jquery
//= require rails-ujs
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//
//= require tether
//= require bootstrap-sprockets
//
//= require jquery.infinite-pages
//= require jquery.sparkline
//
//= require turbolinks
//= require_tree .
//
//= require_tree ../../../vendor/assets/javascripts/.
//

// Temporary fix for the unobtrusive_flash gem
$(document).on('DOMNodeInserted', function(e) {
  $('.unobtrusive-flash-container .alert.fade').addClass('show');
});

UnobtrusiveFlash.flashOptions['timeout'] = 2000; // milliseconds
