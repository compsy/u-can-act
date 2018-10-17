import React from 'react'
import {render} from 'enzyme'
import RewardMessage from 'components/reward_page_components/RewardMessage'

let wrapper = null;

describe('RewardMessage', () => {
  beforeEach(() => {
    wrapper = render(<RewardMessage euroDelta='123'/>);
  });

  it("should render the correct reward text", () => {
    const expected = "Je hebt hiermee €123,- verdiend."
    expect(wrapper.text()).toEqual(expected);
  });

  it("it should be contained in the correct classes", () => {
    expect(wrapper.hasClass('section')).toBeTruthy();
    expect(wrapper.children().first().hasClass('flow-text')).toBeTruthy();
  });
});
