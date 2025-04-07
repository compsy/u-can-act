import React from 'react'
import { mount, shallow } from 'enzyme'
import RewardPage from 'RewardPage'

describe('RewardPage', () => {
  let wrapper, spy

  beforeEach(() => {
    // Fix a year to use in specs
    const constantDate = new Date('2018-06-13T04:41:20')

    // eslint no-global-assign:off
    Date = class extends Date {
      constructor () {
        super()
        return constantDate
      }
    }

    spy = jest.spyOn($, 'getJSON').mockImplementation(function (e, ff) {
      return ff(undefined)
    })
    wrapper = shallow(<RewardPage protocolSubscriptionId={5} />)
  })

  afterEach(() => {
    spy.mockRestore()
  })
  /*
    describe('isDone', () => {
      it("returns true when there are no future entries", () => {
        wrapper.instance().setState({
          result: {
            protocol_completion: [{future: false}],
            max_streak: {
              threshold: 3
            }
          },
          person: jest.fn(),
        });
        wrapper.update();
        expect(wrapper.instance().isDone()).toBeTruthy();
      });
      it("returns false when there are future entries", () => {
        wrapper.instance().setState({
          result: {
            protocol_completion: [{future: false}, {future: true}],
            max_streak: {
              threshold: 3
            }
          },
          person: jest.fn(),
        });
        wrapper.update();
        expect(wrapper.instance().isDone()).toBeFalsy();
      });
    });
  */
  describe('loadCurrentPerson', () => {
    it('it should include the correct attributes in a call', () => {
      const theFakeResponse = {
        'text': 'this a a fake response'
      }
      let spy2 = jest.spyOn($, 'getJSON').mockImplementation(function (e, ff) {
        return ff(theFakeResponse)
      })
      wrapper.instance().loadCurrentPerson()
      expect($.getJSON).toHaveBeenCalledTimes(3)
      expect($.getJSON).toHaveBeenCalledWith('/api/v1/person/me', expect.anything())
      expect(wrapper.state().person).toEqual(theFakeResponse)
      spy2.mockRestore()
    })
  })

  describe('loadRewardData', () => {
    it('it should include the correct attributes in a call', () => {
      const theFakeResponse = {
        'text': 'this a a fake response'
      }
      let spy2 = jest.spyOn($, 'getJSON').mockImplementation(function (e, ff) {
        return ff(theFakeResponse)
      })
      wrapper.instance().loadRewardData(5)
      expect($.getJSON).toHaveBeenCalledTimes(3)
      expect($.getJSON).toHaveBeenCalledWith('/api/v1/protocol_subscriptions/5', expect.anything())
      expect(wrapper.state().result).toEqual(theFakeResponse)
      spy2.mockRestore()
    })
  })
  /*
  describe('render', () => {
    beforeEach(() => {
      wrapper = mount(<RewardPage protocolSubscriptionId={5}/>);
      wrapper.instance().setState({
        result: {
          protocol_completion: [{future: true}],
          max_streak: {
            threshold: 3
          }
        },
        person: jest.fn(),
      });
      wrapper.update();
    });

    it("should render bezig if there is no state", () => {
      wrapper = mount(<RewardPage protocolSubscriptionId={5}/>);
      expect(wrapper.name()).toEqual('RewardPage');
      expect(wrapper.text()).toEqual('Bezig...');
    });

    it("passes the correct class", () => {
      const node = wrapper.childAt(0);
      expect(node.name()).toEqual('div');
      expect(node.props().className).toEqual('col s12');
    });

    it("returns the correct wrappers", () => {
      const node = wrapper.childAt(0).childAt(0);
      expect(node.name()).toEqual('div');
      expect(node.props().className).toEqual('row');
    });

    it("returns the correct nested wrappers", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('div');
      expect(node.props().className).toEqual('col s12');
    });

    it("renders a MentorRewardPage for mentors", () => {
      wrapper.instance().setState({
        result: {
          protocol_completion: [{future: false}],
          max_streak: {
            threshold: 3
          },
          person_type: 'Mentor'
        },
        person: jest.fn(),
      });
      wrapper.update();
      const node = wrapper.childAt(0).childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('MentorRewardPage');
    });
    it("renders a StudentInProgressRewardPage for students in progress", () => {
      wrapper.instance().setState({
        result: {
          protocol_completion: [{future: true}],
          max_streak: {
            threshold: 3
          },
          person_type: 'Student'
        },
        person: jest.fn(),
      });
      wrapper.update();
      const node = wrapper.childAt(0).childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('StudentInProgressRewardPage');
    });
    it("renders a StudentFinalRewardPage for finished students", () => {
      wrapper.instance().setState({
        result: {
          protocol_completion: [{future: false}],
          max_streak: {
            threshold: 3
          },
          person_type: 'Student'
        },
        person: jest.fn(),
      });
      wrapper.update();
      const node = wrapper.childAt(0).childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('StudentFinalRewardPage');
    });
    it("renders a DefaultRewardPage for solo people", () => {
      wrapper.instance().setState({
        result: {
          protocol_completion: [{future: false}],
          max_streak: {
            threshold: 3
          },
          person_type: 'Solo'
        },
        person: jest.fn(),
      });
      wrapper.update();
      const node = wrapper.childAt(0).childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('DefaultRewardPage');
    });
  });
  */
})
