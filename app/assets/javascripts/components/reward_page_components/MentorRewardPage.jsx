class MentorRewardPage extends React.Component {
  render() {
    return (
      <div>
        <div className='section'>
          <p className='flow-text'>
            Heel erg bedankt voor je inzet voor dit onderzoek!
          </p>
          <p className='flow-text'>
            Hartelijke groeten van het u-can-act team.
          </p>
          <p className='flow-text'>
            Je kan deze pagina veilig sluiten.
          </p>
        </div>
        <RewardFooter person={this.props.person}/>
      </div>
    )
  }
}
