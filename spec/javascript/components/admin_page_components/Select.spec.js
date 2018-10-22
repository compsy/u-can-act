import React from 'react'
import {shallow} from 'enzyme'
import Select from 'components/admin_page_components/Select'

describe('Select', () => {
  let options, value, label, wrapper;

  beforeEach(() => {
    options = ['a', '1', '2', '3', '4', '5', 'all']
    value = 1
    label = 'The label'
    wrapper = shallow(<Select options={options} value={value} label={label} />)
  });

  describe('constructor', () => {
    it("it should create a uuid for itself", () => {
      expect(wrapper.instance()._uuid).not.toBeUndefined();
    });
  });

  describe('generateSelectOptions', () => {
    it("it should add the correct label", () => {
      const result = wrapper.instance().generateSelectOptions(options);
      const entry = result[0]
      expect(entry.key).toEqual('def')
      expect(entry.props.value).toEqual('def')
      expect(entry.props.children).toEqual('Selecteer')
    });

    it("it should generate the select options using the options provided to it", () => {
      const result = wrapper.instance().generateSelectOptions(options);

      // +1 for the label
      expect(result.length).toEqual(options.length + 1);
      for (let i = 0, len = result.length; i < len; i++) {
        if (i === 0) continue;
        const entry = result[i];
        expect(entry.key).toEqual(options[i - 1])
        expect(entry.props.children).toEqual(options[i - 1])
      }
    });
  });

  describe('uuid', () => {
    it("it should generate a random uuid", () => {
      const result = wrapper.instance().uuid()
      const result2 = wrapper.instance().uuid()
      expect(result).not.toEqual(result2);
    });

    it("it should generate a uuid with the correct pattern", () => {
      const result = wrapper.instance().uuid()
      expect(result.length).toEqual(36);
      expect(result).toMatch(/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/);
    });
  });

  describe('redraw', () => {
  });

  describe('componentDidUpdate', () => {
    it("it should call the redraw function", () => {
      const spy = jest.spyOn(Select.prototype, 'redraw')
      expect(Select.prototype.redraw).not.toHaveBeenCalled()
      wrapper.instance().componentDidUpdate();
      expect(Select.prototype.redraw).toHaveBeenCalled()
      expect(Select.prototype.redraw).toHaveBeenCalledTimes(1)
      spy.mockRestore();
    });
  });

  describe('componentDidMount', () => {
    it("it should call the redraw function", () => {
      const spy = jest.spyOn(Select.prototype, 'redraw')
      expect(Select.prototype.redraw).not.toHaveBeenCalled()
      wrapper.instance().componentDidMount();
      expect(Select.prototype.redraw).toHaveBeenCalled()
      expect(Select.prototype.redraw).toHaveBeenCalledTimes(1)
      spy.mockRestore();
    });
  });

  describe('_onChange', () => {
    it("it should call the callback function", () => {
      let called = false;
      const spy = jest.spyOn(Select.prototype, 'getSelectedOption')
      expect(Select.prototype.getSelectedOption).not.toHaveBeenCalled()
      const onChange = () => {
        called = true;
      }
      wrapper = shallow(<Select onChange={onChange} options={options} value={value} label={label} />)
      wrapper.instance()._onChange();
      expect(Select.prototype.getSelectedOption).toHaveBeenCalled()
      expect(Select.prototype.getSelectedOption).toHaveBeenCalledTimes(1)
      expect(called).toBeTruthy();
      spy.mockRestore();
    });
  });
});
