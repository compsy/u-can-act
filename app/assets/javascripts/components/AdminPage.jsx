class AdminPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      Mentor: undefined,
      Student: undefined,
      groups: ['Mentor', 'Student']
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


  render() {
    if (!this.state.Mentor || !this.state.Student) {
            console.log(this.state)
      return <div>Bezig...</div>
    }

    return ( 
      <div className="col s12">
        <div className="row">
          <div className="col s12">
            <OrganizationOverviewEntry overview={this.state.Mentor.overview} name='Mentors' />
            <OrganizationOverviewEntry overview={this.state.Mentor.overview} name='Students' />
          </div>
        </div>
      </div>
    )
  }
}
