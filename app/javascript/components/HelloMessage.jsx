import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

class HelloMessage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className="flow-text">Je hebt hiermee {printAsMoney(this.props.euroDelta)} verdiend.</p>
      </div>
    )
  }
}

export default HelloMessage;
