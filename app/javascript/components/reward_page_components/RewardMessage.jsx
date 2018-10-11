import React from 'react'
export default class RewardMessage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className="flow-text">Je hebt hiermee {printAsMoney(this.props.euroDelta)} verdiend.</p>
      </div>
    )
  }
}
