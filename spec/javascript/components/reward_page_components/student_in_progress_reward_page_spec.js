describe('StudentInProgressRewardPage', () => {
  beforeEach(() => {
  this.protocolCompletion = [{
    "completed": true,
    "periodical": false,
    "reward_points": 0,
    "future": false,
    "streak": -1
  }, {
    "completed": true,
    "periodical": false,
    "reward_points": 0,
    "future": false,
    "streak": 0
  }, {
    "completed": true,
    "periodical": false,
    "reward_points": 0,
    "future": true,
    "streak": 1
  }, {
    "completed": true,
    "periodical": false,
    "reward_points": 0,
    "future": false,
    "streak": 0
  }, {
    "completed": true,
    "periodical": false,
    "reward_points": 0,
    "future": true,
    "streak": 1
  }];

    this.maxStreak = 0;
    this.earnedEuros = 0;
    this.awardable = 0;
    this.maxStreak = 10;
    this.initialMultiplier = 0;
    this.currentMultiplier = 0;
    this.earnedEuros = 0;
    this.euroDelta = 0;

    var component = React.createElement(StudentInProgressRewardPage, {
      maxStreak: this.maxStreak,
      earnedEuros: this.earnedEuros,
      awardable: this.awardable,
      maxStreak: this.maxStreak,
      protocolCompletion: this.protocolCompletion,
      initialMultiplier: this.initialMultiplier,
      currentMultiplier: this.currentMultiplier,
      earnedEuros: this.earnedEuros,
      euroDelta: this.euroDelta
    });
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe('findCurrentStreak', () => {
    it("it should return 0 if there are only future measurements", () => {
      var protocolCompletion = [{
        "future": true,
        "streak": 1
      }, {
        "future": true,
        "streak": 2
      }, {
        "future": true,
        "streak": 3
      }, {
        "future": true,
        "streak": 4
      }, {
        "future": true,
        "streak": 5
      }];

      var result = this.rendered.findCurrentStreak(protocolCompletion, this.maxStreak);
      expect(result).toEqual(0);
    });

    it("it should the streak of the first elem before a future one", () => {
      var protocolCompletion = [{
        "future": false,
        "streak": 1
      }, {
        "future": false,
        "streak": 2
      }, {
        "future": true,
        "streak": 3
      }, {
        "future": true,
        "streak": 4
      }, {
        "future": true,
        "streak": 5
      }];

      var result = this.rendered.findCurrentStreak(protocolCompletion, this.maxStreak);
      expect(result).toEqual(protocolCompletion[1].streak);
    });

    it("it should return a value that should never exceed the max possible value", () => {
      var protocolCompletion = [{
        "future": false,
        "streak": 1000
      }, {
        "future": false,
        "streak": 2000
      }, {
        "future": true,
        "streak": 3000
      }, {
        "future": true,
        "streak": 4000
      }, {
        "future": true,
        "streak": 5000
      }];

      var result = this.rendered.findCurrentStreak(protocolCompletion, this.maxStreak);
      expect(result).toEqual(this.maxStreak);
    });
    
    it("it should never return a value < 0", () => {
      var protocolCompletion = [{
        "future": false,
        "streak": -1000
      }, {
        "future": false,
        "streak": -2000
      }, {
        "future": true,
        "streak": -3000
      }, {
        "future": true,
        "streak": -4000
      }, {
        "future": true,
        "streak": -5000
      }];

      var result = this.rendered.findCurrentStreak(protocolCompletion, -10);
      expect(result).toEqual(0);
      
    });
  });
});
