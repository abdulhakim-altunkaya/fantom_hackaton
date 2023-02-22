import React from 'react';
import { useState } from 'react';
import { ethers } from 'ethers';
import {CONTRACT_ABI} from "./ContractABI";
import {CONTRACT_ADDRESS} from "./ContractAddress";


function WABuy() {

  let[displayStatus1, setDisplayStatus1] = useState(false);
  let[disableButton, setDisableButton] = useState(false);

  const displayContent1 = () => {
    setDisplayStatus1(!displayStatus1);
  }

  let signer;
  let contract;
  let provider;
  const connectContract = async () => {
    /*
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
    */
  }

  const handlePurchase = async () => {
    /*
    setDisableButton(true);
    await connectContract();
    const txResponse = await contract.buyToken();
    await txResponse.wait();
    setDisableButton(false);
    */
  }

  return (
    <div>
      <button onClick={displayContent1}>TOKEN OPERATIONS</button>
      {displayStatus1 === true ? 
          <p>
            1. You can buy 12 CONTOR tokens for 1 FTM by clicking the "BUY 12 CONTOR" button below. <br />
            2. After clicking the button, confirm Metamask promt. <br />
            3. Then go to your Metamask and click on "Import Tokens" <br />
            4. Copy paste CONTOR address to the "Token contract address" area and click on "Add Custom Token" <br /> <br />
            {disableButton === true ?
              <button disabled>PURCHASING TOKENS...</button>
              :
              <button onClick={handlePurchase} disabled>BUY 12 CONTOR</button>
            } 
          </p> 
          :
          <></>
      }

    </div>
  )
}

export default WABuy