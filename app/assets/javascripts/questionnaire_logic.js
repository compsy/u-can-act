function toggle_otherwise_field() {
  if ($(this).closest('.row').find('.otherwise-option').is(':checked')) {
    $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', false);
  } else {
    $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', true);
  }
}

$(function () {
  $('input[type=radio],input[type=checkbox]').change(toggle_otherwise_field);
  $('.otherwise-option').each(toggle_otherwise_field);
});
