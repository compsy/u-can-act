var id_a = null;
var timestamp_a = null;
var id_b = null;
var timestamp_b = null;
var id_c = null;
var timestamp_c = null;

function toggle_otherwise_field() {
  if ($(this).closest('.row').find('.otherwise-option').is(':checked')) {
    if ($(this).closest('.row').find("input[type=text].otherwise").prop('disabled')) {
      $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', false).focus();
    }
  } else {
    $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', true);
  }
}

function time_element() {
  var curid = $(this).attr('id');
  if (curid !== id_c) {
    id_a = id_b;
    timestamp_a = timestamp_b;
    id_b = id_c;
    timestamp_b = timestamp_c;
    id_c = curid;
    timestamp_c = new Date().getTime();
    if (timestamp_a !== null && id_b !== null) {
      var duration = timestamp_b - timestamp_a;
      if (document.domain.indexOf('vsvproject.herokuapp.com') !== -1) {
        ga('send', 'timing', 'Time to answer question', id_b, duration);
      } else {
        console.log('send', 'timing', 'Time to answer question', id_b, duration);
      }
    }
  } else {
    timestamp_c = new Date().getTime();
  }
}

$(function () {
  timestamp_c = new Date().getTime();
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
  $('input').change(time_element);
  $('button[type=submit]').click(time_element);
});
