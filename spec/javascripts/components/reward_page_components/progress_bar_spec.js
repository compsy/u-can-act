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

  it("it should should initialize a timer", function() {
    expect(this.rendered.state.timer).not.toBe(null);
  });

  it("it should initialize the state without streakdetails", function() {
    expect(this.rendered.state.showStreakDetails).toBeFalsy();
  });

  it("it should should initialize a radial state", function() {
    expect(this.rendered.state.radial).toBeDefined();
  });

  it("it should return the correct text", function() {});

  describe("componentWillUnmount", function() {
    it("it should clear the timer", function() {

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
});
