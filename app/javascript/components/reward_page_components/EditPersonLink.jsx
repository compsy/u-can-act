import React from 'react'

export default class EditPersonLink extends React.Component {
  constructor(props) {
    super(props);
    this.timer = null;
    this.add_emphasis = true;
  }

  decorate_link(url, text, person) {
    if (!this.add_emphasis || (person === undefined || person.iban !== null)) {
      return (<a href={url}>{text}</a>)
    }

    this.timer = setInterval(this.performTimerEvent.bind(this), 2000)
    return (
      <a href={url} className="tooltipped" data-position="bottom" data-tooltip="We hebben je bankrekeningnummer nodig om je beloning naar je te kunnen overmaken.">
        {text}
      </a>
    )
  }

  performTimerEvent() {
    $('.tooltipped').tooltip();
    $('.tooltipped').trigger("mouseenter.tooltip")
    clearInterval(this.timer);
  }

  render() {
    const link_to_render = this.decorate_link('/person/edit', 'Gegevens aanpassen', this.props.person)

    return (<div>{link_to_render}</div>)
  }
}
