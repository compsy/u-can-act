import React from 'react'
import {shallow} from 'enzyme'
import SoloRewardPage from 'reward_page_components/SoloRewardPage'

describe('SoloRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<SoloRewardPage />);
  });
  
  it("it should return the correct text", () => {
    const expected = /geregistreerd|Bedankt voor het invullen van de vragenlijst, je antwoorden zijn opgeslagen\./;
    expect(wrapper.childAt(0).text()).toMatch(expected);
  });
});
