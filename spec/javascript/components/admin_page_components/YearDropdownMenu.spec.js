import React from 'react'
import {mount, shallow} from 'enzyme'
import YearDropdownMenu from 'admin_page_components/YearDropdownMenu';

describe('YearDropdownMenu', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<YearDropdownMenu/>);
  });

  describe('generateYears', () => {
    it("it should return an array of years from 2017 to the current year", () => {
      // Fix a year to use in specs
      const constantDate = new Date('2018-06-13T04:41:20');

      /*eslint no-global-assign:off*/
      Date = class extends Date {
        constructor() {
          return constantDate;
        }
      };

      expect(wrapper.instance().generateYears()).toEqual([2017, 2018]);
    });
  });

  describe('render', () => {
    beforeEach(() => {
      // Fix a year to use in specs
      const constantDate = new Date('2018-06-13T04:41:20');

      /*eslint no-global-assign:off*/
      Date = class extends Date {
        constructor() {
          return constantDate;
        }
      };
      wrapper = mount(<YearDropdownMenu value={2017} onchange={jest.fn()}/>);
    });

    it("renders the correct react component", () => {
      expect(wrapper.name()).toEqual('YearDropdownMenu');
    });

    it("passes the correct class", () => {
      const node = wrapper.childAt(0);
      expect(node.name()).toEqual('Select');
    });

    it("returns the correct title", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('select');
    });

    it("displays the correct label", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(1);
      expect(node.name()).toEqual('label');
      expect(node.text()).toEqual('Year');
    });

    it("displays the correct number of years", () => {
      const nodes = wrapper.find('option');
      expect(nodes.exists()).toBeTruthy();
      expect(nodes).toHaveLength(2 + 1); // Add one for the default disabled option labeled "Selecteer..."
    });
  });
});
