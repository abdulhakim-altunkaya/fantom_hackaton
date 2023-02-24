import React, { useState } from 'react'


function RABalances() {

    let[myBalance, setMyBalance] = useState("");
    let[totalMinted, setTotalMinted] = useState("");
    let[treasury, setTreasury] = useState("");

    const getBalances = () => {
      return;
    }

    return (
        <div>
            <button onClick={getBalances}>GET BALANCES</button>
            <p>Your CONTOR balance: {myBalance}</p>
            <p>Contractorium Treasury: {totalMinted}</p>
            <p>Total Minted CONTOR until now: {treasury}</p>
        </div>
    )
}

export default RABalances