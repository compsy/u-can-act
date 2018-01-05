class OrganizationOverview extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      Mentor: undefined,
      Student: undefined,
      groups: ['Mentor', 'Student'],
      year: new Date().getFullYear()
    };
  }

  componentDidMount() {
    this.state.groups.forEach((x) => {
      this.loadOrganizationData(x);
    })
  }

  componentWillReceiveProps(nextProps) {
  }

  isDone() {
    return !this.state.result.protocol_completion.some((entry) => {
      return entry.future
    })
  }

  loadOrganizationData(group) {
    var self = this

    // Only update if the subscription id has changed
    let url = '/api/v1/admin/organization/' + group;
    $.getJSON(url, (response) => {
      self.setState({
        [group] : response
      })
    });
  }

  handleYearChange(e) {
    debugger;
    console.log(e);
  }

  handleWeekChange(e) {
    console.log(e);
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
            <WeekDropdownMenu year= {this.state.year} onChange={this.handleWeekChange}/>
          </div>
          <div className="col s9">
            <YearDropdownMenu value={this.state.year} onChange={this.handleYearChange}/>
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
