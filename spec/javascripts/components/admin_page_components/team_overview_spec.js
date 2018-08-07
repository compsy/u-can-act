describe("TeamOverview", function() {
  beforeEach(function() {
    var component = React.createElement(TeamOverview, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("constructor", function() {});

  describe("updateTeamDetails", function() {

  });

  describe("componentDidMount", function() {

  });

  describe("isDone", function() {

  });

  describe("setHeader", function() {
    it("it should dest the xhr request header for authorization", function() {
      localStorage.removeItem('id_token')
      var xhr = jasmine.createSpyObj('xhr', ['setRequestHeader']);
      this.rendered.setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", "Bearer null");
    });

    it("it should use the authorization token from the  ", function() {
      var id_token = '1234abc';
      localStorage.setItem('id_token', id_token)
      var xhr = jasmine.createSpyObj('xhr', ['setRequestHeader']);
      this.rendered.setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });

  describe('loadTeamData', function() {

  });

  describe("handleYearChange", function() {
    it("should call the update team details function", function() {
      spyOn(TeamOverview.prototype, 'updateTeamDetails')

      var component = React.createElement(TeamOverview, { });
      var rendered = TestUtils.renderIntoDocument(component);
      rendered.handleYearChange('the-year');
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalled();
    });

    it("should update the state with the new week", function() {
      this.rendered.handleYearChange('the-year');
      expect(this.rendered.state.year).toEqual('the-year');
    });
  });

  describe("handleWeekChange", function() {
    it("should call the update team details function", function() {
      spyOn(TeamOverview.prototype, 'updateTeamDetails')

      var component = React.createElement(TeamOverview, { });
      var rendered = TestUtils.renderIntoDocument(component);

      rendered.handleWeekChange('week_number');
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalled();
    });

    it("should update the state with the new week", function() {
      this.rendered.handleWeekChange('the-week');
      expect(this.rendered.state.week_number).toEqual('the-week');
    });
  });

  describe("renderOverview", function() {
    it("it should render when there is data to render", function() {
      var component = React.createElement(TeamOverview, { });
      var rendered = TestUtils.renderIntoDocument(component)
      rendered.setState({Mentor: {overview: []}, Student: {overview:[]}});

      var nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'team-overview-entry')

      // One for mentors, one for students
      expect(nodes).not.toBe(undefined)
      expect(nodes.length).toBe(2)
    });
    it("it should not render when there is no data", function() {
      var component = React.createElement(TeamOverview, { });
      var rendered = TestUtils.renderIntoDocument(component)

      // Helper to find all elements in a page, can be useful for reference:
      //var node = TestUtils.findAllInRenderedTree(rendered, function(a) {return true})
      var nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'team-overview-entry')

      expect(nodes).toEqual(jasmine.any(Array));
      expect(nodes.length).toBe(0)
    });

  });

  describe("render", function() {

  });

});
