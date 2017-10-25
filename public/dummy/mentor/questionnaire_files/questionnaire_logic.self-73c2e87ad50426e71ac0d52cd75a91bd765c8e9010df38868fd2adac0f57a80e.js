var id_a = null;
var timestamp_a = null;
var id_b = null;
var timestamp_b = null;
var id_c = null;
var timestamp_c = null;
var rails_env = 'development';

function toggle_otherwise_field() {
  if ($(this).closest('.row').hasClass('hidden')) return;
  if ($(this).closest('.row').find("input[type=text].otherwise").length === 0) return;
  if ($(this).closest('.row').find('.otherwise-option').is(':checked')) {
    if ($(this).closest('.row').find("input[type=text].otherwise").prop('disabled')) {
      $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', false).focus();
    }
  } else {
    $(this).closest('.row').find("input[type=text].otherwise").prop('disabled', true);
  }
}

function toggle_shown_questions() {
  if ($(this).closest('.row').find('input[data-shows-questions]').length === 0) return;
  $(this).closest('.row').find('input[data-shows-questions]').each(function (index) {
    if ($(this).is(':checked')) {
      $(this).data('shows-questions').forEach(function (entry) {
        var klass = '.' + entry + '_toggle';
        $(klass).removeClass('hidden')
          .find('input,textarea').prop('disabled', false);
        $('.otherwise-option').each(toggle_otherwise_field);
      });
    } else {
      $(this).data('shows-questions').forEach(function (entry) {
        var klass = '.' + entry + '_toggle';
        $(klass).addClass('hidden').find('input,textarea').prop('disabled', true);
      });
    }
  });
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
    if (timestamp_a !== null && id_b !== null && id_b !== undefined) {
      var duration = timestamp_b - timestamp_a;
      if (document.domain.indexOf('vsvproject.herokuapp.com') !== -1) {
        ga('send', 'timing', 'Time to answer question', id_b, duration);
      } else {
        if (rails_env !== 'test')
          console.debug('send', 'timing', 'Time to answer question', id_b, duration);
      }
      var timingfield = id_b + '_timing';
      if ($('#'+timingfield).length > 0) {
        $('#'+timingfield).val(duration);
      } else {
        $('form').append('<input type="hidden" id="' + timingfield +
                         '" name="content[' + timingfield + ']" value="' + duration + '" />');
      }
    }
  } else {
    timestamp_c = new Date().getTime();
  }
}

function addRemoveDisabledClass(buttons, element_class) {
  let currentButton;
  let questionnaireId;
  let elem;
  buttons.each(function(button) {
    // $(this) is the button
    currentButton = $(this);
    questionnaireId = currentButton.attr('data-belongsto');
    elem = $(element_class + "." + questionnaireId).first();
    if(elem.length <= 0) {
      currentButton.addClass('disabled');
    } else {
      currentButton.removeClass('disabled');
    }
  });
}

function updateExpandableButtons() {
  buttons = $(".expand_expandable")
  addRemoveDisabledClass(buttons, '.expandable_wrapper.hidden')

  buttons = $(".collapse_expandable")
  addRemoveDisabledClass(buttons, '.expandable_wrapper:not(.hidden)')
}

function findExpandableElement(button, element) {
  const questionnaireId = $(button).attr('data-belongsto');
  // Find the first element that is hidden and expandable so we can unhide it
  const elem = $(element + "." + questionnaireId).first();
  return(elem)
}

function expandExpandable() {
  const elem = findExpandableElement(this, '.expandable_wrapper.hidden');
  elem.removeClass('hidden').find('input,textarea').prop('disabled', false);
  $('.otherwise-option').each(toggle_otherwise_field);
  updateExpandableButtons();
}

function collapseExpandable() {
  const elem = findExpandableElement(this, '.expandable_wrapper:not(.hidden)');
  elem.addClass('hidden').find('input,textarea').prop('disabled', true);
  $('.otherwise-option').each(toggle_otherwise_field);
  updateExpandableButtons();
}

function disableHiddenInputs() {
  $('.hidden').each(function(index) {
    $(this).find('input,textarea').each(function(sub_index){
      $(this).prop('disabled', true);
    });
  });
}

$(function () {
  timestamp_c = new Date().getTime();
  $('input[type=radio],input[type=checkbox]').change(toggle_shown_questions).change(toggle_otherwise_field);
  $('input[type=radio][data-shows-questions],input[type=checkbox][data-shows-questions]').each(toggle_shown_questions);
  $('.otherwise-option').each(toggle_otherwise_field);
  $('label + div.input-field.inline').click(function () {
    if ($(this).find('input[type=text][disabled]').length) {
      $(this).prev().click();
    }
  });
  $('textarea,input[type=text]').keypress(function (event) {
    if (event.keyCode === 13) {
      event.preventDefault();
      $(this).blur();
    }
  });
  $('input,textarea').change(time_element);
  $('textarea').focusin(time_element);
  $('button[type=submit]').click(time_element);

  $('.expand_expandable').on('click', expandExpandable);
  $('.collapse_expandable').on('click', collapseExpandable);
  updateExpandableButtons();
  disableHiddenInputs();
});



