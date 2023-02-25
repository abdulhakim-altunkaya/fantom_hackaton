import React from 'react';
import RAConnectMet from "./RAConnectMet.js";
import RABalances from "./RABalances.js";

function RAMain() {

  return (
    <div className='ReadAreaMain'>
        <p>To use this website: <br />
          1. Make sure you have Metamask installed on your browser, <br />
          2. Make sure you are on Fantom Testnet, <br />
          3. Make sure you have Fantom test tokens.
        </p>
        <RAConnectMet />
        <RABalances />
    </div>
  )
}

export default RAMain