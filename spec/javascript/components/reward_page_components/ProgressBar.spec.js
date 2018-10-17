import React from 'react'
import {shallow} from 'enzyme'
import ProgressBar from 'components/reward_page_components/ProgressBar'

let wrapper = null;

describe('ProgressBar', () => {
  beforeEach(() => {
    wrapper = shallow(<ProgressBar inMaxStreak={0} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
                                   percentageStreak={0} earnedEuros={0} awardable={0} totalAvailable={0} />)
  });

  describe('constructor', () => {
    it("it should should initialize a timer", () => {
      expect(wrapper.state('timer')).not.toBeNull();
    });

    it("it should initialize the state without streakdetails", () => {
      expect(wrapper.state('showStreakDetails')).toBeFalsy();
    });

    it("it should should initialize a radial state", () => {
      expect(wrapper.state('radial')).toBeDefined();
    });
  });

  describe('componentDidUnmount', () => {
    it("it should set the timer", () => {
      spyOn(window, 'setInterval');
      wrapper.componentDidMount();
      expect(window.setInterval).toHaveBeenCalled()
      expect(window.setInterval.calls.count()).toEqual(1)
    });

    it("it should render the radial graph", () => {
      spyOn(ProgressBar.prototype, 'renderGraph');
      wrapper.componentDidMount();
      expect(ProgressBar.prototype.renderGraph).toHaveBeenCalled()
      expect(ProgressBar.prototype.renderGraph.calls.count()).toEqual(1)
    });
  });

  describe('componentWillUnmount', () => {
    it("it should clear the timer", () => {
      spyOn(window, 'clearInterval')
      wrapper.componentWillUnmount();
      expect(window.clearInterval).toHaveBeenCalled()
      expect(window.clearInterval.calls.count()).toEqual(1)
    });
  });

  describe('calculateInitialValue', () => {
    it("it should calculate the initial value", () => {
      const initialValue = 110,
        delta = 10,
        initialMultiplier = 1,
        currentMultiplier = 10;
      const result = wrapper.calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier)
      expect(result).toEqual(initialValue - delta + initialMultiplier)
    });

    it("it should return the initial value if there is no multiplier", () => {
      const initialValue = 123,
        delta = 0,
        initialMultiplier = 0,
        currentMultiplier = 0;
      const result = wrapper.calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier)
      expect(result).toEqual(initialValue)
    });
  });

  describe('performTimerEvent', () => {
    it("it should enable the streak details when in maxstreak is true", () => {
      wrapper = shallow(<ProgressBar inMaxStreak={true} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
                                   percentageStreak={0} earnedEuros={0} awardable={0} totalAvailable={0} />)
      wrapper.performTimerEvent()
      expect(wrapper.state('showStreakDetails')).toBeTruthy();
    });

    it("it should not enable the streak details when in maxstreak is false", () => {
      wrapper = shallow(<ProgressBar inMaxStreak={false} euroDelta={0} currentMultiplier={0} initialMultiplier={0}
                                   percentageStreak={0} earnedEuros={0} awardable={0} totalAvailable={0} />)
      wrapper.performTimerEvent()
      expect(wrapper.state('showStreakDetails')).toBeFalsy();
    });
  });
/*
  describe('renderGraph', () => {
    it("it should update the radial whenever it is set", () => {
      const percentage_streak = 123;
      const valueEuro = 321;
      const dummy = jasmine.createSpyObj('rad', ['update'])
      this.rendered.setState({radial: dummy})
      var result = this.rendered.renderGraph(valueEuro, percentage_streak, 3, 4)
      expect(dummy.update).toHaveBeenCalled()
      expect(result).not.toEqual(undefined)

      var callArguments =  dummy.update.calls.mostRecent().args[0].series
      expect(callArguments.length).toEqual(2)
      expect(callArguments[0].value).toEqual(percentage_streak)
      expect(callArguments[1].value).toEqual(valueEuro)
    });

    it("it should return a new radialprograsschart if it has not yet been created", () => {
      var percentage_streak = 123;
      var totalAvailable = 4;
      var valueEuro = 321;
      var dummy = jasmine.createSpyObj('rad', ['update']);
      this.rendered.setState({radial: undefined});

      expect(this.rendered.state.radial).toEqual(undefined);
      var result = this.rendered.renderGraph(valueEuro, percentage_streak, 3, totalAvailable);

      // Updating the radial state should happen in another function
      expect(this.rendered.state.radial).toEqual(undefined);
      expect(result).not.toEqual(undefined);
      expect(result.constructor.name).toEqual('RadialProgressChart');

      // Check if some of the options are set correctly
      expect(result.options.diameter).toEqual(250);
      expect(result.options.max).toEqual(totalAvailable);
      expect(result.options.round).toBeTruthy();
      expect(result.options.series[0].labelStart).toEqual('★');
      expect(result.options.series[0].value).toEqual(percentage_streak);

      expect(result.options.series[1].labelStart).toEqual('€');
      expect(result.options.series[1].value).toEqual(valueEuro);
      
    });
  });

  describe('createStreakText', () => {
    it("it should not return anything if the showStreakDetails is false", () => {
      component = React.createElement(ProgressBar, {
        inMaxStreak: this.inMaxStreak,
        euroDelta: this.euroDelta,
        valueEuro: this.earnedEuros,
        currentMultiplier: 10,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      var current_rendered = TestUtils.renderIntoDocument(component);

      current_rendered.setState({showStreakDetails: false});
      var result = current_rendered.createStreakText();
      expect(result).toEqual(undefined);
    });

    it("it should not show anything if there is no multiplier larger than 1", () => {
      component = React.createElement(ProgressBar, {
        inMaxStreak: this.inMaxStreak,
        euroDelta: this.euroDelta,
        valueEuro: this.earnedEuros,
        currentMultiplier: 1,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      var current_rendered = TestUtils.renderIntoDocument(component);
      current_rendered.setState({showStreakDetails: true});
      var result = current_rendered.createStreakText();
      expect(result).toEqual(undefined);
    });

    it("it should return a div with the correct class if there are streak details to be shown and there is a multiplier", () => {
      component = React.createElement(ProgressBar, {
        inMaxStreak: this.inMaxStreak,
        euroDelta: this.euroDelta,
        valueEuro: this.earnedEuros,
        currentMultiplier: 10,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      var current_rendered = TestUtils.renderIntoDocument(component);
      current_rendered.setState({showStreakDetails: true});
      var result = current_rendered.createStreakText();
      expect(result).not.toEqual(undefined);
      expect(result.type).toEqual('div');
      expect(result.props.className).toEqual('animated pulse');
    });

    it("it should return a div with the correct text", () => {
      var euroDelta = 10;
      component = React.createElement(ProgressBar, {
        inMaxStreak: this.inMaxStreak,
        euroDelta: euroDelta,
        valueEuro: 0,
        currentMultiplier: 2,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      var current_rendered = TestUtils.renderIntoDocument(component);
      current_rendered.setState({showStreakDetails: true});
      var result = current_rendered.createStreakText();
      expect(result).not.toEqual(undefined);
      expect(result.props.children[1]).toEqual('Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je €'+euroDelta+',- extra verdiend!');
    });
  });
  */
});
