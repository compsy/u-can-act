import React, { useState } from 'react'
import ReactDatePicker from 'react-datepicker'
import classNames from 'classnames'
import moment from 'moment'
import { datePickerDefaultOptions, backendDateFormat } from './Constants'

const DatePicker = props => {
  const [startDate, setStartDate] = useState(undefined)

  const convertToDate = datestr => {
    // TODO: this should be more generic
    if (!datestr || datestr.length === 0) return undefined
    if (datestr === 'two_weeks_ago') return moment().subtract(2, 'weeks').toDate()
    if (datestr === 'today') return moment().toDate()
    return moment(datestr).toDate()
  }

  return (
    <div className='input-field'>
      <ReactDatePicker
        id={props.id}
        {...datePickerDefaultOptions}
        selected={startDate}
        onChange={date => setStartDate(date)}
        minDate={convertToDate(props.min)}
        maxDate={convertToDate(props.max)}
      />
      <label htmlFor={props.id} className={classNames('input-label', startDate && 'active')}>{props.placeholder}</label>
      {startDate && <input type='hidden' name={props.name} value={moment(startDate).format(backendDateFormat)} />}
    </div>
  )
}

// noinspection JSUnusedGlobalSymbols
export default DatePicker
