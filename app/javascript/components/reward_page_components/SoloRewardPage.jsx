import React from 'react'
import I18n from 'i18n'

export default class SoloRewardPage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          {I18n.t('pages.klaar.header')}
        </p>
      </div>
    );
  }
}
