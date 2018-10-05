describe("SoloRewardPage", function() {
  beforeEach(function() {
    var component = React.createElement(SoloRewardPage, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("it should return the correct text", function() {
    var elems = ReactDOM.findDOMNode(this.rendered).children;
    var expected = 'Uw gegevens zijn opgeslagen. Hartelijk dank voor uw deelname aan het evaluatieonderzoek!';
    var result = elems[0].innerText;
    expect(result).toEqual(expected);
  });
});
