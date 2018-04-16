describe("MentorRewardPage", function() {
  beforeEach(function() {
    component = React.createElement(MentorRewardPage, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("it should return the correct text", function() {
    var elems = ReactDOM.findDOMNode(this.rendered).children;
    var expected = 'Heel erg bedankt dat je meedeed aan ons onderzoek! Door jouw deelname kunnen wij onze webapp zo verbeteren dat deze veel beter zal aansluiten aan de wensen van toekomstige deelnemers.';
    var result = elems[0].innerText;
    expect(result).toEqual(expected);

    var expected = 'Hartelijke groeten van het RUG onderzoeksteam:\nNick Snell, Teun Blijlevens en Mandy van der Gaag';
    var result = elems[1].innerText;
    expect(result).toEqual(expected);

    var expected = 'Je kan deze pagina veilig sluiten.';
    var result = elems[2].innerText;
    expect(result).toEqual(expected);
  });
});

