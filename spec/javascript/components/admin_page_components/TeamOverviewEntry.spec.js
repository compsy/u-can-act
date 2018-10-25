import React from 'react'
import {shallow} from 'enzyme'
import TeamOverviewEntry from 'components/admin_page_components/TeamOverviewEntry';

describe('TeamOverviewEntry', () => {
  let overview, overviewName, wrapper;

  beforeEach(() => {
    overview = [{
      'name': 'School naam',
      'completed': 10,
      'percentage_completed': 50,
      'met_threshold_completion': 20,
      'percentage_above_threshold': 30
    }, {
      'name': 'School naam1',
      'completed': 11,
      'percentage_completed': 51,
      'met_threshold_completion': 21,
      'percentage_above_threshold': 31
    }];
    overviewName = 'the_overview_name';
    wrapper = shallow(<TeamOverviewEntry overview={overview} name={overviewName}/>);
  });

  describe('generateOverviewRows', () => {
    let result;

    beforeEach(() => {
      result = wrapper.instance().generateOverviewRows(overview, overviewName);
    });

    it("it should return an array", () => {
      expect(result instanceof Array).toBeTruthy();
      expect(result).toHaveLength(2);
    });

    it("it should contain a table row with the correct elements and their keys and values", () => {
      let j = 0;
      for (let i = 0, len = overview.length; i < len; i++) {
        expect(result[i].type).toEqual('tr');
        expect(result[i].key).toEqual(overview[i].name + '_' + overviewName);

        j = 0;
        expect(result[i].props.children[j].type).toEqual('td');
        expect(result[i].props.children[j].key).toEqual(overview[i].name + '_name');
        expect(result[i].props.children[j].props.children).toEqual(overview[i].name);

        j++;
        expect(result[i].props.children[j].type).toEqual('td');
        expect(result[i].props.children[j].key).toEqual(overview[i].name + '_completion');
        expect(result[i].props.children[j].props.children).toEqual(overview[i].completed);

        j++;
        expect(result[i].props.children[j].type).toEqual('td');
        expect(result[i].props.children[j].key).toEqual(overview[i].name + '_percentage_completion');
        expect(result[i].props.children[j].props.children).toEqual([overview[i].percentage_completed, '%']);

        j++;
        expect(result[i].props.children[j].type).toEqual('td');
        expect(result[i].props.children[j].key).toEqual(overview[i].name + '_met_threshold_completion');
        expect(result[i].props.children[j].props.children).toEqual(overview[i].met_threshold_completion);

        j++;
        expect(result[i].props.children[j].type).toEqual('td');
        expect(result[i].props.children[j].key).toEqual(overview[i].name + '_percentage_above_threshold');
        expect(result[i].props.children[j].props.children).toEqual([overview[i].percentage_above_threshold, '%']);
      }
    });

  });

  describe('generateTable', () => {
    let rows, result;

    beforeEach(() => {
      rows = wrapper.instance().generateOverviewRows(overview, overviewName);
      result = wrapper.instance().generateTable(rows);
    });

    it("it should return a table", () => {
      expect(result.type).toEqual('table');
    });

    it("it should return a table with the correct headers", () => {
      expect(result.props.children[0].type).toEqual('thead');
      const header = result.props.children[0].props.children;
      expect(header.type).toEqual('tr');

      let j = 0;
      expect(header.props.children[j].type).toEqual('th');
      expect(header.props.children[j].props.children).toEqual('Team');

      j++;
      expect(header.props.children[j].type).toEqual('th');
      expect(header.props.children[j].props.children).toEqual('Completed');

      j++;
      expect(header.props.children[j].type).toEqual('th');
      expect(header.props.children[j].props.children).toEqual('Completed percentage');

      j++;
      expect(header.props.children[j].type).toEqual('th');
      expect(header.props.children[j].props.children).toEqual('≥ 70% completed questionnaires');

      j++;
      expect(header.props.children[j].type).toEqual('th');
      expect(header.props.children[j].props.children).toEqual('% of mentors with ≥ 70% completed questionnaires');
    });

    it("it should return a table with the correct body", () => {
      expect(result.props.children[1].type).toEqual('tbody');
      const body = result.props.children[1].props.children;
      expect(body).toEqual(rows);
    });
  });

  describe('render', () => {

    it("it should return a div with the correct class", () => {
      expect(wrapper.name()).toEqual('div');
      expect(wrapper.is('.team-overview-entry.col.m12')).toBeTruthy();
    });

    it("it should return the correct title", () => {
      expect(wrapper.childAt(0).name()).toEqual('h4');
      expect(wrapper.childAt(0).text()).toEqual(overviewName);
    });

    it("it should return the correct table", () => {
      expect(wrapper.childAt(1).name()).toEqual('table');
    });
  });
});
