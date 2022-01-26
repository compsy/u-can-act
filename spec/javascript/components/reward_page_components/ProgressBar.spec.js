import React from 'react';
import { shallow } from 'enzyme';
import ProgressBar from 'reward_page_components/ProgressBar';
import { printAsMoney } from 'Helpers';

describe('ProgressBar', () => {
  let wrapper = {};

  beforeEach(() => {
    wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
                                   percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0}/>);
  });

  describe('constructor', () => {
    it('it should should initialize a timer', () => {
      expect(wrapper.state('timer')).not.toBeNull();
    });

    it('it should initialize the state without streakdetails', () => {
      expect(wrapper.state('showStreakDetails')).toBeFalsy();
    });

    it('it should should initialize a radial state', () => {
      expect(wrapper.state('radial')).toBeDefined();
    });
  });

  describe('componentDidUnmount', () => {
    it('it should set the timer', () => {
      const spy = jest.spyOn(window, 'setInterval');
      wrapper.instance().componentDidMount();
      expect(window.setInterval).toHaveBeenCalled();
      expect(window.setInterval).toHaveBeenCalledTimes(1);
      spy.mockRestore();
    });

    it('it should render the radial graph', () => {
      const spy = jest.spyOn(ProgressBar.prototype, 'renderGraph');
      wrapper.instance().componentDidMount();
      expect(ProgressBar.prototype.renderGraph).toHaveBeenCalled();
      expect(ProgressBar.prototype.renderGraph).toHaveBeenCalledTimes(1);
      spy.mockRestore();
    });
  });

  describe('componentWillUnmount', () => {
    it('it should clear the timer', () => {
      const spy = jest.spyOn(window, 'clearInterval');
      wrapper.instance().componentWillUnmount();
      expect(window.clearInterval).toHaveBeenCalled();
      expect(window.clearInterval).toHaveBeenCalledTimes(1);
      spy.mockRestore();
    });
  });

  describe('calculateInitialValue', () => {
    it('it should calculate the initial value', () => {
      const initialValue = 110,
        delta = 10,
        initialMultiplier = 1,
        currentMultiplier = 10;
      const result = wrapper.instance().calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier);
      expect(result).toEqual(initialValue - delta + initialMultiplier);
    });

    it('it should return the initial value if there is no multiplier', () => {
      const initialValue = 123,
        delta = 0,
        initialMultiplier = 0,
        currentMultiplier = 0;
      const result = wrapper.instance().calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier);
      expect(result).toEqual(initialValue);
    });
  });

  describe('performTimerEvent', () => {
    it('it should enable the streak details when in maxstreak is true', () => {
      wrapper = shallow(<ProgressBar inMaxStreak={true} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
        percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0} />);
      wrapper.instance().performTimerEvent();
      expect(wrapper.state('showStreakDetails')).toBeTruthy();
    });

    it('it should not enable the streak details when in maxstreak is false', () => {
      wrapper = shallow(<ProgressBar inMaxStreak={false} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
        percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0}/>);
      wrapper.instance().performTimerEvent();
      expect(wrapper.state('showStreakDetails')).toBeFalsy();
    });
  });

  describe('renderGraph', () => {
    it('it should update the radial whenever it is set', () => {
      const percentageStreak = 123;
      const valueEuro = 321;
      const dummy = jest.fn();
      wrapper.setState( { radial: { update: dummy } });
      wrapper.update();
      const result = wrapper.instance().renderGraph(valueEuro, percentageStreak, 3, 4);
      expect(dummy).toHaveBeenCalledTimes(1);
      expect(result).not.toEqual(undefined);
      // times two because we multiply everything by 2 because we sometimes have 50 cents and it can only handle integer
      const callargs = { series: [ { value: 246 }, { value: 642 } ] };
      expect(dummy).toHaveBeenLastCalledWith(callargs);
    });

    it('it should return a new radialprograsschart if it has not yet been created', () => {
      const percentageStreak = 123;
      const totalAvailable = 4;
      const valueEuro = 321;
      wrapper.setState({radial: undefined});
      wrapper.update();

      expect(wrapper.state('radial')).toBeUndefined();
      const result = wrapper.instance().renderGraph(valueEuro, percentageStreak, 3, totalAvailable);

      // Updating the radial state should happen in another function
      expect(wrapper.state('radial')).toEqual(undefined);
      expect(result).not.toEqual(undefined);
      expect(result.constructor.name).toEqual('RadialProgressChart');

      // Check if some of the options are set correctly
      expect(result.options.diameter).toEqual(250);
      expect(result.options.max).toEqual(2 * totalAvailable);
      expect(result.options.round).toBeTruthy();
      expect(result.options.series[0].labelStart).toEqual('★');
      expect(result.options.series[0].value).toEqual(2 * percentageStreak);

      // expect(result.options.series[1].labelStart).toEqual('€');
      expect(result.options.series[1].labelStart).toEqual('✔');
      expect(result.options.series[1].value).toEqual(2 * valueEuro);
    });
  });

  describe('createStreakText', () => {
    it('it should not return anything if the showStreakDetails is false', () => {
      wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={0} currentMultiplier={10} initialMultiplier={0}
                                     percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0}/>);
      wrapper.setState({showStreakDetails: false});
      wrapper.update();
      const result = wrapper.instance().createStreakText();
      expect(result).not.toBeUndefined();
      expect(result).toEqual(<div />);
      expect(result.type).toEqual('div');
    });

    it('it should not show anything if there is no multiplier larger than 1', () => {
      wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={0} currentMultiplier={1} initialMultiplier={0}
        percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0} />);
      wrapper.setState({showStreakDetails: true});
      wrapper.update();
      const result = wrapper.instance().createStreakText();
      expect(result).not.toBeUndefined();
      expect(result.type).toEqual('div');
      expect(result).toEqual(<div />);
    });

    it('it should return a div with the correct class if there are streak details to be shown and there is a multiplier', () => {
      wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={0} currentMultiplier={10} initialMultiplier={0}
        percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0} />);
      wrapper.setState({showStreakDetails: true});
      wrapper.update();
      const result = wrapper.instance().createStreakText();
      expect(result).not.toBeUndefined();
      expect(result.type).toEqual('div');
      expect(result.props.className).toEqual('animated pulse');
    });

    it('it should return a div with the correct text', () => {
      const euroDelta = 10;
      wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={euroDelta} currentMultiplier={2} initialMultiplier={0}
                                     percentageStreak={0} valueEuro={0} awardable={0} totalAvailable={0}/>);

      wrapper.setState({showStreakDetails: true});
      wrapper.update();
      const result = wrapper.instance().createStreakText();
      expect(result).not.toBeUndefined();
      expect(result.props.children[1]).toEqual(`Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je ${printAsMoney(euroDelta)} extra verdiend!`);
    });
  });
});
