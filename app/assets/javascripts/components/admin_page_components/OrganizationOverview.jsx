class OrganizationOverview extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      Mentor: undefined,
      Student: undefined,
      groups: ['Mentor', 'Student'],
      year: new Date().getFullYear(),
      week_number: 1
    };
  }

  updateOrganizationDetails() {
    this.state.groups.forEach((x) => {
      this.loadOrganizationData(x);
    })
  }

  componentDidMount() {
    this.updateOrganizationDetails();
  }


  isDone() {
    return !this.state.result.protocol_completion.some((entry) => {
      return entry.future
    })
  }

  setHeader(xhr) {
    xhr.setRequestHeader('Authorization', 'Bearer ' + localStorage.getItem('id_token'));
  }

  loadOrganizationData(group) {
    var self = this

    // Only update if the subscription id has changed
    let url = '/api/v1/admin/organization/' + group +
      '?year=' + this.state.year +
      '&week_number=' + this.state.week_number;

    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      success: (response) => {
        self.setState({
          [group]: response
        })
      },
      error: function() {
        console.log('Error, call failed!');
      },
      beforeSend: self.setHeader
    });
  }

  handleYearChange(option) {
    this.setState({
      year: option
    })
    this.updateOrganizationDetails();
  }

  handleWeekChange(option) {
    this.setState({
      week_number: option
    })
    this.updateOrganizationDetails();
  }

  renderOverview(render) {
    if (!render) return (<div />)
    return (
      <div>
      <h3> Organization overview </h3>
      <div className="col s6">
        <div className="col s3">
          <WeekDropdownMenu value={this.state.week_numer} year= {this.state.year} onChange={this.handleWeekChange.bind(this)}/>
        </div>
        <div className="col s9">
          <YearDropdownMenu value={this.state.year} onChange={this.handleYearChange.bind(this)}/>
        </div>
      </div>
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            <OrganizationOverviewEntry overview={this.state.Mentor.overview} name='Mentors' />
            <OrganizationOverviewEntry overview={this.state.Student.overview} name='Students' />
          </div>
        </div>
      </div>
      </div>
    )
  }


  render() {
    var ready = true;
    this.state.groups.forEach((group) => {
      if (!this.state[group]) {
        ready = false;
      }
    })
    if (!ready) return <div>Bezig...</div>

    //%p Voor week #{Time.zone.now.to_date.cweek}
    //
    return (
      <div>
        {this.renderOverview(true)}
      </div>
    )
  }
}
