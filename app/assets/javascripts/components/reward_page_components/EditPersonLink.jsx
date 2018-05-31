class EditPersonLink extends React.Component {
  constructor(props) {
    super(props);
    //this.timer = null;
    this.timer = null;
  }

  decorate_link(url, text, person) {
    if (person === undefined || person.iban !== null) {
      return (<a href={url}>{text}</a>)
    }

    this.timer = setInterval(this.performTimerEvent.bind(this), 2000)
    return (
      <a href={url} className="tooltipped" data-position="botton" data-tooltip="Vul je bankrekeningnummer in om geld te verdienen!">
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

    return(<div>{link_to_render}</div>)
  }
}
