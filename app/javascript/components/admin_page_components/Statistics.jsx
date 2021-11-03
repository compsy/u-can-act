import React from 'react';
import StatisticsEntry from './StatisticsEntry';

export default class Statistics extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      result: undefined
    };
  }

  componentDidMount() {
    this.updateStatistics();
  }

  setHeader(xhr) {
    xhr.setRequestHeader('Authorization', `Bearer ${localStorage.getItem('id_token')}`);
  }

  updateStatistics() {
    const self = this;
    let url = '/api/v1/statistics';

    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      error: (_err) => {
        if (process.env.TESTING !== 'true') {
          console.log('Error, call failed!');
        }
      },
      beforeSend: self.setHeader
    }).done((response) => {
      self.handleSuccess(response);
    });
  }

  handleSuccess(response) {
    this.setState({
      result: response
    });
  }

  render() {
    if (!this.state.result) {
      return <div>
        <div className='progress'>
          <div className='indeterminate' />
        </div>
      </div>;
    }

    return (
      <div className='general-statistics'>
        <h4>General statistics</h4>
        <StatisticsEntry icon='school' title='Students' value={this.state.result.number_of_students}
          subtext='At-risk and control' />
        <StatisticsEntry icon='people' title='Mentors' value={this.state.result.number_of_mentors}
          subtext='Across all agencies' />
        <StatisticsEntry icon='timelapse' title='Timeline' value={this.state.result.duration_of_project_in_weeks}
          subtext='Weeks' />
        <StatisticsEntry icon='assignment' title='Questionnaires'
                         value={this.state.result.number_of_completed_questionnaires} subtext='Completed' />
        <StatisticsEntry icon='book' title='Book signups' optional={true}
                         value={this.state.result.number_of_book_signups} subtext='Registered' />
      </div>
    );
  }
}
