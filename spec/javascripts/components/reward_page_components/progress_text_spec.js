describe("ProgressText", function() {
  beforeEach(function() {
  this.awardable= 10;
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

    component = React.createElement(ProgressText, {
      protocolCompletion: this.protocolCompletion,
      awardable: this.awardable
    });

    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("calculateProgess", function() {
    it("it should should return the rounded total percentage of non-future entries", function() {
      var result = this.rendered.calculateProgess(this.protocolCompletion);
      // (3/5*100)
      expect(result).toEqual(Math.round(3 / 5 * 100));
    });

    it("it should return 0 if there are only future measurements", function() {
      var protocolCompletion = [{
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }, {
        "future": true
      }];

      var result = this.rendered.calculateProgess(protocolCompletion);
      // (3/5*100)
      expect(result).toEqual(0);
    });
  });

  describe("render", function() {
    it("it should display a rendered message", function() {
      var elems = ReactDOM.findDOMNode(this.rendered).children;
      var expected = 'Het onderzoek is voor 60% voltooid. Er zijn nog '+printAsMoney(this.awardable)+' te verdienen.';
      var result = elems[0].innerText;
      expect(result).toEqual(expected);
    });
  });
});
