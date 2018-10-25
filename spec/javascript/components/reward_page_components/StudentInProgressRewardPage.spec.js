import React from 'react'
import {shallow} from 'enzyme'
import StudentInProgressRewardPage from 'components/reward_page_components/StudentInProgressRewardPage'

describe('StudentInProgressRewardPage', () => {
  let wrapper;
  let protocolCompletion;

  beforeEach(() => {
    protocolCompletion = [{
      "completed": true,
      "periodical": false,
      "reward_points": 0,
      "future": false,
      "streak": -1
    }, {
      "completed": true,
      "periodical": false,
      "reward_points": 0,
      "future": false,
      "streak": 0
    }, {
      "completed": true,
      "periodical": false,
      "reward_points": 0,
      "future": true,
      "streak": 1
    }, {
      "completed": true,
      "periodical": false,
      "reward_points": 0,
      "future": false,
      "streak": 0
    }, {
      "completed": true,
      "periodical": false,
      "reward_points": 0,
      "future": true,
      "streak": 1
    }];

    wrapper = shallow(<StudentInProgressRewardPage earnedEuros={0} awardable={0} maxStreak={10}
                                                   protocolCompletion={protocolCompletion}
                                                   initialMultiplier={0} currentMultiplier={0}
                                                   euroDelta={0}/>);
  });

  describe('findCurrentStreak', () => {
    it("it should return 0 if there are only future measurements", () => {
      protocolCompletion = [{
        "future": true,
        "streak": 1
      }, {
        "future": true,
        "streak": 2
      }, {
        "future": true,
        "streak": 3
      }, {
        "future": true,
        "streak": 4
      }, {
        "future": true,
        "streak": 5
      }];

      const result = wrapper.instance().findCurrentStreak(protocolCompletion, 10);
      expect(result).toEqual(0);
    });

    it("it should the streak of the first elem before a future one", () => {
      protocolCompletion = [{
        "future": false,
        "streak": 1
      }, {
        "future": false,
        "streak": 2
      }, {
        "future": true,
        "streak": 3
      }, {
        "future": true,
        "streak": 4
      }, {
        "future": true,
        "streak": 5
      }];

      const result = wrapper.instance().findCurrentStreak(protocolCompletion, 10);
      expect(result).toEqual(protocolCompletion[1].streak);
    });

    it("it should return a value that should never exceed the max possible value", () => {
      protocolCompletion = [{
        "future": false,
        "streak": 1000
      }, {
        "future": false,
        "streak": 2000
      }, {
        "future": true,
        "streak": 3000
      }, {
        "future": true,
        "streak": 4000
      }, {
        "future": true,
        "streak": 5000
      }];

      const result = wrapper.instance().findCurrentStreak(protocolCompletion, 10);
      expect(result).toEqual(10);
    });

    it("it should never return a value < 0", () => {
      protocolCompletion = [{
        "future": false,
        "streak": -1000
      }, {
        "future": false,
        "streak": -2000
      }, {
        "future": true,
        "streak": -3000
      }, {
        "future": true,
        "streak": -4000
      }, {
        "future": true,
        "streak": -5000
      }];

      const result = wrapper.instance().findCurrentStreak(protocolCompletion, -10);
      expect(result).toEqual(0);
    });
  });
});
