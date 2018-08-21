class Message extends React.Component {
  render() {
    if (!this.props.shouldShow) {
      return <div />;
    }
    return (
      <div className="card-panel green">
        <span className="white-text">{this.props.message} </span>
      </div>
    );
  }
}
Message.defaultProps = {
  message: undefined,
  shouldShow: false
};
