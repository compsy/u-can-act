import React from 'react';

export default class StatisticsEntry extends React.Component {
  render() {
    return (
      <div className='statistics-entry col s6 m6 l6 xl3'>
        <div className='card'>
          <div className='card-content black-text'>
            <p><i className='tiny material-icons'>{this.props.icon}</i> {this.props.title}</p>
            <h4 className='card-stats-number'>{this.props.value}</h4>
            <p>
              <span className='accent-color-text'>{this.props.subtext}</span>
            </p>
          </div>
        </div>
      </div>
    );
  }
}
