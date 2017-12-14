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
//= require jquery
//= require jquery_ujs
//= require modernizr
//= require materialize
//= require d3
//= require react
//= require react_ujs
//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/heatmap
//= require highcharts/modules/exporting
//= require highcharts/modules/data
//= require highcharts/modules/boost-canvas
//= require highcharts/modules/boost
//= require radial-progess-chart
//= require study_progress_bar
//= require components
//= require_tree .
$(function(){
  $('.download-button').click(function() { $(this).attr('disabled', true)})
});

printAsMoney = function(euroValue) {
  euroValue = parseFloat(Math.round(euroValue * 100) / 100).toFixed(2);
  euroValue = euroValue.toString();
  euroValue = euroValue.replace('.',',');
  euroValue = euroValue.replace(',00',',-');
  euroValue = '€' + euroValue;
  return(euroValue);
}

