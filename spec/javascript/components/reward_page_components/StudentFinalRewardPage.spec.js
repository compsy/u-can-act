import React from 'react'
import {shallow} from 'enzyme'
import StudentFinalRewardPage from 'components/reward_page_components/StudentFinalRewardPage'

describe('StudentFinalRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<StudentFinalRewardPage earnedEuros='123' iban='NL01RABO012341234' name='A.B. Cornelissen'
                                              person={{
                                                earnedEuros: 123,
                                                iban: 'NL01RABO012341234',
                                                name: 'A.B. Cornelissen'
                                              }}/>)
  });

  describe('render', () => {
    it("should return the correct text", () => {
      const elems = wrapper.childAt(1);
      let expected = 'Heel erg bedankt voor je inzet voor dit onderzoek!';
      let result = elems.childAt(0).text();
      expect(result).toEqual(expected);

      expected = 'In totaal heb je €123,- verdiend. We zullen dit bedrag overmaken op IBAN:NL01RABO012341234 ' +
                 't.n.v. A.B. Cornelissen.Klopt dit nummer niet? Klik hier om het aan te passen.';
      result = elems.childAt(1).text();
      expect(result).toEqual(expected);

      expected = 'Hartelijke groeten van het u-can-act team.';
      result = elems.childAt(2).text();
      expect(result).toEqual(expected);

      expected = 'Je kan deze pagina veilig sluiten.';
      result = elems.childAt(3).text();
      expect(result).toEqual(expected);
    });

    it("it should include a link to the edit person page", () => {
      const elems = wrapper.childAt(1);
      let expected = '/person/edit';
      let result = elems.childAt(1).html();
      expect(result).toContain(expected);
    });
  });
});
