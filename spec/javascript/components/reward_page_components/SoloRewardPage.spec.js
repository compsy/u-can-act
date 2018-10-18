import React from 'react'
import {shallow} from 'enzyme'
import SoloRewardPage from 'components/reward_page_components/SoloRewardPage'

describe('SoloRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<SoloRewardPage />)
  });
  
  it("it should return the correct text", () => {
    expect(wrapper.childAt(0).text()).toEqual(expected)
  });
});
