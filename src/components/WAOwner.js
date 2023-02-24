import React, { useState } from 'react'
import { ethers } from 'ethers';
import {CONTRACT_ABI} from "./ContractABI";
import {CONTRACT_ADDRESS} from "./ContractAddress";



function WAOwner() {

    let[displayStatus3, setDisplayStatus3] = useState(false);
    const displayContent3 = () => {
        setDisplayStatus3(!displayStatus3);
    }

    let[disableButton3, setDisableButton3] = useState(false);

    let contract;
    let signer;
    let provider;

    const connectContract = async () => {
        provider = new ethers.providers.Web3Provider(window.ethereum);
        signer = provider.getSigner();
        contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
    }

    const replenishTreasure = async () => {
        setDisableButton3(true);
        await connectContract();
        const txResponse = await contract.replenishTreasury();
        await txResponse.wait();
        setDisableButton3(false);
    }

  return (
    <div>
      <button className='button9' onClick={displayContent3}>OWNER OPERATIONS</button>
      {displayStatus3 === true ? 
           <p>
            {disableButton3 === true ?
              <button onClick={replenishTreasure} disabled className='button-85'>REPLENISHING...</button>
              :
              <button onClick={replenishTreasure} className="button-85">Replenish Treasure</button>
            } 
          </p> 
          :
          <></>
      }

    </div>
  )
}

export default WAOwner