class WarningMessage extends React.Component {
  renderElements(messages) {
    messages = messages.map((message) => {
      return <li>{message}</li>
    })
    return <ul>{messages}</ul>
  }

  render() {
    if (this.props.message === undefined || !this.props.shouldShow) {
      return <div />;
    }

    return (
      <div className="card-panel red">
        <h4> Er ging iets mis: </h4>
        {this.renderElements(this.props.message)} 
      </div>
    );
  }
}

WarningMessage.defaultProps = {
  message: undefined,
  shouldShow: true
};
