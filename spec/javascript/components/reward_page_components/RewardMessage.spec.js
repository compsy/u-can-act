import React from 'react';
import { render } from 'enzyme';
import RewardMessage from 'reward_page_components/RewardMessage';
import { printAsMoney } from 'Helpers';

describe('RewardMessage', () => {
  let wrapper = {};

  beforeEach(() => {
    wrapper = render(<RewardMessage euroDelta='123' awardable='2' />);
  });

  it('should render the correct reward text', () => {
    const expected = `Je hebt hiermee ${printAsMoney(123)} verdiend. Je kunt nog €2,- verdienen.`;
    expect(wrapper.text()).toEqual(expected);
  });

  it('it should be contained in the correct classes', () => {
    expect(wrapper.hasClass('section')).toBeTruthy();
    expect(wrapper.children().first().hasClass('flow-text')).toBeTruthy();
  });
});
