import React from 'react'
import {shallow} from 'enzyme'
import ProgressText from 'reward_page_components/ProgressText'
import { printAsMoney } from 'Helpers'

describe('ProgressText', () => {
  let wrapper;
  let protocolCompletion;
  let awardable;

  beforeEach(() => {
    awardable = 10;
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
    wrapper = shallow(<ProgressText protocolCompletion={protocolCompletion} awardable={awardable}/>);
  });

  describe('calculateProgess', () => {
    it("it should should return the rounded total percentage of non-future entries", () => {
      const result = wrapper.instance().calculateProgess(protocolCompletion);
      // (3/5*100)
      expect(result).toEqual(Math.round(3 / 5 * 100));
    });

    it("it should return 0 if there are only future measurements", () => {
      protocolCompletion = [{
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }];

      const result = wrapper.instance().calculateProgess(protocolCompletion);
      // (3/5*100)
      expect(result).toEqual(0);
    });
  });

  describe('render', () => {
    it("it should display a rendered message", () => {
      const expected = `Het onderzoek is voor 60% voltooid. Er zijn nog ${printAsMoney(awardable)} te verdienen.`;
      const result = wrapper.childAt(0).text();
      expect(result).toEqual(expected);
    });
  });
});
