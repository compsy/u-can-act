describe("StudentFinalRewardPage", function () {
  beforeEach(function () {
    this.earnedEuros = 123;
    this.iban = 'NL01RABO012341234';
    this.name = 'A.B. Cornelissen';
    var component = React.createElement(StudentFinalRewardPage, {
      earnedEuros: this.earnedEuros,
      iban: this.iban,
      name: this.name,
      person: {
        earnedEuros: this.earnedEuros,
        iban: this.iban,
        name: this.name
      }
    });
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("render", function () {
    it("it should return the correct text", function () {
      var elems = ReactDOM.findDOMNode(this.rendered).children[1].children;
      var expected = 'Heel erg bedankt voor je inzet voor dit onderzoek!';
      var result = elems[0].innerText;
      expect(result).toEqual(expected);

      var expected = 'In totaal heb je ' + printAsMoney(this.earnedEuros) + ' verdiend. '+
          'We zullen dit bedrag overmaken op IBAN:\n' +
          this.iban + ' t.n.v. ' + this.name+'.\n'+
          'Klopt dit nummer niet? Klik hier om het aan te passen.';
      var result = elems[1].innerText;
      expect(result).toEqual(expected);

      var expected = 'Hartelijke groeten van het u-can-act team.';
      var result = elems[2].innerText;
      expect(result).toEqual(expected);

      var expected = 'Je kan deze pagina veilig sluiten.';
      var result = elems[3].innerText;
      expect(result).toEqual(expected);
    });

    it("it should include a link to the edit person page", function () {
      var elems = ReactDOM.findDOMNode(this.rendered).children;
      var expected = '/person/edit';
      var result = elems[1].innerHTML;
      expect(result).toContain(expected);
    });
  });
});
