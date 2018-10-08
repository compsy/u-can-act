describe("Statistics", function() {
  beforeEach(function() {
    const component = React.createElement(Statistics, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("constructor", function() {
    it("it should set the default state", function() {
      const expectedState = {
        result: undefined,
      };
      expect(this.rendered.state).toEqual(expectedState);
    });
  });

  describe("setHeader", function() {
    it("it should set the correct header on the xhr request", function() {
      xhr = jasmine.createSpyObj('xhr', ['setRequestHeader']);
      const id_token = '1234abc';
      localStorage.setItem('id_token', id_token)
      this.rendered.setHeader(xhr)
      expect(xhr.setRequestHeader).toHaveBeenCalled();
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });

  describe("updateStatistics", function() {
    const year = new Date().getFullYear();
    let expectedUrl = `/api/v1/statistics`
    const theFakeResponse = {
      'text': 'this a a fake response'
    }

    it("it should include the correct attributes in a call", function() {
      spyOn($, 'ajax').and.callFake(function(e) {
        expect(e.type).toEqual('GET');
        expect(e.dataType).toEqual('json');
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      this.rendered.updateStatistics()
    });

    it("it should get the json ajax function with the correct route", function() {
      spyOn($, 'ajax').and.callFake(function(e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      spyOn(this.rendered, 'handleSuccess').and.callThrough();
      this.rendered.updateStatistics()
      expect(this.rendered.handleSuccess).toHaveBeenCalledWith(theFakeResponse);
    });

    it("it should include the correct headers", function() {
      spyOn($, 'ajax').and.callFake(function(e) {
        expect(e.beforeSend).toEqual(Statistics.prototype.setHeader);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      this.rendered.updateStatistics()
    });
  });

  describe("handleSuccess", function() {
    it("should update the state", function() {
      const response = 'the response'
      const pre_state = this.rendered.state;
      expect(pre_state.result).not.toEqual(response);

      this.rendered.handleSuccess(response);

      const post_state = this.rendered.state;
      expect(post_state.result).toEqual(response);
    });
  });


  describe("render", function() {
    it("it should render when there is data to render", function() {
      const component = React.createElement(Statistics, {});
      const rendered = TestUtils.renderIntoDocument(component)
      rendered.setState({
        result: {
          number_of_students: 12,
          number_of_mentors: 3,
          duration_of_project_in_weeks: 43,
          number_of_completed_questionnaires: 4
        }
      });

      const nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'statistics-entry')

      expect(nodes).not.toBe(undefined)

      // 4 because students, mentors, timeline and questionnaires
      expect(nodes.length).toBe(4)
      console.log(nodes)
    });

    it("it should not render when there is no data", function() {
      const component = React.createElement(Statistics, {});
      const rendered = TestUtils.renderIntoDocument(component)
      rendered.setState({
        result: undefined
      });

      const nodes = TestUtils.scryRenderedDOMComponentsWithClass(rendered, 'progress')

      expect(nodes).not.toBe(undefined)
      expect(nodes.length).toBe(1)
      expect(nodes[0].getAttribute('class')).toEqual('progress')
    });

  });
});
