// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require modernizr
//= require history
//= require auth0
//= # require activestorage
//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/exporting
//= require highcharts/modules/heatmap
//= require highcharts/modules/data
//= require highcharts/modules/boost-canvas
//= require highcharts/modules/boost
//= require study_progress_bar
//= require rails-ujs
//= # materialize-sprockets is from the materialize-sass gem.
//= require materialize-sprockets
//= require sketch
//= require_tree .

const switchLanguage = function () {
  // Check the data-locale attribute from the current element.
  // If it is 'nl' then change it to 'en' and vice versa.
  var newLocale = $(this).data('locale') === 'nl' ? 'en' : 'nl';

  // Use the URL and URLSearchParams interfaces to handle the URL and its parameters.
  var currentUrl = new URL(window.location.href);
  var params = new URLSearchParams(currentUrl.search);

  // Set the new locale parameter.
  params.set('locale', newLocale);

  // Update the URL with the new query parameters.
  currentUrl.search = params.toString();

  // Redirect to the new URL.
  window.location.assign(currentUrl.toString());
};

$(function(){
  $('.download-button').click(function() { $(this).attr('disabled', true)})
  $('#language-switch').click(switchLanguage);
});

printAsMoney = function(euroValue) {
  euroValue = parseFloat(Math.round(euroValue * 100) / 100).toFixed(2);
  euroValue = euroValue.toString();
  euroValue = euroValue.replace('.',',');
  euroValue = euroValue.replace(',00',',-');
  euroValue = '€' + euroValue;
  return(euroValue);
};
