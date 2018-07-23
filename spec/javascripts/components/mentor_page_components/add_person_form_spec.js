describe("AddPersonForm", function() {
  beforeEach(function() {
    const component = React.createElement(AddPersonForm, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("defaultProps", function() {
    it("it should have the correct default props", function() {
      const defaultProps = {
        values: {
          firstName: undefined,
          lastName: undefined,
          mobilePhone: undefined,
          protocol: undefined
        },
        formId: undefined
      }
      expect(this.rendered.props).toEqual(defaultProps);
    });
  });

  describe("render", function() {
    it("it should render 4 elements", function() {
      const elems = ReactDOM.findDOMNode(this.rendered).children;
      expect(elems[0].children.length).toEqual(4);
    });

    it("it should render a form with a first_name field", function() {
      const elems = ReactDOM.findDOMNode(this.rendered).children;
      const expectedName = 'firstName'
      const expectedId = 'first_name'
      const expectedType = 'text'
      const idx = 0;
      expect(elems[0].children[0].children[idx].name).toEqual(expectedName);
      expect(elems[0].children[0].children[idx].id).toEqual(expectedId);
      expect(elems[0].children[0].children[idx].type).toEqual(expectedType);
    });

    it("it should render a form with a last_name field", function() {
      const elems = ReactDOM.findDOMNode(this.rendered).children;
      const expectedName = 'lastName'
      const expectedId = 'last_name'
      const expectedType = 'text'
      const idx = 1;
      expect(elems[0].children[idx].children[0].name).toEqual(expectedName);
      expect(elems[0].children[idx].children[0].id).toEqual(expectedId);
      expect(elems[0].children[idx].children[0].type).toEqual(expectedType);
    });

    it("it should render a form with a mobile_phone field", function() {
      const elems = ReactDOM.findDOMNode(this.rendered).children;
      const expectedName = 'mobilePhone'
      const expectedId = 'mobile_phone'
      const expectedType = 'text'
      const idx = 2;
      expect(elems[0].children[idx].children[0].name).toEqual(expectedName);
      expect(elems[0].children[idx].children[0].id).toEqual(expectedId);
      expect(elems[0].children[idx].children[0].type).toEqual(expectedType);
    });

    it("it should render a form with a protocol field", function() {
      const elems = ReactDOM.findDOMNode(this.rendered).children;
      const expectedName = 'protocol'
      const expectedId = 'protocol'
      const expectedType = 'select'
      const idx = 3;
      expect(elems[0].children[idx].children[0].name).toEqual(expectedName);
      expect(elems[0].children[idx].children[0].id).toEqual(expectedId);
      expect(elems[0].children[idx].children[0].type).toEqual(expectedType);
    });
  });

  describe("handleOnChange", function() {
    it("it should call the correct callback function for each of the fields", function() {
      const testId = 123;
      const testVal = 'testtest';
      const spyCallback = jasmine.createSpy();
      const component = React.createElement(AddPersonForm, {
        handleOnChange: spyCallback,
        formId: testId
      });

      const rendered = TestUtils.renderIntoDocument(component)
      const inputs = ReactDOM.findDOMNode(rendered).querySelectorAll('input');

      inputs.forEach(input => {
        input.value = testVal;

        TestUtils.Simulate.change(input);

        expect(input.value).toBe(testVal);
        expect(spyCallback).toHaveBeenCalledWith(
          input.name,
          input.value,
          testId
        );
        spyCallback.calls.reset();
      });
    });
  });
});
