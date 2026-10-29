var ANSWER_BACKUP_PREFIX = 'answer_backup_';

function answerBackupStorage() {
  try {
    return window.sessionStorage;
  } catch (_error) {
    return null;
  }
}

function answerBackupKey() {
  var responseId = $('form input[name=response_id]').val();
  return responseId ? ANSWER_BACKUP_PREFIX + responseId : null;
}

function answerBackupFields() {
  return $('form').find('input,textarea,select').filter(function () {
    return this.name && ['hidden', 'submit', 'button', 'file'].indexOf(this.type) === -1;
  });
}

function saveAnswerBackup() {
  var storage = answerBackupStorage();
  var key = answerBackupKey();
  if (!storage || !key) return;

  var fields = answerBackupFields().map(function () {
    var checkable = this.type === 'radio' || this.type === 'checkbox';
    return {
      id: this.id,
      name: this.name,
      value: $(this).val(),
      checked: checkable ? this.checked : null,
      touched: $(this).closest('.notchanged').length === 0
    };
  }).get();
  var expansions = {};
  $('.expand_expandable').each(function () {
    var expandableId = $(this).attr('data-belongsto');
    expansions[expandableId] = $('.expandable_wrapper:not(.hidden).' + expandableId).length;
  });
  try {
    storage.setItem(key, JSON.stringify({ fields: fields, expansions: expansions }));
  } catch (_error) {
    return;
  }
}

function findAnswerBackupField(field) {
  var $element = field.id ? $(document.getElementById(field.id)) : $();
  if ($element.length) return $element;
  return answerBackupFields().filter(function () {
    return this.name === field.name && (field.checked === null || this.value === field.value);
  }).first();
}

function restoreAnswerExpansions(expansions) {
  Object.keys(expansions || {}).forEach(function (expandableId) {
    var $button = $(document.getElementById(expandableId + '_expand'));
    var open = $('.expandable_wrapper:not(.hidden).' + expandableId).length;
    for (; $button.length && open < expansions[expandableId]; open++) expandExpandable.call($button[0]);
  });
}

function removeAnswerBackups(keep) {
  var storage = answerBackupStorage();
  if (!storage) return;

  Object.keys(storage).forEach(function (storedKey) {
    if (storedKey.indexOf(ANSWER_BACKUP_PREFIX) === 0 && storedKey !== keep) storage.removeItem(storedKey);
  });
}

function resetAnswerTimings() {
  id_a = id_b = id_c = null;
  timestamp_a = timestamp_b = null;
  timestamp_c = new Date().getTime();
  $('form input[type=hidden][id$=_timing]').remove();
}

function restoreAnswerBackup() {
  var storage = answerBackupStorage();
  var key = answerBackupKey();
  if (!storage || !key) return;

  removeAnswerBackups(key);

  var backup;
  try {
    backup = JSON.parse(storage.getItem(key) || '{}');
  } catch (_error) {
    return;
  }
  var fields = backup.fields || [];
  restoreAnswerExpansions(backup.expansions);
  var checkables = fields.filter(function (field) { return field.checked !== null; });
  var others = fields.filter(function (field) { return field.checked === null; });

  checkables.forEach(function (field) {
    var $element = findAnswerBackupField(field);
    if ($element.length && $element.prop('checked') !== field.checked) {
      $element.prop('checked', field.checked).trigger('change');
    }
  });
  others.forEach(function (field) {
    var $element = findAnswerBackupField(field);
    if (!$element.length) return;
    if ($element.val() !== field.value) $element.val(field.value).trigger('input').trigger('change');
    if (field.touched) $element.closest('.notchanged').removeClass('notchanged');
  });
  if (window.M && M.updateTextFields) M.updateTextFields();
  resetAnswerTimings();
}

function removeRelaunchMarker() {
  if (!window.history || !history.replaceState || !window.URLSearchParams) return;

  var params = new URLSearchParams(window.location.search);
  if (!params.has('relaunched')) return;

  params.delete('relaunched');
  var query = params.toString();
  history.replaceState(history.state, '', window.location.pathname + (query ? '?' + query : '') + window.location.hash);
}

$(function () {
  removeRelaunchMarker();
  if (!answerBackupKey()) return;

  setTimeout(function () {
    restoreAnswerBackup();
    $(document).on('input change', 'form input, form textarea, form select', saveAnswerBackup);
    $(document).on('submit', 'form', saveAnswerBackup);
  }, 0);
});
