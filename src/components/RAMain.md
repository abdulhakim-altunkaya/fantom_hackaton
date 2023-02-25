import React from 'react';
import RAConnectMet from "./RAConnectMet.js";
import RABalances from "./RABalances.js";
import { contract } from "./ContractConnect";
import {useAccount} from "../Store";


function RAMain() {
  const zustandData = useAccount( state => state.number);

  const loadContract = async () => {
    const txResponse = await contract.getCAddress();
    console.log(txResponse);
  }

  return (
    <div className='ReadAreaMain'>
        <RAConnectMet />
        <button onClick={loadContract}>adfwewefwefwefweffwef</button>
        <p>Token Supply:  </p>
        <p>{zustandData}</p>
        <RABalances />
    </div>
  )
}

export default RAMain