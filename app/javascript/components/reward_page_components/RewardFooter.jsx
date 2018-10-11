import React from 'react'
import EditPersonLink from './EditPersonLink'

export default class RewardFooter extends React.Component {
  render() {
    return (
      <ul>
        <li><a href='/disclaimer'>Disclaimer</a></li>
        <li><EditPersonLink person={this.props.person}/></li>
      </ul>
    )
  }
}
