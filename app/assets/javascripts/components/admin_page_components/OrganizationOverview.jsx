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

  loadOrganizationData(group) {
    var self = this
    console.log('Updating!');

    // Only update if the subscription id has changed
    let url = '/api/v1/admin/organization/' + group + 
              '?year=' + this.state.year + 
              '&week_number=' + this.state.week_number;
    console.log(url);
    $.getJSON(url, (response) => {
      self.setState({
        [group] : response
      })
    });
  }

  handleYearChange(option) {
    console.log(option);
    this.setState({year: option})
    this.updateOrganizationDetails();
  }

  handleWeekChange(option) {
    console.log(option);
    this.setState({week_number: option})
    this.updateOrganizationDetails();
  }


  render() {
    var ready = true;
    this.state.groups.forEach((group) => {
      if (!this.state[group]) { ready = false; }
    })
    if (!ready) return <div>Bezig...</div>

      //%p Voor week #{Time.zone.now.to_date.cweek}
    return ( 
      <div>
        <h3> Organization overview </h3>
        <div className="col s6">
          <div className="col s3">
            <WeekDropdownMenu year= {this.state.year} onChange={this.handleWeekChange.bind(this)}/>
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
}
