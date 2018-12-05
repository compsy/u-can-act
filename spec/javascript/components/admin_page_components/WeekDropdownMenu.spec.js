import React from 'react'
import {mount, shallow} from 'enzyme'
import WeekDropdownMenu from 'admin_page_components/WeekDropdownMenu';

describe('WeekDropdownMenu', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<WeekDropdownMenu/>);
  });

  describe('getMaxWeekNumber', () => {
    it("it should correctly return the maximum week for certain dates", () => {
      const result = wrapper.instance().getMaxWeekNumber(new Date(2017, 11, 31));
      expect(result).toEqual([52]);
    });
  });

  describe('generateWeeks', () => {
    it("it should return an array of weeks from one to the maximum returned by getMaxWeekNumber", () => {
      const spy = jest.spyOn(wrapper.instance(), 'getMaxWeekNumber').mockImplementation(function (e) {
        return 6;
      });
      expect(wrapper.instance().generateWeeks(2017)).toEqual([1, 2, 3, 4, 5, 6]);
      spy.mockRestore();
    });
  });

  describe('render', () => {
    beforeEach(() => {
      wrapper = mount(<WeekDropdownMenu year={2017}/>);
    });

    it("renders the correct react component", () => {
      expect(wrapper.name()).toEqual('WeekDropdownMenu');
    });

    it("passes the correct class", () => {
      const node = wrapper.childAt(0);
      expect(node.name()).toEqual('Select');
      expect(node.is('.dropdown')).toBeTruthy();
    });

    it("returns the correct title", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(0);
      expect(node.name()).toEqual('select');
    });

    it("displays the correct label", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(1);
      expect(node.name()).toEqual('label');
      expect(node.text()).toEqual('Week');
    });

    it("displays the correct number of weeks", () => {
      const nodes = wrapper.find('option');
      expect(nodes.exists()).toBeTruthy();
      expect(nodes).toHaveLength(52 + 1); // Add one for the default disabled option labeled "Selecteer..."
    });
  });
});
