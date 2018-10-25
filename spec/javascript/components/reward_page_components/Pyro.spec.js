import React from 'react'
import {shallow} from 'enzyme'
import Pyro from 'components/reward_page_components/Pyro'

describe('Pyro', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<Pyro />);
  });
  
  it("it should provide a scaffold for the pyro css", () => {
    expect(wrapper.childAt(0).hasClass('pyro')).toBeTruthy();
  });

  it("it should provide a scafold for the pyro css with the correct before and after divs", () => {
    expect(wrapper.childAt(0).childAt(0).hasClass('before')).toBeTruthy();
    expect(wrapper.childAt(0).childAt(1).hasClass('after')).toBeTruthy();
  });
});
