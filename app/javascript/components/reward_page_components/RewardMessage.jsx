import React from 'react';
import { printAsMoney } from '../Helpers';
import I18n from '../../../../public/javascripts/i18n';

export default class RewardMessage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          {I18n.t('pages.reward.earned_now', {
            earned: printAsMoney(this.props.euroDelta),
            awardable: printAsMoney(this.props.awardable)
          })}
        </p>
      </div>
    );
  }
}
