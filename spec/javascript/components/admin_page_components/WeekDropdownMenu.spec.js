import React from 'react'
import {shallow} from 'enzyme'
import WeekDropdownMenu from 'admin_page_components/WeekDropdownMenu';

describe('WeekDropdownMenu', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<WeekDropdownMenu/>);
  });

  describe('getMaxWeekNumber', () => {
    it("it should set the correct header on the xhr request", () => {

    });
  });

  describe('generateWeeks', () => {
    it("it should set the correct header on the xhr request", () => {
      const xhr = {setRequestHeader: jest.fn()};
      const id_token = '1234abc';
      localStorage.setItem('id_token', id_token);
      wrapper.instance().setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalled();
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });

  describe('render', () => {
    it("it should set the correct header on the xhr request", () => {
      const xhr = {setRequestHeader: jest.fn()};
      const id_token = '1234abc';
      localStorage.setItem('id_token', id_token);
      wrapper.instance().setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalled();
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });
});
