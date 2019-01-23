import React from 'react';

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
        data-tooltip='We hebben je bankrekeningnummer nodig om je beloning naar je te kunnen overmaken.'>
        {text}
      </a>
    );
  }

  performTimerEvent() {
    $('.tooltipped').tooltip().trigger('mouseenter.tooltip');
    clearInterval(this.timer);
  }

  render() {
    const linkToRender = this.decorateLink('/person/edit', 'Gegevens aanpassen', this.props.person);

    return <div>{linkToRender}</div>;
  }
}
