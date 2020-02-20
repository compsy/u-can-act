import React from 'react';
import Select from './Select';


export default class WeekDropdownMenu extends React.Component {

  /* For a given date, get the ISO week number
   * FROM https://stackoverflow.com/questions/6117814/get-week-of-year-in-javascript-like-in-php
   * Based on information at:
   *
   *    http://www.merlyn.demon.co.uk/weekcalc.htm#WNR
   *
   * Algorithm is to find nearest thursday, its year
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
    const current_date = new Date();
    let theDate = {};
    if (d.getFullYear() === current_date.getFullYear()) {
      theDate = new Date(Date.UTC(current_date.getFullYear(), current_date.getMonth(), current_date.getDate()));
    } else {
      theDate = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
    }
    // Set to nearest Thursday: current date + 4 - current day number
    // Make Sunday's day number 7
    theDate.setUTCDate(theDate.getUTCDate() + 4 - (theDate.getUTCDay() || 7));
    // Get first day of year
    const yearStart = new Date(Date.UTC(theDate.getUTCFullYear(), 0, 1));
    // Calculate full weeks to nearest Thursday
    const weekNo = Math.ceil(((theDate - yearStart) / 86400000 + 1) / 7);
    // Return array of year and week number
    return [weekNo];
  }

  generateWeeks(year) {
    const lastMonth = 11;
    const lastDay = 31;
    const dat = new Date(year, lastMonth, lastDay);
    const endd = this.getMaxWeekNumber(dat);
    const weeks = [];
    for (let i = 1; i <= endd; i++) {
      weeks.push(i);
    }
    return weeks;
  }

  render() {
    const firstElem = 0;
    const weeks = this.generateWeeks(this.props.year).reverse();
    const selected = weeks[firstElem];
    return (
      <Select value={selected} options={weeks} className='dropdown' label='Week' onChange={this.props.onChange} />
    );
  }
}
