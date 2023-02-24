import React from 'react';
import RAConnectMet from "./RAConnectMet.js";
import RABalances from "./RABalances.js";

import {useAccount} from "../Store";

function RAMain() {
  const zustandData = useAccount( state => state.number)

  return (
    <div className='ReadAreaMain'>
        <RAConnectMet />
        <p>{zustandData}</p>
        <RABalances />
    </div>
  )
}

export default RAMain