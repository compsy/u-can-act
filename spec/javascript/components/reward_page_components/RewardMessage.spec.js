import React from 'react'
import ReactDOM from 'react-dom'
import {render} from 'enzyme'
import HelloMessage from 'components/reward_page_components/RewardMessage'

let wrapper = null;

describe("RewardMessage", () => {
  beforeEach(() => {
    wrapper = render(<HelloMessage euroDelta='123'/>);
  });

  it("should render the correct reward text", () => {
    const expected = "Je hebt hiermee €123,- verdiend."
    expect(wrapper.text()).toEqual(expected);
  });

  it("it should be contained in the correct classes", () => {
    var elem = ReactDOM.findDOMNode(wrapper)
    var outer_result = elem.getAttribute('class')
    expect(outer_result).toEqual('section');

    var inner_result = elem.children[0].getAttribute('class')
    expect(inner_result).toEqual('flow-text');
  });
});
