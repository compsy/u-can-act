class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          Heel erg bedankt dat je meedeed aan ons onderzoek! Door jouw deelname kunnen wij onze webapp zo verbeteren
          dat deze veel beter zal aansluiten aan de wensen van toekomstige deelnemers. Zodra de gegevens bij ons
          binnen zijn ontvangt jouw S-team begeleider jouw beloning en kan jij je beloning daar dus ophalen.
        </p>
        <p className='flow-text'>
           In totaal heb je €{this.props.earnedEuros} verdiend.
        </p>
        <p className='flow-text'>
          Hartelijke groeten van het RUG onderzoeksteam:
          <br/>
          Nick Snell, Teun Blijlevens en Mandy van der Gaag
        </p>
        <p className='flow-text'>
          Je kan deze pagina veilig sluiten.
        </p>
      </div>
    )
  }
}
