import React from 'react'
import {shallow, mount} from 'enzyme'
import Statistics from 'admin_page_components/Statistics';

describe('Statistics', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<Statistics/>);
  });

  describe('constructor', () => {
    it("it should set the default state", () => {
      const expectedState = {
        result: undefined,
      };
      expect(wrapper.instance().state).toEqual(expectedState);
    });
  });

  describe('setHeader', () => {
    it("it should set the correct header on the xhr request", () => {
      const xhr = {setRequestHeader: jest.fn()};
      const id_token = '1234abc';
      localStorage.setItem('id_token', id_token);
      wrapper.instance().setHeader(xhr);
      expect(xhr.setRequestHeader).toHaveBeenCalled();
      expect(xhr.setRequestHeader).toHaveBeenCalledWith("Authorization", `Bearer ${id_token}`);
    });
  });

  describe('updateStatistics', () => {
    let expectedUrl = `/api/v1/statistics`;
    const theFakeResponse = {
      'text': 'this a a fake response'
    };

    it("it should include the correct attributes in a call", () => {
      jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.type).toEqual('GET');
        expect(e.dataType).toEqual('json');
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      wrapper.instance().updateStatistics();
      expect($.ajax).toHaveBeenCalled();
    });

    it("it should get the json ajax function with the correct route", () => {
      jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      jest.spyOn(wrapper.instance(), 'handleSuccess');
      wrapper.instance().updateStatistics();
      expect(wrapper.instance().handleSuccess).toHaveBeenCalledWith(theFakeResponse);
      expect($.ajax).toHaveBeenCalled();
    });

    it("it should include the correct headers", () => {
      jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.beforeSend).toEqual(Statistics.prototype.setHeader);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      wrapper.instance().updateStatistics();
      expect($.ajax).toHaveBeenCalled();
    });
  });

  describe('handleSuccess', () => {
    it("should update the state", () => {
      const response = 'the response';
      const pre_state = wrapper.instance().state;
      expect(pre_state.result).not.toEqual(response);

      wrapper.instance().handleSuccess(response);

      const post_state = wrapper.instance().state;
      expect(post_state.result).toEqual(response);
    });
  });

  /*
  describe('render', () => {
    it("it should render when there is data to render", () => {
      wrapper = mount(<Statistics/>);
      wrapper.instance().setState({
        result: {
          number_of_students: 12,
          number_of_mentors: 3,
          duration_of_project_in_weeks: 43,
          number_of_completed_questionnaires: 4,
          number_of_book_signups: 3
        }
      });

      const nodes = wrapper.find('.statistics-entry');
      expect(nodes.exists()).toBeTruthy();

      // 5 because students, mentors, timeline, questionnaires, and book signups
      expect(nodes).toHaveLength(5);
    });

    it("it should not render when there is no data", () => {
      wrapper.instance().setState({
        result: undefined
      });
      wrapper.update();
      const nodes = wrapper.find('.progress');

      expect(nodes.exists()).toBeTruthy();
      expect(nodes).toHaveLength(1);
      expect(nodes.first().hasClass('progress')).toBeTruthy();
    });
  });
  */
});
