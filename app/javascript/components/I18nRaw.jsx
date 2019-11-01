import React from 'react';
import I18n from 'i18n';

export default class I18nRaw extends React.Component {
  render() {
    return (
      <div dangerouslySetInnerHTML={{ __html: I18n.t(this.props.t) }} />
    );
  }
}
