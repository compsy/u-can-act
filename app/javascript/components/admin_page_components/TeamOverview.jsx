import React from 'react';
import WeekDropdownMenu from './WeekDropdownMenu';
import TeamOverviewEntry from './TeamOverviewEntry';
import YearDropdownMenu from './YearDropdownMenu';

export default class TeamOverview extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      Mentor: undefined,
      Student: undefined,
      groups: [ 'Mentor', 'Student' ],
      year: new Date().getFullYear(),
      week_number: undefined
    };
  }

  updateTeamDetails() {
    this.state.groups.forEach((x) => {
      this.loadTeamData(x);
    });
  }

  componentDidMount() {
    this.updateTeamDetails();
  }


  isDone() {
    return !this.state.result.protocol_completion.some((entry) => {
      return entry.future;
    });
  }

  setHeader(xhr) {
    xhr.setRequestHeader('Authorization', `Bearer ${localStorage.getItem('id_token')}`);
  }

  loadTeamData(group) {
    const self = this;

    // Only update if the subscription id has changed
    let year = `?year=${this.state.year}`;
    let week_number = this.state.week_number === undefined ? '' : `&week_number=${this.state.week_number}`;
    let percentageThreshold = '&percentage_threshold=70';

    let url = `/api/v1/admin/team/${group}${year}${week_number}${percentageThreshold}`;

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
      self.handleSuccess(response, group);
    });
  }

  handleSuccess(response, group) {
    this.setState({
      [group]: response
    });
  }

  handleYearChange(option) {
    this.setState({
      year: option
    });
    this.updateTeamDetails();
  }

  handleWeekChange(option) {
    this.setState({
      week_number: option
    });
    this.updateTeamDetails();
  }

  render() {
    let ready = true;
    this.state.groups.forEach((group) => {
      if (!this.state[group]) {
        ready = false;
      }
    });
    if (!ready) {
      return <div>
        <div className='progress'>
          <div className='indeterminate' />
        </div>
      </div>;
    }
    return (
      <div>
        <div className='container'>
          <h3> Team overview </h3>
          <div className='col s12'>
            <div className='col s4'>
              <WeekDropdownMenu year={this.state.year}
                onChange={this.handleWeekChange.bind(this)} />
            </div>
            <div className='col s8'>
              <YearDropdownMenu value={this.state.year} onChange={this.handleYearChange.bind(this)} />
            </div>
          </div>
          <div className='col s12'>
            <div className='row'>
              <div className='col s12'>
                <TeamOverviewEntry overview={this.state.Mentor.overview} name='Mentors' />
                <TeamOverviewEntry overview={this.state.Student.overview} name='Students' />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
