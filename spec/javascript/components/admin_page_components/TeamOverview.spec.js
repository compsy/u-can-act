import React from 'react'
import { shallow, mount } from 'enzyme'
import TeamOverview from 'admin_page_components/TeamOverview'

describe('TeamOverview', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallow(<TeamOverview />)
  })

  describe('constructor', () => {
    it('it should set the default state', () => {
      const expectedState = {
        Mentor: undefined,
        Student: undefined,
        groups: ['Mentor', 'Student'],
        year: new Date().getFullYear(),
        week_number: undefined
      }
      expect(wrapper.instance().state).toEqual(expectedState)
    })
  })

  /*
  describe('updateTeamDetails', () => {
    it("it should call the loadTeamData function for each group", () => {
      const spy = jest.spyOn(TeamOverview.prototype, 'loadTeamData');
      wrapper = shallow(<TeamOverview/>);

      // Note that we do not have to call the update team details ourselves. It gets called in
      // the component did mount function, which is tested elsewhere
      expect(TeamOverview.prototype.loadTeamData).toHaveBeenCalledTimes(wrapper.instance().state.groups.length);

      const groups = ['1', '2', '3', '4'];
      const expected_count = groups.length + wrapper.instance().state.groups.length;
      wrapper.instance().setState({
        groups: groups
      });
      wrapper.update();

      wrapper.instance().updateTeamDetails();
      expect(TeamOverview.prototype.loadTeamData).toHaveBeenCalledTimes(expected_count);
      spy.mockRestore();
    });
  });
  */

  describe('componentDidMount', () => {
    it('it should call the updateTeamDetails function', () => {
      const spy = jest.spyOn(TeamOverview.prototype, 'updateTeamDetails')
      wrapper = shallow(<TeamOverview />)
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalled()
      spy.mockRestore()
    })
  })

  /*
  describe('isDone', () => {
    it("it should return true if there are no more future measurements", () => {
      wrapper.instance().setState({
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
      wrapper.update();
      const result = wrapper.instance().isDone();
      expect(result).toBeTruthy();
    });

    it("it should return false if there are future measurements", () => {
      wrapper.instance().setState({
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
      wrapper.update();
      const result = wrapper.instance().isDone();
      expect(result).toBeFalsy();
    });
  });
  */

  describe('setHeader', () => {
    it('it should dest the xhr request header for authorization', () => {
      localStorage.removeItem('id_token')
      const xhr = { setRequestHeader: jest.fn() }
      wrapper.instance().setHeader(xhr)
      expect(xhr.setRequestHeader).toHaveBeenCalledWith('Authorization', 'Bearer null')
    })

    it('it should use the authorization token from the  ', () => {
      const id_token = '1234abc'
      localStorage.setItem('id_token', id_token)
      const xhr = { setRequestHeader: jest.fn() }
      wrapper.instance().setHeader(xhr)
      expect(xhr.setRequestHeader).toHaveBeenCalledWith('Authorization', `Bearer ${id_token}`)
    })
  })

  describe('loadTeamData', () => {
    const group = 'Mentor'
    const year = new Date().getFullYear()
    let expectedUrl = `/api/v1/admin/team/${group}?year=${year}&percentage_threshold=70`
    const theFakeResponse = {
      'text': 'this a a fake response'
    }

    it('it should include the correct attributes in a call', () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.type).toEqual('GET')
        expect(e.dataType).toEqual('json')
        return $.Deferred().resolve(theFakeResponse).promise()
      })
      wrapper.instance().loadTeamData(group)
      expect($.ajax).toHaveBeenCalled()
      spy.mockRestore()
    })

    it('it should get the json ajax function with the correct route', () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.url).toEqual(expectedUrl)
        return $.Deferred().resolve(theFakeResponse).promise()
      })

      const spy2 = jest.spyOn(wrapper.instance(), 'handleSuccess')
      wrapper.instance().loadTeamData(group)
      expect(wrapper.instance().handleSuccess).toHaveBeenCalledWith(theFakeResponse, group)
      expect($.ajax).toHaveBeenCalled()
      spy.mockRestore()
      spy2.mockRestore()
    })

    /*
    it("it should call ajax function with the correct route with the correct week", () => {
      let week_number = 42;
      wrapper.instance().setState({
        week_number: week_number
      });
      wrapper.update();
      expectedUrl = `/api/v1/admin/team/${group}?year=${year}&week_number=${week_number}&percentage_threshold=70`;
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      const spy2 = jest.spyOn(wrapper.instance(), 'handleSuccess');
      wrapper.instance().loadTeamData(group);
      expect(wrapper.instance().handleSuccess).toHaveBeenCalledWith(theFakeResponse, group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
      spy2.mockRestore();
    });

    it("it should include the correct headers", () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.beforeSend).toEqual(TeamOverview.prototype.setHeader);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      wrapper.instance().loadTeamData(group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
    });
    */
  })

  describe('handleYearChange', () => {
    it('should call the update team details function', () => {
      const spy = jest.spyOn(TeamOverview.prototype, 'updateTeamDetails')
      wrapper = shallow(<TeamOverview />)
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalledTimes(1)
      wrapper.instance().handleYearChange('the-year')
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalledTimes(2)
      spy.mockRestore()
    })

    it('should update the state with the new week', () => {
      wrapper.instance().handleYearChange('the-year')
      expect(wrapper.instance().state.year).toEqual('the-year')
    })
  })

  describe('handleWeekChange', () => {
    it('should call the update team details function', () => {
      const spy = jest.spyOn(TeamOverview.prototype, 'updateTeamDetails')
      wrapper = shallow(<TeamOverview />)
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalledTimes(1)
      wrapper.instance().handleWeekChange('week_number')
      expect(TeamOverview.prototype.updateTeamDetails).toHaveBeenCalledTimes(2)
      spy.mockRestore()
    })

    it('should update the state with the new week', () => {
      wrapper.instance().handleWeekChange('the-week')
      expect(wrapper.instance().state.week_number).toEqual('the-week')
    })
  })

  /*
  describe('render', () => {
    it("it should render when there is data to render", () => {
      wrapper = mount(<TeamOverview/>);
      wrapper.instance().setState({
        Mentor: {
          overview: []
        },
        Student: {
          overview: []
        }
      });
      wrapper.update();
      const nodes = wrapper.find('.team-overview-entry');

      // One for mentors, one for students
      expect(nodes).not.toBeUndefined();
      expect(nodes).toHaveLength(2);
    });
    it("it should not render when there is no data", () => {
      wrapper = mount(<TeamOverview/>);
      wrapper.update();

      const nodes = wrapper.find('.team-overview-entry');
      expect(nodes).toHaveLength(0);
    });
  });
  */
})

