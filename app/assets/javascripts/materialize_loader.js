var datepickerI18nNl = {
  months: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
  monthsShort: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
  weekdays: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
  weekdaysShort: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
  weekdaysAbbrev: ['z', 'm', 'd', 'w', 'd', 'v', 'z'],
  clear: 'Wissen',
  cancel: 'Annuleren',
  done: 'Ok'
};

var datepickerI18nFi = {
  months: ['tammikuu', 'helmikuu', 'maaliskuu', 'huhtikuu', 'toukokuu', 'kesäkuu', 'heinäkuu', 'elokuu', 'syyskuu', 'lokakuu', 'marraskuu', 'joulukuu'],
  monthsShort: ['tammi', 'helmi', 'maalis', 'huhti', 'touko', 'kesä', 'heinä', 'elo', 'syys', 'loka', 'marras', 'joulu'],
  weekdays: ['sunnuntai', 'maanantai', 'tiistai', 'keskiviikko', 'torstai', 'perjantai', 'lauantai'],
  weekdaysShort: ['su', 'ma', 'ti', 'ke', 'to', 'pe', 'la'],
  weekdaysAbbrev: ['S', 'M', 'T', 'K', 'T', 'P', 'L'],
  clear: 'Tyhjennä',
  cancel: 'Peruuta',
  done: 'OK'
};

var datepickerI18nDe = {
  months: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'],
  monthsShort: ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'],
  weekdays: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'],
  weekdaysShort: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
  weekdaysAbbrev: ['S', 'M', 'D', 'M', 'D', 'F', 'S'],
  clear: 'Löschen',
  cancel: 'Abbrechen',
  done: 'OK'
};

var datepickerI18nEs = {
  months: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'],
  monthsShort: ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'],
  weekdays: ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'],
  weekdaysShort: ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sáb'],
  weekdaysAbbrev: ['D', 'L', 'M', 'X', 'J', 'V', 'S'],
  clear: 'Borrar',
  cancel: 'Cancelar',
  done: 'Aceptar'
};

var datepickerI18nPt = {
  months: ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
  monthsShort: ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'],
  weekdays: ['domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado'],
  weekdaysShort: ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sáb'],
  weekdaysAbbrev: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
  clear: 'Limpar',
  cancel: 'Cancelar',
  done: 'OK'
};

var datepickerI18n = { fi: datepickerI18nFi, de: datepickerI18nDe, es: datepickerI18nEs, pt: datepickerI18nPt };

$(function() {
  // Initialize collapsible (uncomment the lines below if you use the dropdown variation)
  // var collapsibleElem = document.querySelector('.collapsible');
  // var collapsibleInstance = M.Collapsible.init(collapsibleElem, options);

  // Or with jQuery

  // Enable ranges - the thumb element does not show when this is deleted
  var array_of_dom_elements = $("input[type=range]").not(".affective-slider input");
  M.Range.init(array_of_dom_elements);

  // Enable the sidenav
  $('.sidenav').sidenav();

  // Enable materialize selects (can test in the organization overview)
  $('select').formSelect();

  // Floats the button on the admin dashboard - small screen
  $('.fixed-action-btn').floatingActionButton();

  // Enable collapsible fields (used in the export)
  $('.collapsible').collapsible();

  // Enable materialize textfields
  M.updateTextFields();

  // Fix textareas causing a horizontal scrollbar
  $(window).resize(function() {
    var hiddenDiv = $('.hiddendiv').first();
    if (hiddenDiv.length) {
      hiddenDiv.css('width', window.innerWidth / 2 + 'px');
    }
  });

  // Enable datepickers
  $('.datepicker').each(function() {
    var self = this;
    var default_date = null;
    if ($(self).data('default-date'))
      default_date = new Date(Date.parse($(self).data('default-date')));
    // The Dutch texts are used for nl (and when no locale is given). en and locales without their own texts get the
    // English defaults of materialize.
    var locale = $(self).data('locale');
    var i18n = datepickerI18n[locale] || {};
    if (!locale || locale === 'nl') i18n = datepickerI18nNl;
    $(self).datepicker({
      firstDay: 1,
      minDate: new Date(Date.parse($(self).data('min'))),
      maxDate: new Date(Date.parse($(self).data('max'))),
      defaultDate: default_date,                         // This is so we can set a default date already filled out,
      setDefaultDate: $(self).data('set-default-date'),  // allowing the user to skip the input
      format: 'yyyy-mm-dd',
      i18n: i18n
    });
  });
});
