import React from 'react';
import { printAsMoney } from '../Helpers';

export default class RewardMessage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          Je hebt hiermee {printAsMoney(this.props.euroDelta)} verdiend.
          Je kunt nog {printAsMoney(this.props.awardable)} verdienen.
        </p>
      </div>
    );
  }
}
