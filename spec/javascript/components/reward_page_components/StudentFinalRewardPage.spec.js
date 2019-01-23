import React from 'react';
import {
  shallow
} from 'enzyme';

import {
  printAsMoney
} from 'Helpers';
import StudentFinalRewardPage from 'reward_page_components/StudentFinalRewardPage';

jest.mock('i18n', () => {
  return {
    t: (val) => {
      return val;
    }
  };
});

describe('StudentFinalRewardPage', () => {
  let wrapper = {};

  beforeEach(() => {
    wrapper = shallow(<StudentFinalRewardPage earnedEuros='123' iban='NL01RABO012341234' name='A.B. Cornelissen'
      person={{
        earnedeuros: 123,
        iban: 'nl01rabo012341234',
        name: 'a.b. cornelissen'
      }} />);
  });

  describe('render', () => {
    it('should return the correct text', () => {
      let idx = 0;
      const earnedEuros = 123;
      const elems = wrapper.childAt(idx);
      let expected = 'pages.student_final_reward_page.header';
      let result = elems.childAt(idx).text();
      expect(result).toEqual(expected);

      idx++;
      expected = '<I18nRaw />';
      result = elems.childAt(idx).text();
      expect(result).toEqual(expected);
      expected = '<div>pages.student_final_reward_page.body.top</div>';
      result = elems.childAt(idx).html();
      expect(result).toEqual(expected);

      idx++;
      expected = `In totaal heb je ${printAsMoney(earnedEuros)} verdiend.`;
      result = elems.childAt(idx).text();
      expect(result).toEqual(expected);

      idx++;
      expected = '<I18nRaw />';
      result = elems.childAt(idx).text();
      expect(result).toEqual(expected);
      expected = '<div>pages.student_final_reward_page.body.bottom</div>';
      result = elems.childAt(idx).html();
      expect(result).toEqual(expected);
    });

    it('it should include a link to the edit person page', () => {
      const secondChild = 1;
      const firstElement = 0;
      const elems = wrapper.childAt(secondChild);
      let expected = '/person/edit';
      let result = elems.childAt(firstElement).html();
      expect(result).toContain(expected);
    });
  });
});
