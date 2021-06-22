import React, { useState } from 'react'
import Main from 'GENTLE/src/Main'
import 'GENTLE/src/css/style.css'


const GentleWrapper = props => {
  const [network, setNetwork] = useState(JSON.parse(props.network))
  return (
    <div className='input-field gentle'>
      <Main
        network={network}
        setNetwork={setNetwork}
      />
      <input type='hidden' name={props.name} value={JSON.stringify(network)} />
    </div>
  )
}

// noinspection JSUnusedGlobalSymbols
export default GentleWrapper
