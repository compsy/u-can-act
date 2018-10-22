describe('TeamOverview', () => {
  beforeEach(() => {
    const component = React.createElement(TeamOverview, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe('constructor', () => {
    it("it should set the default state", () => {
      const expectedState = {
        Mentor: undefined,
        Student: undefined,
        groups: ['Mentor', 'Student'],
        year: new Date().getFullYear(),
        week_number: undefined
      };
      expect(this.rendered.state).toEqual(expectedState);
    });
  });

  describe('updateTeamDetails', () => {
    it("it should call the loadTeamData function for each group", () => {
      jest.spyOn(TeamOverview.prototype, 'loadTeamData').mockImplementation(() => {})
      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component);

      // Note that we do not have to call the update team details ourselves. It gets called in 
      // the component did mount function, which is tested elsewhere
      expect(TeamOverview.prototype.loadTeamData.mock.calls.length).toEqual(rendered.state.groups.length);

      const groups = ['1', '2', '3', '4'];
      this.rendered.setState({
        groups: groups
      });

      rendered.updateTeamDetails()
      expect(TeamOverview.prototype.loadTeamData.mock.calls.length).toEqual(groups.length);
    });
  });

  describe('componentDidMount', () => {
    it("it should call the updateTeamDetails function", () => {
      jest.spyOn(TeamOverview.prototype, 'updateTeamDetails').mockImplementation(() => {})
      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component);
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalled();
    });
  });

  describe('isDone', () => {
    it("it should return true if there are no more future measurements", () => {
      this.rendered.setState({
        result: {
          protocol_completion: [{
            future: false
          }, {
            future: false
          }, {
            future: false
          }]
        }
      });
      result = this.rendered.isDone()
      expect(result).toBeTruthy();
    });

    it("it should return false if there are future measurements", () => {
      this.rendered.setState({
        result: {
          protocol_completion: [{
            future: false
          }, {
            future: false
          }, {
            future: true
          }]
        }
      });
      result = this.rendered.isDone()
      expect(result).toBeFalsy();
    });
  });

  describe('setHeader', () => {
    it("it should dest the xhr request header for authorization", () => {
      localStorage.removeItem('id_token')
      const xhr = jasmine.createSpyObj('xhr', ['setRequestHeader']);
      this.rendered.setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", "Bearer null");
    });

    it("it should use the authorization token from the  ", () => {
      const id_token = '1234abc';
      localStorage.setItem('id_token', id_token)
      const xhr = jasmine.createSpyObj('xhr', ['setRequestHeader']);
      this.rendered.setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });

  describe('loadTeamData', () => {
    const group = 'Mentor';
    const year = new Date().getFullYear();
    let expectedUrl = `/api/v1/admin/team/${group}?year=${year}&percentage_threshold=70`
    const theFakeResponse = {
      'text': 'this a a fake response'
    }

    it("it should include the correct attributes in a call", () => {
      jest.spyOn($, 'ajax').mockImplementation(function(e) {
        expect(e.type).toEqual('GET');
        expect(e.dataType).toEqual('json');
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      this.rendered.loadTeamData(group)
    });

    it("it should get the json ajax function with the correct route", () => {
      jest.spyOn($, 'ajax').mockImplementation(function(e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      jest.spyOn(this.rendered, 'handleSuccess');
      this.rendered.loadTeamData(group)
      expect(this.rendered.handleSuccess).toHaveBeenCalledWith(theFakeResponse, group);
    });

    it("it should call ajax function with the correct route with the correct week", () => {
      let week_number = 42
      this.rendered.setState({
        week_number: week_number
      });
      expectedUrl = `/api/v1/admin/team/${group}?year=${year}&week_number=${week_number}&percentage_threshold=70`
      jest.spyOn($, 'ajax').mockImplementation(function(e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      jest.spyOn(this.rendered, 'handleSuccess');
      this.rendered.loadTeamData(group)
      expect(this.rendered.handleSuccess).toHaveBeenCalledWith(theFakeResponse, group);
    });

    it("it should include the correct headers", () => {
      jest.spyOn($, 'ajax').mockImplementation(function(e) {
        expect(e.beforeSend).toEqual(TeamOverview.prototype.setHeader);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      this.rendered.loadTeamData(group)
    });
  });

  describe('handleYearChange', () => {
    it("should call the update team details function", () => {
      jest.spyOn(TeamOverview.prototype, 'updateTeamDetails').mockImplementation(() => {})

      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component);
      expect(TeamOverview.prototype.updateTeamDetails.mock.calls.length).toEqual(1);
      rendered.handleYearChange('the-year');
      expect(TeamOverview.prototype.updateTeamDetails.mock.calls.length).toEqual(2);
    });

    it("should update the state with the new week", () => {
      this.rendered.handleYearChange('the-year');
      expect(this.rendered.state.year).toEqual('the-year');
    });
  });

  describe('handleWeekChange', () => {
    it("should call the update team details function", () => {
      jest.spyOn(TeamOverview.prototype, 'updateTeamDetails').mockImplementation(() => {})

      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component);

      expect(TeamOverview.prototype.updateTeamDetails.mock.calls.length).toEqual(1);
      rendered.handleWeekChange('week_number');
      expect(TeamOverview.prototype.updateTeamDetails.mock.calls.length).toEqual(2);
    });

    it("should update the state with the new week", () => {
      this.rendered.handleWeekChange('the-week');
      expect(this.rendered.state.week_number).toEqual('the-week');
    });
  });

  describe('render', () => {
    it("it should render when there is data to render", () => {
      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component)
      rendered.setState({
        Mentor: {
          overview: []
        },
        Student: {
          overview: []
        }
      });

      const nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'team-overview-entry')

      // One for mentors, one for students
      expect(nodes).not.toBe(undefined)
      expect(nodes.length).toBe(2)
    });
    it("it should not render when there is no data", () => {
      const component = React.createElement(TeamOverview, {});
      const rendered = TestUtils.renderIntoDocument(component)

      // Helper to find all elements in a page, can be useful for reference:
      //const node = TestUtils.findAllInRenderedTree(rendered, function(a) {return true})
      const nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'team-overview-entry')

      expect(nodes).toEqual(jasmine.any(Array));
      expect(nodes.length).toBe(0)
    });

  });
});
