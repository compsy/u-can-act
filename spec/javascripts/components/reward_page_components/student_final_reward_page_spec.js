describe("StudentFinalRewardPage", function() {
  beforeEach(function() {
    this.earnedEuros = 123;
    var component = React.createElement(StudentFinalRewardPage, {
      earnedEuros: this.earnedEuros
    });
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("render", function() {
    it("it should return the correct text", function() {
      var elems = ReactDOM.findDOMNode(this.rendered).children;
      var expected = 'Heel erg bedankt dat je meedeed aan ons onderzoek! Door jouw deelname kunnen wij onze webapp zo verbeteren ' +
        'dat deze veel beter zal aansluiten aan de wensen van toekomstige deelnemers. Zodra de gegevens bij ons ' +
        'binnen zijn ontvangt jouw S-team begeleider jouw beloning en kan jij je beloning daar dus ophalen.';
      var result = elems[0].innerText;
      expect(result).toEqual(expected);

      var expected = 'In totaal heb je €' + this.earnedEuros + ',- verdiend.';
      var result = elems[1].innerText;
      expect(result).toEqual(expected);

      var expected = 'Hartelijke groeten van het RUG onderzoeksteam:\n' +
        'Nick Snell, Teun Blijlevens en Mandy van der Gaag';
      var result = elems[2].innerText;
      expect(result).toEqual(expected);

      var expected = 'Je kan deze pagina veilig sluiten.'
      var result = elems[3].innerText;
      expect(result).toEqual(expected);
    });
  });
});
