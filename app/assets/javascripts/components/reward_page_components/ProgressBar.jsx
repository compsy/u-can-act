class ProgressBar extends React.Component {

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    new RadialProgressChart('.progressRadial', {
      diameter: 200,
      max: totalAvailable,
      round: true,
      series: [
        {labelStart: '\u2605', value: percentageStreak, color: '#079975'},
        {labelStart: '€', value: valueEuro, color: '#243a76'},
      ],
      center: {
        content: [ 'Je hebt nu',
          function(value) {
          return '€'+value
        }, ' daar kan nog €'+(awardable) + ' bij!'],
        y: -50
      }
    });
  }

  render() {
    this.renderGraph(this.props.valueEuro, this.props.percentageStreak, this.props.awardableEuro, this.props.totalAvailable)
    return (
      <div className='row'>
        <div className='col m6 push-m3'>
          <div className="progressRadial" />
        </div>
      </div>
    )
  }
}

