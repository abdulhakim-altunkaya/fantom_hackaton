import React from 'react';
import { useState } from 'react';
import { useAccount } from "../Store.js";
/* global BigInt */

function WABuy() {
  const zustandContract = useAccount(state => state.contract);


  let[displayStatus1, setDisplayStatus1] = useState(false);
  let[disableButton, setDisableButton] = useState(false);
  let[disableButton6, setDisableButton6] = useState(false);

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

  const handleFreeMint = async () => {
    setDisableButton6(true);
    const txResponse = await zustandContract.freeMint();
    await txResponse.wait();
    setDisableButton6(false);
  }

  return (
    <div>
      <button className='button9' onClick={displayContent1}>GET CONTOR</button>
      {displayStatus1 === true ? 
          <p>
            1. You can buy 12 CONTOR tokens for 1 FTM by clicking the "BUY 12 CONTOR" button below. <br />
            2. After clicking the button, confirm Metamask promt. <br />
            3. Then go to your Metamask and click on "Import Tokens" <br />
            4. Copy paste CONTOR address to the "Token contract address" area and click on "Add Custom Token" <br /> <br />
            
            {disableButton === true ?
              <>
                <button disabled className='button-85'>Buying...please wait</button> <br />
                <button disabled className='button-85'>Mint 1 Contor for Free</button> <br />   
              </>              
              :
              <>
                <button onClick={handlePurchase} className="button-85">Buy 12 CONTOR</button> <br />
                {disableButton6 === true ?
                  <button disabled className='button-85'>Minting...please wait</button> 
                :
                  <button onClick={handleFreeMint} className='button-85'>Mint 1 Contor for Free</button>
                }
                 
                             
              </>
            } 
          </p> 
          :
          <></>
      }

    </div>
  )
}

export default WABuy