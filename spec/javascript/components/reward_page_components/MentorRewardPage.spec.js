import React from 'react'
import {shallow} from 'enzyme'
import MentorRewardPage from 'components/reward_page_components/MentorRewardPage'

describe('MentorRewardPage', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<MentorRewardPage person={{earnedEuros: 1, iban: 'iban', name: 'name'}} />);
  });
  
  it("it should return the correct text", () => {
    const elems = wrapper.childAt(1);
    let expected = 'Heel erg bedankt voor je inzet voor dit onderzoek!';
    let result = elems.childAt(0).text();
    expect(result).toEqual(expected);

    expected = 'Hartelijke groeten van het u-can-act team.';
    result = elems.childAt(1).text();
    expect(result).toEqual(expected);

    expected = 'Je kan deze pagina veilig sluiten.';
    result = elems.childAt(2).text();
    expect(result).toEqual(expected);
  });
});
