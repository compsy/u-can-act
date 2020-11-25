import React, { useState } from 'react'
import { DatePicker as ReactDatePicker } from 'react-datepicker'

const DatePicker = props => {
  const [startDate, setStartDate] = useState(new Date())

  return (
    <ReactDatePicker selected={startDate} onChange={date => setStartDate(date)} />
  )
}

export default DatePicker
