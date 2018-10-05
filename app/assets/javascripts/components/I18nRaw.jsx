class I18nRaw extends React.Component {
  render() {
    return (
      <div dangerouslySetInnerHTML={{__html: I18n.t(this.props.t)}}/>
    )
  }
}
