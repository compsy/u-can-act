import React from 'react';
import {
  shallow
} from 'enzyme';
import { printAsMoney } from 'Helpers';
import StudentFinalRewardPage from 'reward_page_components/StudentFinalRewardPage';

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
      const elems = wrapper.childAt(0);
      let expected = 'Bedankt voor het invullen van de vragenlijst!';
      let result = elems.childAt(0).text();
      expect(result).toEqual(expected);

      expected = '<I18nRaw />';
      result = wrapper.childAt(1).text();
      expect(result).toEqual(expected);
      expected = '<div><div class=\'section\'><p class=\'flow-text\'> Heel erg bedankt voor je inzet voor dit onderzoek!  </p> </div></div>'
      result = wrapper.childAt(1).html()
      result = result.replace(/\n/g, '');
      result = result.replace(/>[\s]*</g, '><');
      result = result.replace(/\s\s+/g, ' ');
      //expect(result).toEqual(expected);

      expected = `In totaal heb je ${printAsMoney(123)} verdiend.`
      result = wrapper.childAt(2).text();
      expect(result).toEqual(expected);

      expected = '<I18nRaw />';
      result = wrapper.childAt(3).text();
      expect(result).toEqual(expected);
      expected = '<div><div class=\'section\'> <p class=\'flow-text\'> Je kan deze pagina veilig sluiten.  </p> </div></div>';
      result = wrapper.childAt(3).html()
      result = result.replace(/\n/g, '');
      result = result.replace(/>[\s]*</g, '><');
      result = result.replace(/\s\s+/g, ' ');
      expect(result).toEqual(expected);
    });

    it('it should include a link to the edit person page', () => {
      const elems = wrapper.childAt(1);
      let expected = '/person/edit';
      let result = elems.childAt(1).html();
      expect(result).toContain(expected);
    });
  });
});
