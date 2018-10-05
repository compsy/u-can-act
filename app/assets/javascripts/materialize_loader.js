$(function() {
  // Initialize collapsible (uncomment the lines below if you use the dropdown variation)
  // var collapsibleElem = document.querySelector('.collapsible');
  // var collapsibleInstance = M.Collapsible.init(collapsibleElem, options);

  // Or with jQuery

  // Enable ranges - the thumb element does not show when this is deleted
  var array_of_dom_elements = document.querySelectorAll("input[type=range]");
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
  $('.datepicker').datepicker({
    minDate: $(this).data('min'),
    maxDate: $(this).data('max'),
    format: 'yyyy-mm-dd',
    i18n: {
      months: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
      monthsShort: ['jan', 'feb', 'maa', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec'],
      weekdays: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
      weekdaysShort: ['zo', 'ma', 'di', 'wo', 'do', 'vr', 'za'],
      weekdaysAbbrev: ['z', 'm', 'd', 'w', 'd', 'v', 'z'],
      clear: 'Wissen',
      cancel: 'Annuleren',
      close: 'Ok'
    }
  });
});
