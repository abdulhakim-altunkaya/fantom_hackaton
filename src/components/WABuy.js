import React from 'react';
import { useState } from 'react';
import { useAccount } from "../Store.js";
/* global BigInt */

function WABuy() {
  const zustandContract = useAccount(state => state.contract);

  let[displayStatus1, setDisplayStatus1] = useState(false);
  let[disableButton, setDisableButton] = useState(false);

  const displayContent1 = () => {
    setDisplayStatus1(!displayStatus1);
  }

  const handlePurchase = async () => {
    setDisableButton(true);
    let finalAmount = BigInt(1*(10**18));
    const txResponse = await zustandContract.buyToken({value: finalAmount});
    await txResponse.wait();
    setDisableButton(false);
  }

  return (
    <div>
      <button className='button9' onClick={displayContent1}>TOKEN OPERATIONS</button>
      {displayStatus1 === true ? 
          <p>
            1. You can buy 12 CONTOR tokens for 1 FTM by clicking the "BUY 12 CONTOR" button below. <br />
            2. After clicking the button, confirm Metamask promt. <br />
            3. Then go to your Metamask and click on "Import Tokens" <br />
            4. Copy paste CONTOR address to the "Token contract address" area and click on "Add Custom Token" <br /> <br />
            {disableButton === true ?
              <button disabled className='button-85'>PURCHASING TOKENS...</button>
              :
              <button onClick={handlePurchase} className="button-85">BUY 12 CONTOR</button>
            } 
          </p> 
          :
          <></>
      }

    </div>
  )
}

export default WABuy