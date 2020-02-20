describe("MentorRewardPage", function() {
  beforeEach(function() {
    this.inMaxStreak = 0;
    this.euroDelta = 0;
    this.currentMultiplier = 0;
    this.initialMultiplier = 0;
    this.percentageStreak = 0;
    this.earnedEuros = 0;
    this.awardable = 0;
    this.totalAvailable = 0;

    component = React.createElement(ProgressBar, {
      inMaxStreak: this.inMaxStreak,
      euroDelta: this.euroDelta,
      valueEuro: this.earnedEuros,
      currentMultiplier: this.currentMultiplier,
      initialMultiplier: this.initialMultiplier,
      percentageStreak: this.percentageStreak,
      awardableEuro: this.awardable,
      totalAvailable: this.totalAvailable
    });

    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("constructor", function() {
    it("it should should initialize a timer", function() {
      expect(this.rendered.state.timer).not.toBe(null);
    });

    it("it should initialize the state without streakdetails", function() {
      expect(this.rendered.state.showStreakDetails).toBeFalsy();
    });

    it("it should should initialize a radial state", function() {
      expect(this.rendered.state.radial).toBeDefined();
    });
  });

  describe("componentDidUnmount", function() {
    it("it should set the timer", function() {
      spyOn(window, 'setInterval');
      this.rendered.componentDidMount();
      expect(window.setInterval).toHaveBeenCalled()
      expect(window.setInterval.calls.count()).toEqual(1)
    });

    it("it should render the radial graph", function() {
      spyOn(ProgressBar.prototype, 'renderGraph');
      this.rendered.componentDidMount();
      expect(ProgressBar.prototype.renderGraph).toHaveBeenCalled()
      expect(ProgressBar.prototype.renderGraph.calls.count()).toEqual(1)
    });
  });

  describe("componentWillUnmount", function() {
    it("it should clear the timer", function() {
      spyOn(window, 'clearInterval')
      this.rendered.componentWillUnmount();
      expect(window.clearInterval).toHaveBeenCalled()
      expect(window.clearInterval.calls.count()).toEqual(1)
    });
  });

  describe("calculateInitialValue", function() {
    it("it should calculate the initial value", function() {
      var initialValue = 110,
        delta = 10,
        initialMultiplier = 1,
        currentMultiplier = 10;
      var result = this.rendered.calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier)
      expect(result).toEqual(initialValue - delta + initialMultiplier)
    });

    it("it should return the initial value if there is no multiplier", function() {
      var initialValue = 123,
        delta = 0,
        initialMultiplier = 0,
        currentMultiplier = 0;
      var result = this.rendered.calculateInitialValue(initialValue, delta, initialMultiplier, currentMultiplier)
      expect(result).toEqual(initialValue)
    });
  });

  describe("performTimerEvent", function() {
    it("it should enable the streak details when in maxstreak is true", function() {
      component = React.createElement(ProgressBar, {
        inMaxStreak: true,
        euroDelta: this.euroDelta,
        valueEuro: this.earnedEuros,
        currentMultiplier: this.currentMultiplier,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      rendered = TestUtils.renderIntoDocument(component)
      rendered.performTimerEvent()
      expect(rendered.state.showStreakDetails).toBeTruthy();
    });

    it("it should not enable the streak details when in maxstreak is false", function() {
      component = React.createElement(ProgressBar, {
        inMaxStreak: false,
        euroDelta: this.euroDelta,
        valueEuro: this.earnedEuros,
        currentMultiplier: this.currentMultiplier,
        initialMultiplier: this.initialMultiplier,
        percentageStreak: this.percentageStreak,
        awardableEuro: this.awardable,
        totalAvailable: this.totalAvailable
      });

      rendered = TestUtils.renderIntoDocument(component)
      rendered.performTimerEvent()
      expect(rendered.state.showStreakDetails).toBeFalsy();
    });
  });

  describe("renderGraph", function() {
    it("it should update the radial whenever it is set", function() {
      var percentage_streak = 123;
      var valueEuro = 321;
      var dummy = jasmine.createSpyObj('rad', ['update'])
      this.rendered.setState({radial: dummy})
      var result = this.rendered.renderGraph(valueEuro, percentage_streak, 3, 4)
      expect(dummy.update).toHaveBeenCalled()
      expect(result).not.toEqual(undefined)

      var callArguments =  dummy.update.calls.mostRecent().args[0].series
      expect(callArguments.length).toEqual(2)
      expect(callArguments[0].value).toEqual(percentage_streak)
      expect(callArguments[1].value).toEqual(valueEuro)
    });

    it("it should return a new radialprogresschart if it has not yet been created", function() {
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

      var label = result.options.series[1].labelStart
      expect(label === '€' || label === '✔')
      expect(result.options.series[1].value).toEqual(valueEuro);
      
    });
  });

  describe("createStreakText", function() {
    it("it should not return anything if the showStreakDetails is false", function() {
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

    it("it should not show anything if there is no multiplier larger than 1", function() {
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

    it("it should return a div with the correct class if there are streak details to be shown and there is a multiplier", function() {
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

    it("it should return a div with the correct text", function() {
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
      var expected = 'Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je '+printAsMoney(euroDelta))+' extra verdiend!';
      expect(result).not.toEqual(undefined);
      expect(result.props.children[1]).toEqual(expected);
    });
  });
});
