import React from 'react';
import {
  shallow
} from 'enzyme';
import DefaultRewardPage from 'reward_page_components/DefaultRewardPage';

describe('DefaultRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<DefaultRewardPage />);
  });

  it('it should return the correct text', () => {
    const expected = 'Uw gegevens zijn opgeslagen. Hartelijk dank voor uw deelname aan het evaluatieonderzoek!';
    expect(wrapper.childAt(0).text()).toEqual(expected);
  });
});
