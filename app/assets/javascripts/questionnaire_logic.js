function toggle_otherwise_field() {
  if ($(this).closest('.row').find('.otherwise-option').is(':checked')) {
    if ($(this).closest('.row').find("input[type=text].otherwise").prop('disabled')) {
      $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', false).focus();
    }
  } else {
    $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', true);
  }
}

$(function () {
  $('input[type=radio],input[type=checkbox]').change(toggle_otherwise_field);
  $('.otherwise-option').each(toggle_otherwise_field);
  $('label + div.input-field.inline').click(function () {
    if ($(this).find('input[type=text][disabled]').length) {
      $(this).prev().click();
    }
  });
  $('textarea,input[type=text]').keypress(function (event) {
    if (event.keyCode === 13) {
      event.preventDefault();
    }
  });
});
