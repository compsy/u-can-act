describe("Select", function() {
  beforeEach(function() {
    this.options = ['a', '1', '2', '3', '4', '5', 'all'];
    this.value = 1
    this.label = 'The label'

    var component = React.createElement(Select, {
      options: this.options,
      value: this.value,
      label: this.label
    });
    this.rendered = TestUtils.renderIntoDocument(component)
  });

  describe("constructor", function() {
    it("it should create a uuid for itself", function() {
      expect(this.rendered._uuid).not.toBe(undefined);
    });
  });

  describe("generateSelectOptions", function() {
    it("it should add the correct label", function() {
      var result = this.rendered.generateSelectOptions(this.options);
      var entry = result[0]
      expect(entry.key).toEqual('def')
      expect(entry.props.value).toEqual('def')
      expect(entry.props.children).toEqual('Selecteer')
    });

    it("it should generate the select options using the options provided to it", function() {
      var result = this.rendered.generateSelectOptions(this.options);

      // +1 for the label
      expect(result.length).toEqual(this.options.length + 1);
      for (var i = 0, len = result.length; i < len; i++) {
        if (i === 0) continue;
        let entry = result[i];
        expect(entry.key).toEqual(this.options[i - 1])
        expect(entry.props.children).toEqual(this.options[i - 1])
      }
    });
  });

  describe("uuid", function() {
    it("it should generate a random uuid", function() {
      result = this.rendered.uuid()
      result2 = this.rendered.uuid()
      expect(result).not.toEqual(result2);
    });

    it("it should generate a uuid with the correct pattern", function() {
      result = this.rendered.uuid()
      expect(result.length).toEqual(36);
      expect(result).toMatch(/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/);
    });
  });

  describe("redraw", function() {
  });

  describe("componentDidUpdate", function() {
    it("it should call the redraw function", function() {
      spyOn(Select.prototype, 'redraw');
      expect(Select.prototype.redraw).not.toHaveBeenCalled()
      this.rendered.componentDidUpdate();
      expect(Select.prototype.redraw).toHaveBeenCalled()
      expect(Select.prototype.redraw.calls.count()).toEqual(1)
    });
  });

  describe("componentDidMount", function() {
    it("it should call the redraw function", function() {
      spyOn(Select.prototype, 'redraw');
      expect(Select.prototype.redraw).not.toHaveBeenCalled()
      this.rendered.componentDidMount();
      expect(Select.prototype.redraw).toHaveBeenCalled()
      expect(Select.prototype.redraw.calls.count()).toEqual(1)
    });
  });

  describe("_onChange", function() {
    it("it should call the callback function", function() {
      var called = false;
      spyOn(Select.prototype, 'getSelectedOption');
      expect(Select.prototype.getSelectedOption).not.toHaveBeenCalled()

      this.onChange = function() {
        called = true;
      }

      var component = React.createElement(Select, {
        onChange: this.onChange,
        options: this.options,
        value: this.value,
        label: this.label
      });

      rendered = TestUtils.renderIntoDocument(component)
      rendered._onChange();

      expect(Select.prototype.getSelectedOption).toHaveBeenCalled()
      expect(Select.prototype.getSelectedOption.calls.count()).toEqual(1)
      expect(called).toBeTruthy();
    });
  });
});
