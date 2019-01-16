import React from 'react'
import {shallow} from 'enzyme'
import Callback from 'Callback'

describe('Callback', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<Callback/>);
  });

  it("renders the correct text", () => {
    const expected = "Loading...";
    expect(wrapper.text()).toEqual(expected);
  });

  it("contains the correct divs", () => {
    expect(wrapper.childAt(1).name()).toEqual('div');
    expect(wrapper.childAt(1).props().className).toEqual('progress');
    expect(wrapper.childAt(1).childAt(0).name()).toEqual('div');
    expect(wrapper.childAt(1).childAt(0).props().className).toEqual('indeterminate');
  });
});
