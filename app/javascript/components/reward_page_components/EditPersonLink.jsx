import React from 'react';
import I18n from '../../../../public/javascripts/i18n';

export default class EditPersonLink extends React.Component {
  constructor(props) {
    super(props);
    this.timer = null;
    this.addEmphasis = false;
  }

  decorateLink(url, text, person) {
    const delay = 2000;
    if (!this.addEmphasis || (person === undefined || person.iban !== null)) {
      return <a href={url}>{text}</a>;
    }

    this.timer = setInterval(this.performTimerEvent.bind(this), delay);
    return (
      <a href={url} className='tooltipped'
        data-position='bottom'
        data-tooltip={I18n.t('pages.reward.iban_needed_tooltip')}>
        {text}
      </a>
    );
  }

  performTimerEvent() {
    $('.tooltipped').tooltip().trigger('mouseenter.tooltip');
    clearInterval(this.timer);
  }

  render() {
    const linkToRender = this.decorateLink('/person/edit', I18n.t('pages.reward.edit_person'), this.props.person);

    return <div>{linkToRender}</div>;
  }
}
