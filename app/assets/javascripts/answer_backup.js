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
    return { id: this.id, name: this.name, value: $(this).val(), checked: checkable ? this.checked : null };
  }).get();
  try {
    storage.setItem(key, JSON.stringify(fields));
  } catch (_error) {
    return;
  }
}

function findAnswerBackupField(field) {
  if (field.id) return $(document.getElementById(field.id));
  return answerBackupFields().filter(function () {
    return this.name === field.name && (field.checked === null || this.value === field.value);
  }).first();
}

function restoreAnswerBackup() {
  var storage = answerBackupStorage();
  var key = answerBackupKey();
  if (!storage || !key) return;

  Object.keys(storage).forEach(function (storedKey) {
    if (storedKey.indexOf(ANSWER_BACKUP_PREFIX) === 0 && storedKey !== key) storage.removeItem(storedKey);
  });

  var fields;
  try {
    fields = JSON.parse(storage.getItem(key) || '[]');
  } catch (_error) {
    return;
  }
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
    if ($element.length && $element.val() !== field.value) {
      $element.val(field.value).trigger('input').trigger('change');
    }
  });
  if (window.M && M.updateTextFields) M.updateTextFields();
}

$(function () {
  if (!answerBackupKey()) return;

  setTimeout(function () {
    restoreAnswerBackup();
    $(document).on('input change', 'form input, form textarea, form select', saveAnswerBackup);
    $(document).on('submit', 'form', saveAnswerBackup);
  }, 0);
});
