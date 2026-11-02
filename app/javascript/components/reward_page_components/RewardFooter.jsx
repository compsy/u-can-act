import React from 'react';
import EditPersonLink from './EditPersonLink';
import I18n from '../../../../public/javascripts/i18n';

export default class RewardFooter extends React.Component {
  render() {
    return (
      <ul>
        <li><a href='/disclaimer'>{I18n.t('pages.reward.disclaimer')}</a></li>
        <li><EditPersonLink person={this.props.person} /></li>
      </ul>
    );
  }
}
