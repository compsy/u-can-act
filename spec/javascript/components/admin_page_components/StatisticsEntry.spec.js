import React from 'react'
import {shallow} from 'enzyme'
import StatisticsEntry from 'components/admin_page_components/StatisticsEntry';

describe('StatisticsEntry', () => {
  let title, icon, value, subtext, wrapper;

  beforeEach(() => {
    title = 'students';
    icon = 'iconicon';
    value = '40';
    subtext = 'subsub text';
    wrapper = shallow(<StatisticsEntry icon={icon} title={title} value={value} subtext={subtext}/>)
  });

  //describe('generateOverviewRows', () => {
    //beforeEach(() => {
      //this.result = wrapper.instance().generateOverviewRows(this.overview, this.overviewName);
    //});


    //it("it should return an array", () => {
      //expect(this.result).toEqual(jasmine.any(Array))
      //expect(this.result.length).toEqual(2)
    //});

    //it("it should contain a table row with the correct elements and their keys and values", () => {
      //let j = 0;
      //for (let i = 0, len = this.overview.length; i < len; i++) {
        //expect(this.result[i].type).toEqual('tr');
        //expect(this.result[i].key).toEqual(this.overview[i].name + '_' + this.overviewName);

        //j = 0;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_name');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].name);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].completed);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_percentage_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual([this.overview[i].percentage_completed, '%']);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_met_threshold_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].met_threshold_completion);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_percentage_above_threshold');
        //expect(this.result[i].props.children[j].props.children).toEqual([this.overview[i].percentage_above_threshold, '%']);
      //}
    //});

  //});

  //describe('generateTable', () => {
    //beforeEach(() => {
      //this.rows = wrapper.instance().generateOverviewRows(this.overview, this.overviewName);
      //this.result = wrapper.instance().generateTable(this.rows);
    //});

    //it("it should return a table", () => {
      //expect(this.result.type).toEqual('table');
    //});

    //it("it should return a table with the correct headers", () => {
      //expect(this.result.props.children[0].type).toEqual('thead');
      //const header = this.result.props.children[0].props.children
      //expect(header.type).toEqual('tr');

      //let j = 0;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Team');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Completed');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Completed percentage');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' ≥ 70% completed questionnaires');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' % of mentors with ≥ 70% completed questionnaires');
    //});

    //it("it should return a table with the correct body", () => {
      //expect(this.result.props.children[1].type).toEqual('tbody');
      //const body = this.result.props.children[1].props.children
      //expect(body).toEqual(this.rows);
    //});
  //});

  describe('render', () => {
    it("it should return a div with the correct class", () => {
      expect(wrapper.name()).toEqual('div')
      expect(wrapper.is('.statistics-entry.col.s6.m6.l6.xl3')).toBeTruthy()
    });

    it("it should return the correct title", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(0)
      expect(node.name()).toEqual('p')
      expect(node.text()).toContain(title)
    });

    it("it should return the correct icon", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(0).childAt(0)
      expect(node.name()).toEqual('i')
      expect(node.text()).toEqual(icon)
    });

    it("it should return the correct value", () => {
      const node = wrapper.childAt(0).childAt(0).childAt(1)
      expect(node.name()).toEqual('h4')
      expect(node.text()).toEqual(value)
    });
    it("it should return the correct value", () => {
      const node =  wrapper.childAt(0).childAt(0).childAt(2).childAt(0)
      expect(node.name()).toEqual('span')
      expect(node.text()).toEqual(subtext)
    });

    //it("it should return the correct table", () => {
      //expect(this.result.children[1].nodeName).toEqual('TABLE')
    //});

  });
});
