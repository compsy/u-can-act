class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div>
        <h4>{I18n.t('pages.student_final_reward_page.header')}</h4>
        <I18nRaw t='pages.student_final_reward_page.body' />
        <RewardFooter person={this.props.person}/>
      </div>
    )
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
      )
    }
  }
}
