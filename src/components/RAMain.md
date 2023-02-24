import React from 'react';
import RAConnectMet from "./RAConnectMet.js";
import RABalances from "./RABalances.js";
import { contract } from "./ContractConnect";


function RAMain() {

  const loadContract = async () => {
    const txResponse = await contract.getCAddress();
    console.log(txResponse);
  }

  return (
    <div className='ReadAreaMain'>
        <RAConnectMet />
        <button onClick={loadContract}>adfwewefwefwefweffwef</button>
        <p>Token Supply:  </p>
        <RABalances />
    </div>
  )
}

export default RAMain