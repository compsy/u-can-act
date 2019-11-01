import React from 'react';

import {
  shallow
} from 'enzyme';
import DefaultRewardPage from 'reward_page_components/DefaultRewardPage';


jest.mock('i18n', () => {
  return {
    t: (val) => {
      return val;
    }
  };
});

describe('DefaultRewardPage', () => {
  let wrapper = {};

  beforeEach(() => {
    wrapper = shallow(<DefaultRewardPage />);
  });

  it('it should return the correct text', () => {
    expect(wrapper.childAt(0).text()).toEqual('pages.klaar.header');
  });
});
