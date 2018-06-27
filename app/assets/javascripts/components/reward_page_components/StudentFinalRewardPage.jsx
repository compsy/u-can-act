class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          Heel erg bedankt voor je inzet voor dit onderzoek!
        </p>
        <p className='flow-text'>
          In totaal heb je €{this.props.earnedEuros} verdiend.
          We zullen dit bedrag overmaken op IBAN nummer: {this.props.iban}.
          <br/>
          Klopt dit nummer niet?
          Klik <a href="/person/edit">hier</a> om het aan te passen.
        </p>
        <p className='flow-text'>
          Hartelijke groeten van het u-can-act team.
        </p>
        <p className='flow-text'>
          Je kan deze pagina veilig sluiten.
        </p>
      </div>
    )
  }
}
