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

