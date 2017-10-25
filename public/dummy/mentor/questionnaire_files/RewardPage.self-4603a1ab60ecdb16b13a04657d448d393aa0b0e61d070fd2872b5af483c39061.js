var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var RewardPage = (function (_React$Component) {
  _inherits(RewardPage, _React$Component);

  function RewardPage(props) {
    _classCallCheck(this, RewardPage);

    _get(Object.getPrototypeOf(RewardPage.prototype), 'constructor', this).call(this, props);
    this.state = {
      result: undefined
    };
  }

  _createClass(RewardPage, [{
    key: 'componentDidMount',
    value: function componentDidMount() {
      this.loadRewardData(this.props.protocolSubscriptionId);
    }
  }, {
    key: 'componentWillReceiveProps',
    value: function componentWillReceiveProps(nextProps) {
      this.loadRewardData(nextProps.protocolSubscriptionId);
    }
  }, {
    key: 'isDone',
    value: function isDone() {
      return !this.state.result.protocol_completion.some(function (entry) {
        return entry.future;
      });
    }
  }, {
    key: 'loadRewardData',
    value: function loadRewardData(protocolSubscriptionId) {
      var self = this;

      // Only update if the subscription id has changed
      var url = '/api/v1/protocol_subscriptions/' + protocolSubscriptionId;
      $.getJSON(url, function (response) {
        self.setState({
          result: response
        });
      });
    }
  }, {
    key: 'getCorrectResultPage',
    value: function getCorrectResultPage() {
      if (this.state.result.person_type === 'Mentor') {
        if (!this.isDone()) {
          return React.createElement('div', null);
        }
        return React.createElement(MentorRewardPage, null);
      }

      var earnedEuros = this.state.result.earned_euros / 100;
      if (this.isDone()) {
        return React.createElement(StudentFinalRewardPage, { earnedEuros: earnedEuros });
      }

      var euroDelta = this.state.result.euro_delta / 100;
      var maxStillAwardableEuros = this.state.result.max_still_awardable_euros / 100;
      return React.createElement(StudentInProgressRewardPage, { euroDelta: euroDelta,
        earnedEuros: earnedEuros,
        currentMultiplier: this.state.result.current_multiplier,
        awardable: maxStillAwardableEuros,
        protocolCompletion: this.state.result.protocol_completion,
        maxStreak: this.state.result.max_streak.threshold });
    }
  }, {
    key: 'render',
    value: function render() {
      if (!this.state.result) {
        return React.createElement(
          'div',
          null,
          'Bezig...'
        );
      }

      result = this.getCorrectResultPage();
      return React.createElement(
        'div',
        { className: 'col s12' },
        React.createElement(
          'div',
          { className: 'row' },
          React.createElement(
            'div',
            { className: 'col s12' },
            React.createElement(
              'h4',
              null,
              'Bedankt voor het invullen van de vragenlijst!'
            ),
            result
          )
        )
      );
    }
  }]);

  return RewardPage;
})(React.Component);