import React from 'react'
require('../../../public/javascripts/i18n') // THIS GOES WRONG

export default class SoloRewardPage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className='flow-text'>
          {I18n.t('pages.klaar.header')}
        </p>
      </div>
    )
  }
}
