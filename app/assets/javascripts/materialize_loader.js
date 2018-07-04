$(function(){
  $('select').material_select();
  Materialize.updateTextFields();
  $('.datepicker').each(function(index) {
    $(this).pickadate({
      formatSubmit: 'yyyy-mm-dd',
      hiddenName: true,
      monthsFull: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
      monthsShort: ['jan', 'feb', 'maa', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec'],
      weekdaysFull: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
      weekdaysShort: ['zo', 'ma', 'di', 'wo', 'do', 'vr', 'za'],
      weekdaysLetter: ['z', 'm', 'd', 'w', 'd', 'v', 'z'],
      min: $(this).data('min'),
      max: $(this).data('max'),
      today: 'Vandaag',
      clear: 'Wissen',
      close: 'Ok'
    });
  });
});
