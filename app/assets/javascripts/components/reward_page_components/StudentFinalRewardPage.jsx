class StudentFinalRewardPage extends React.Component {
  render() {
    return (
      <div>
        <h4>{I18n.t('pages.student_final_reward_page.header')}</h4>
        <I18nRaw t='pages.student_final_reward_page.body.top' />
        {this.render_reward()}
        <I18nRaw t='pages.student_final_reward_page.body.bottom' />
        <RewardFooter person={this.props.person}/>
      </div>
    )
  }
  render_reward() {
    if (this.props.earnedEuros > 0) {
      return(
         <p className='flow-text'>
          In totaal heb je {printAsMoney(this.props.earnedEuros)} verdiend.
        </p>
      )
    }
  }
}
