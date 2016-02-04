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
//= require turbolinks
//= require bootstrap/alert
//= require bootstrap/collapse
//= require bootstrap/dropdown
//= require bootstrap/tab
//= require_tree ../../../vendor/assets/javascripts/.
//= require_tree .

// Fix Twitter bootstrap issue with Dropdowns and turbolinks
$(document).on('page:load', function() {
  $("[data-toggle='dropdown']").each(function(element) {
    $(this).dropdown();
  });
});
