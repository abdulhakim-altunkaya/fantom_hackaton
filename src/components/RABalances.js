import React, { useState } from 'react';
import { useAccount } from '../Store';

function RABalances() {

    const zustandContract = useAccount(state => state.contract);
    let[displayStatus4, setDisplayStatus4] = useState(false);
    let[buttonLoading4, setButtonLoading4] = useState(false);

    let[myBalance, setMyBalance] = useState("");
    let[totalMinted, setTotalMinted] = useState("");
    let[treasuryContor, setTreasuryContor] = useState("");
    let[treasuryFTM, setTreasuryFTM] = useState("");

    const getBalances = async () => {
        setButtonLoading4(true);
        const dataRaw = await zustandContract.returnBalances();
        const dataArray = dataRaw.map( balance => (balance.toString()));
        setMyBalance(dataArray[0]);
        setTotalMinted(dataArray[3]);
        setTreasuryContor(dataArray[1]);
        setTreasuryFTM(dataArray[2]);
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
                        <span><strong>Contractorium Treasury CONTOR:</strong> {treasuryContor}</span> <br />
                        <span><strong>Contractorium Treasury FTM:</strong> {treasuryFTM}</span> <br />
                        <span><strong>Total Minted CONTOR until now:</strong> {totalMinted}</span>
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