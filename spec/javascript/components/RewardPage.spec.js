import React from 'react'
import {mount, shallow} from 'enzyme'
import RewardPage from 'RewardPage';
import TeamOverview from "../../../app/javascript/components/admin_page_components/TeamOverview";

describe('RewardPage', () => {
  let wrapper;

  beforeEach(() => {
    // Fix a year to use in specs
    const constantDate = new Date('2018-06-13T04:41:20');

    /*eslint no-global-assign:off*/
    Date = class extends Date {
      constructor() {
        return constantDate;
      }
    };

    wrapper = shallow(<RewardPage protocolSubscriptionId={5}/>);
  });

  /*
  describe('getCorrectResulPage', () => {
    it("it should return an array of years from 2017 to the current year", () => {

      expect(wrapper.instance().generateYears()).toEqual([2017, 2018]);
    });
  });
  */

  /*
  describe('loadRewardData', () => {
    const group = 'Mentor';
    const year = new Date().getFullYear();
    let expectedUrl = `/api/v1/admin/team/${group}?year=${year}&percentage_threshold=70`;
    const theFakeResponse = {
      'text': 'this a a fake response'
    };

    it("it should include the correct attributes in a call", () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.type).toEqual('GET');
        expect(e.dataType).toEqual('json');
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      wrapper.instance().loadTeamData(group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
    });

    it("it should get the json ajax function with the correct route", () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      const spy2 = jest.spyOn(wrapper.instance(), 'handleSuccess');
      wrapper.instance().loadTeamData(group);
      expect(wrapper.instance().handleSuccess).toHaveBeenCalledWith(theFakeResponse, group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
      spy2.mockRestore();
    });

    it("it should call ajax function with the correct route with the correct week", () => {
      let week_number = 42;
      wrapper.instance().setState({
        week_number: week_number
      });
      wrapper.update();
      expectedUrl = `/api/v1/admin/team/${group}?year=${year}&week_number=${week_number}&percentage_threshold=70`;
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.url).toEqual(expectedUrl);
        return $.Deferred().resolve(theFakeResponse).promise();
      });

      const spy2 = jest.spyOn(wrapper.instance(), 'handleSuccess');
      wrapper.instance().loadTeamData(group);
      expect(wrapper.instance().handleSuccess).toHaveBeenCalledWith(theFakeResponse, group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
      spy2.mockRestore();
    });

    it("it should include the correct headers", () => {
      const spy = jest.spyOn($, 'ajax').mockImplementation(function (e) {
        expect(e.beforeSend).toEqual(TeamOverview.prototype.setHeader);
        return $.Deferred().resolve(theFakeResponse).promise();
      });
      wrapper.instance().loadTeamData(group);
      expect($.ajax).toHaveBeenCalled();
      spy.mockRestore();
    });
  });
  */

  describe('render', () => {
    beforeEach(() => {
      wrapper = mount(<RewardPage protocolSubscriptionId={5}/>);
    });

    it("should render bezig if there is no state", () => {
      wrapper.instance().setState({
        Mentor: {
          overview: []
        },
        Student: {
          overview: []
        }
      });
      wrapper.update();
      expect(wrapper.name()).toEqual('RewardPage');
      expect(wrapper.text()).toEqual('Bezig...');
    });
/*
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
    */
  });
});
