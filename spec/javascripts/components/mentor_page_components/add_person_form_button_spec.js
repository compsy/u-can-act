describe("AddPersonFormButton", function() {
  
  it("it should return the correct text when there are no students", function() {
    var component = React.createElement(AddPersonFormButton, {
      numberOfForms: 0
    });
    var rendered = TestUtils.renderIntoDocument(component)
    var elems = ReactDOM.findDOMNode(rendered).children;
    var expected = 'Student toevoegen';
    var result = elems[0].innerText;
    expect(result).toEqual(expected);
  })

  it("it should return the correct text when there are students", function() {
    var component = React.createElement(AddPersonFormButton, {
      numberOfForms: 1
    });
    var rendered = TestUtils.renderIntoDocument(component)
    var elems = ReactDOM.findDOMNode(rendered).children;
    var expected = 'Nog een student toevoegen';
    var result = elems[0].innerText;
    expect(result).toEqual(expected);
  });
});
