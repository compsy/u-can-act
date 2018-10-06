describe("RewardMessage", function() {
  beforeEach(function() {
    component = React.createElement(RewardMessage, {euroDelta: 123});
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("should render the correct reward text", function() {
    var expected = "Je hebt hiermee "+printAsMoney(123)+" verdiend."
    var result = ReactDOM.findDOMNode(this.rendered).children[0].innerText
    expect(result).toEqual(expected);
  });

  it("it should be contained in the correct classes", function() {
    var elem = ReactDOM.findDOMNode(this.rendered)
    var outer_result = elem.getAttribute('class')
    expect(outer_result).toEqual('section');

    var inner_result = elem.children[0].getAttribute('class') 
    expect(inner_result).toEqual('flow-text');
  });
});

