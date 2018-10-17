describe('StatisticsEntry', () => {
  beforeEach(() => {
    this.title = 'students';
    this.icon = 'iconicon';
    this.value = '40';
    this.subtext = 'subsub text';

    var component = React.createElement(StatisticsEntry, {
      icon: this.icon,
      title: this.title,
      value: this.value,
      subtext: this.subtext
    });

    this.rendered = TestUtils.renderIntoDocument(component);
  });

  //describe('generateOverviewRows', () => {
    //beforeEach(() => {
      //this.result = this.rendered.generateOverviewRows(this.overview, this.overviewName);
    //});


    //it("it should return an array", () => {
      //expect(this.result).toEqual(jasmine.any(Array))
      //expect(this.result.length).toEqual(2)
    //});

    //it("it should contain a table row with the correct elements and their keys and values", () => {
      //var j = 0;
      //for (var i = 0, len = this.overview.length; i < len; i++) {
        //expect(this.result[i].type).toEqual('tr');
        //expect(this.result[i].key).toEqual(this.overview[i].name + '_' + this.overviewName);

        //j = 0;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_name');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].name);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].completed);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_percentage_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual([this.overview[i].percentage_completed, '%']);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_met_threshold_completion');
        //expect(this.result[i].props.children[j].props.children).toEqual(this.overview[i].met_threshold_completion);

        //j++;
        //expect(this.result[i].props.children[j].type).toEqual('td');
        //expect(this.result[i].props.children[j].key).toEqual(this.overview[i].name + '_percentage_above_threshold');
        //expect(this.result[i].props.children[j].props.children).toEqual([this.overview[i].percentage_above_threshold, '%']);
      //}
    //});

  //});

  //describe('generateTable', () => {
    //beforeEach(() => {
      //this.rows = this.rendered.generateOverviewRows(this.overview, this.overviewName);
      //this.result = this.rendered.generateTable(this.rows);
    //});

    //it("it should return a table", () => {
      //expect(this.result.type).toEqual('table');
    //});

    //it("it should return a table with the correct headers", () => {
      //expect(this.result.props.children[0].type).toEqual('thead');
      //var header = this.result.props.children[0].props.children
      //expect(header.type).toEqual('tr');

      //var j = 0;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Team');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Completed');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' Completed percentage');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' ≥ 70% completed questionnaires');

      //j++;
      //expect(header.props.children[j].type).toEqual('th');
      //expect(header.props.children[j].props.children).toEqual(' % of mentors with ≥ 70% completed questionnaires');
    //});

    //it("it should return a table with the correct body", () => {
      //expect(this.result.props.children[1].type).toEqual('tbody');
      //var body = this.result.props.children[1].props.children
      //expect(body).toEqual(this.rows);
    //});
  //});

  describe('render', () => {
    beforeEach(() => {
      this.result = ReactDOM.findDOMNode(this.rendered)
    });

    it("it should return a div with the correct class", () => {
      expect(this.result.nodeName).toEqual('DIV');
      expect(this.result.attributes.class.nodeValue).toEqual('statistics-entry col s6 m6 l6 xl3');
    });

    it("it should return the correct title", () => {
      const node = this.result.children[0].children[0].children[0]
      expect(node.nodeName).toEqual('P')
      expect(node.innerText).toContain(this.title)
    });

    it("it should return the correct icon", () => {
      const node = this.result.children[0].children[0].children[0].children[0];
      expect(node.nodeName).toEqual('I')
      expect(node.innerText).toEqual(this.icon)
    });

    it("it should return the correct value", () => {
      const node = this.result.children[0].children[0].children[1]
      expect(node.nodeName).toEqual('H4')
      expect(node.innerText).toEqual(this.value)
    });
    it("it should return the correct value", () => {
      const node = this.result.children[0].children[0].children[2].children[0]
      expect(node.nodeName).toEqual('SPAN')
      expect(node.innerText).toEqual(this.subtext)
    });

    //it("it should return the correct table", () => {
      //expect(this.result.children[1].nodeName).toEqual('TABLE')
    //});
  });
});
