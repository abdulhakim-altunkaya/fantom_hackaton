import React from 'react';
import { useState } from 'react';

function WABuy() {
  let [displayStatus1, setDisplayStatus1] = useState(false);

  const displayContent1 = () => {
    setDisplayStatus1(!displayStatus1);
  }
  const handlePurchase = async () => {
    
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
            <button onClick={handlePurchase}>BUY 12 CONTOR</button>
          </p> 
          :
          <></>
      }

    </div>
  )
}

export default WABuy