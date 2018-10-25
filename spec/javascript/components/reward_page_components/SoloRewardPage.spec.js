import React from 'react'
import {shallow} from 'enzyme'
import SoloRewardPage from 'components/reward_page_components/SoloRewardPage'

describe('SoloRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<SoloRewardPage />);
  });
  
  it("it should return the correct text", () => {
    const expected = 'Uw gegevens zijn opgeslagen. Hartelijk dank voor uw deelname aan het evaluatieonderzoek!';
    expect(wrapper.childAt(0).text()).toEqual(expected);
  });
});
