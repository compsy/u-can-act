$(function(){
  $('select').material_select();
  Materialize.updateTextFields();
  $('.download-button').click(function() { $(this).attr('disabled', true)})
});
