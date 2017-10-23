var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var StudentInProgressRewardPage = (function (_React$Component) {
  _inherits(StudentInProgressRewardPage, _React$Component);

  function StudentInProgressRewardPage(props) {
    _classCallCheck(this, StudentInProgressRewardPage);

    _get(Object.getPrototypeOf(StudentInProgressRewardPage.prototype), 'constructor', this).call(this, props);

    // Find the last non future index
    var percentageStreakIdx = this.props.protocolCompletion.findIndex(function (elem) {
      return elem.future;
    });
    percentageStreakIdx = percentageStreakIdx === 0 ? 0 : percentageStreakIdx - 1;

    var currentStreak = Math.min(this.props.protocolCompletion[percentageStreakIdx].streak, this.props.maxStreak);
    this.inMaxStreak = currentStreak === this.props.maxStreak;

    this.totalAvailable = this.props.earnedEuros + this.props.awardable;
    this.percentageStreak = currentStreak / this.props.maxStreak * this.totalAvailable;
  }

  _createClass(StudentInProgressRewardPage, [{
    key: 'render',
    value: function render() {
      return React.createElement(
        'div',
        null,
        React.createElement(RewardMessage, { euroDelta: this.props.euroDelta, earnedEuros: this.props.earnedEuros }),
        React.createElement(
          'div',
          null,
          React.createElement(
            'div',
            { className: 'section' },
            React.createElement(
              'p',
              { className: 'flow-text' },
              ' Voortgang van het onderzoek'
            )
          ),
          React.createElement(
            'div',
            { className: 'section' },
            this.inMaxStreak ? React.createElement(Pyro, null) : React.createElement('div', null),
            React.createElement(ProgressBar, { euroDelta: this.props.euroDelta,
              valueEuro: this.props.earnedEuros,
              currentMultiplier: this.props.currentMultiplier,
              percentageStreak: this.percentageStreak,
              awardableEuro: this.props.awardable,
              totalAvailable: this.totalAvailable }),
            React.createElement(ProgressText, { awardable: this.props.awardable,
              protocolCompletion: this.props.protocolCompletion })
          )
        )
      );
    }
  }]);

  return StudentInProgressRewardPage;
})(React.Component);