import React from 'react'
import {shallow} from 'enzyme'
import SoloRewardPage from 'reward_page_components/SoloRewardPage'

describe('SoloRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<SoloRewardPage />);
  });
  
  it("it should return the correct text", () => {
    const expected = 'dank';
    expect(wrapper.childAt(0).text()).toMatch(expected);
  });
});
