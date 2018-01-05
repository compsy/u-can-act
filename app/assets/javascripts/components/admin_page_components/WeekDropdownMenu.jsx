class WeekDropdownMenu extends React.Component {
  /* For a given date, get the ISO week number
   * FROM https://stackoverflow.com/questions/6117814/get-week-of-year-in-javascript-like-in-php
   * Based on information at:
   *
   *    http://www.merlyn.demon.co.uk/weekcalc.htm#WNR
   *
   * Algorithm is to find nearest thursday, it's year
   * is the year of the week number. Then get weeks
   * between that date and the first day of that year.
   *
   * Note that dates in one year can be weeks of previous
   * or next year, overlap is up to 3 days.
   *
   * e.g. 2014/12/29 is Monday in week  1 of 2015
   *      2012/1/1   is Sunday in week 52 of 2011
   */
  getMaxWeekNumber(d) {
    // Copy date so don't modify original
    current_date = new Date()
    if(d.getFullYear() == current_date.getFullYear()) {
      d = new Date(Date.UTC(current_date.getFullYear(), current_date.getMonth(), current_date.getDate()));
    } else {
      d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    }
    // Set to nearest Thursday: current date + 4 - current day number
    // Make Sunday's day number 7
    d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
    // Get first day of year
    var yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    // Calculate full weeks to nearest Thursday
    var weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
    // Return array of year and week number
    return [weekNo];
  }

  generateWeeks(year) {
    var dat = new Date(year, 11, 31);
    var end = this.getMaxWeekNumber(dat);
    var weeks = [];
    for (var i = 1; i <= end; i++) { weeks.push(i); }
    return (weeks)
  }

  render() {
    var weeks = this.generateWeeks(this.props.year);
    console.log('rendering' + weeks);
    return(
      <Select options={weeks} label='Week number' onChange={this.props.onChange} />
    )
  }
}
