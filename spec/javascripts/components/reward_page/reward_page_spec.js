
describe("RewardPage", function() {
  beforeEach(function() {
    this.component = React.createElement(RewardPage, 1);
  });
  
  it("returns true if the protocol subscription is done", function() {
    console.log(this.component);

    done = this.component.isDone()
    expect(done).toEqual(true);
  });
});

