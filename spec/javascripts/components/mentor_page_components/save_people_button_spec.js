describe("SavePeopleButton", function() {
  describe("without forms", function() {
    it("it should not render anything if the number of forms = 0", function() {
      var component = React.createElement(SavePeopleButton, {
        numberOfForms: 0
      });
      var rendered = TestUtils.renderIntoDocument(component)
      var elems = ReactDOM.findDOMNode(rendered).children;
      expect(elems.length).toEqual(0);
    });
  });

  describe("with forms", function() {
    it("it should return the correct text when there is one form", function() {
      var component = React.createElement(SavePeopleButton, {
        numberOfForms: 1
      });
      var rendered = TestUtils.renderIntoDocument(component)
      var elems = ReactDOM.findDOMNode(rendered).children;
      var expected = 'Student opslaan';
      var result = elems[0].innerText;
      expect(result).toEqual(expected);
    })

    it("it should return the correct text when there are multiple forms", function() {
      var component = React.createElement(SavePeopleButton, {
        numberOfForms: 2
      });
      var rendered = TestUtils.renderIntoDocument(component)
      var elems = ReactDOM.findDOMNode(rendered).children;
      var expected = 'Studenten opslaan';
      var result = elems[0].innerText;
      expect(result).toEqual(expected);
    });

  });
});
