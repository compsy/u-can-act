
describe("RewardPage", function() {
  beforeEach(function() {
    component = React.createElement(RewardPage, 1);
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("returns true if the protocol subscription is done", function() {
    console.log(this.rendered);

    done = this.rendered.isDone()
    expect(done).toEqual(true);
  });
});

