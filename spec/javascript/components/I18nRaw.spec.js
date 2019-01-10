import React from 'react'
import {mount} from 'enzyme'
import I18nRaw from 'I18nRaw'

describe('I18nRaw', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = mount(<I18nRaw t='activerecord.attributes.person.first_name'/>);
  });

  it("renders the correct text", () => {
    const expected = "Voornaam";
    expect(wrapper.text()).toEqual(expected);
  });

  it("is contained in a div", () => {
    expect(wrapper.html()).toEqual('<div>Voornaam</div>');
  });
});
