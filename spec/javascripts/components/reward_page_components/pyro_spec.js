describe("Pyro", function() {
  beforeEach(function() {
    component = React.createElement(Pyro, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("it should provide a scafold for the pyro css", function() {
    var elem = ReactDOM.findDOMNode(this.rendered).children[0]
    result = elem.getAttribute('class')
    expect(result).toEqual('pyro');
  });

  it("it should provide a scafold for the pyro css with the correct before and after divs", function() {
    var elems = ReactDOM.findDOMNode(this.rendered).children[0].children
    result = elems[0].getAttribute('class')
    expect(result).toEqual('before');

    result = elems[1].getAttribute('class')
    expect(result).toEqual('after');
  });
});

