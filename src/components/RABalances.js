import React, { useState } from 'react';
import { useAccount } from '../Store';

function RABalances() {

    const zustandContract = useAccount(state => state.contract);
    let[displayStatus4, setDisplayStatus4] = useState(false);
    let[buttonLoading4, setButtonLoading4] = useState(false);

    let[myBalance, setMyBalance] = useState("");
    let[totalMinted, setTotalMinted] = useState("");
    let[treasury, setTreasury] = useState("");

    const getBalances = async () => {
        setButtonLoading4(true);
        const data1 = await zustandContract.getYourBalance();
        const data2 = await zustandContract.getCBalToken();
        const data3 = await zustandContract.getTotalSupply();
        const data1a = data1.toString();
        const data2a = data2.toString();
        const data3a = data3.toString();
        setMyBalance(data1a);
        setTreasury(data2a);
        setTotalMinted(data3a);
        setDisplayStatus4(true);
        setButtonLoading4(false);
    }

    const hideDetails2 = () => {
        setDisplayStatus4(false);
    }

    return (
        <> 
            {
                buttonLoading4 === false ? 
                    <button className='button9' onClick={getBalances}>GET BALANCES</button>
                :
                    <button className='button9' disabled >Getting...</button>
            }
            
            {displayStatus4 === true ? 
                <>
                    <div>            
                        <span><strong>Your CONTOR balance:</strong> {myBalance}</span> <br />
                        <span><strong>Contractorium Treasury:</strong> {totalMinted}</span> <br />
                        <span><strong>Total Minted CONTOR until now:</strong> {treasury}</span>
                    </div>
                    <button className='hidingButton' onClick={hideDetails2}>Hide Details</button> <br />
                </>
            :
                <></>
            }
        </>
    )
}

export default RABalances