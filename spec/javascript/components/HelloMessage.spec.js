import React from 'react'
import { shallow } from 'enzyme'
import HelloMessage from 'components/HelloMessage'

let wrapper = null;

describe("HelloMessage", () => {
  beforeEach(function() {
    wrapper = shallow(<HelloMessage euroDelta='123' />);
  });

  it("should render the correct reward text", () => {
    const expected = "Je hebt hiermee €123,- verdiend."
    expect(wrapper.text()).toEqual(expected);
  });
/*
  it("it should be contained in the correct classes", () => {
    var elem = ReactDOM.findDOMNode(this.rendered)
    var outer_result = elem.getAttribute('class')
    expect(outer_result).toEqual('section');

    var inner_result = elem.children[0].getAttribute('class') 
    expect(inner_result).toEqual('flow-text');
  });
  */
});
