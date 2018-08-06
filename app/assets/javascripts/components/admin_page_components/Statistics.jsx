class Statistics extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      resuld: undefined
    };
  }


  componentDidMount() {
    this.updateStatistics();
  }

  setHeader(xhr) {
    xhr.setRequestHeader('Authorization', 'Bearer ' + localStorage.getItem('id_token'));
  }

  updateStatistics() {
    var self = this
    let url = '/api/v1/statistics'

    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      success: (response) => {
        self.setState({
          result: response
        })
      },
      error: function() {
        console.log('Error, call failed!');
      },
      beforeSend: self.setHeader
    });
  }

  render() {
    if (!this.state.result) {
      return (<div><div className="progress"><div className="indeterminate"></div></div></div>)
    }

    return (
      <div>
      <h4>General statistics</h4>
      <StatisticsEntry icon='school' title='Students' value={this.state.result.number_of_students} subtext='At-risk and control' />
      <StatisticsEntry icon='people' title='Mentors' value={this.state.result.number_of_mentors} subtext='Across all agencies' />
      <StatisticsEntry icon='timelapse' title='Timeline' value={this.state.result.duration_of_project_in_weeks} subtext='Weeks' />
      <StatisticsEntry icon='assignment' title='Questionnaires' value={this.state.result.number_of_completed_questionnaires} subtext='Completed' />
      </div>
    )
  }
}
