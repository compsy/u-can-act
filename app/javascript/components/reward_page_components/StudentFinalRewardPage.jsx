import React from 'react'
import RewardFooter from './RewardFooter'
import printAsMoney from '../printAsMoney'

export default class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div>
        <h4>Bedankt voor het invullen van de vragenlijst!</h4>
        <div className='section'>
          <p className='flow-text'>
            Heel erg bedankt voor je inzet voor dit onderzoek!
          </p>
          {this.render_reward()}
          <p className='flow-text'>
            Hartelijke groeten van het u-can-act team.
          </p>
          <p className='flow-text'>
            Je kan deze pagina veilig sluiten.
          </p>
        </div>
        <RewardFooter person={this.props.person}/>
      </div>
    );
  }
  render_reward() {
    if (this.props.earnedEuros > 0) {
      return(
         <p className='flow-text'>
          In totaal heb je {printAsMoney(this.props.earnedEuros)} verdiend.
          We zullen dit bedrag overmaken op IBAN:<br/>
          <strong>{this.props.iban}</strong> t.n.v. <strong>{this.props.name}.</strong><br/>
          Klopt dit nummer niet?
          Klik <a href="/person/edit">hier</a> om het aan te passen.
        </p>
      );
    }
  }
}
