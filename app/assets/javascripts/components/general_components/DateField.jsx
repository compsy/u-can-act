class DateField extends React.Component {
  componentDidMount() {
    this.redraw();
  }

  redraw() {
    var self = this;
    var picker = $('#' + this.props.uuid);
    picker.pickadate({
      formatSubmit: 'yyyy-mm-dd',
      hiddenName: true,
      monthsFull: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
      monthsShort: ['jan', 'feb', 'maa', 'apr', 'mei', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec'],
      weekdaysFull: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
      weekdaysShort: ['zo', 'ma', 'di', 'wo', 'do', 'vr', 'za'],
      weekdaysLetter: ['z', 'm', 'd', 'w', 'd', 'v', 'z'],
      min: new Date(),
      today: 'Vandaag',
      clear: 'Wissen',
      closeOnSelect: true,
      close: 'Ok',
      onSet: function(time){
        var obj = {
          target: {
            name: self.props.name,
            value: $('#' + self.props.uuid).val()
          }
        };
        self.props.onChange(obj);
      }
    });
  }

  render() {
    return (
      <div className="input-field">
        <input id={this.props.uuid} name={this.props.name} value={this.props.value} type="text" className="datepicker" onChange={this.props.onChange}/>
        <label htmlFor={this.props.uuid}>{this.props.label}</label>
      </div>
    )
  }
}
