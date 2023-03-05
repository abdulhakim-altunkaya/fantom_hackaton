import React from 'react';
import { useState } from 'react';
import {CONTRACT_ADDRESS} from "./ContractAddress";

function RAConnectMet() {

  let[displayStatus2, setDisplayStatus2] = useState(false);
  let contractAddress = CONTRACT_ADDRESS;
  
  const {ethereum} = window;

  let[account, setAccount] = useState("");
  const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
      setDisplayStatus2(true);
    } else {
      alert("install Metamask on your browser");
    }
  }
  
  const hideDetails1 = () => {
    setDisplayStatus2(false);  
  }

  return (
    <div>
        <button className='button9' onClick={connectMetamask}>CONNECT METAMASK</button>
        {
          displayStatus2 === true ? 
            <>

            <div className='contractDetailsDiv'>
                  <span>Your Metamask Account:</span>  <br />{account} <br />
                  <span>Token Name:</span> Contractorium <br />
                  <span>Token Symbol:</span>  CONTOR <br />
                  <span>Token Cap: </span>  1000000 <br />
                  <span>Token Standard:</span>  ERC20 <br />
                  <span>Token Decimals:</span>  18 <br />
                  <span>Token Network:</span>  Fantom Testnet <br />
                  <span>Token Contract Account:</span> {contractAddress} <br />  
            </div>
            <button className='hidingButton' onClick={hideDetails1}>Hide Details</button> <br />
            </>
          :
          <></>
        }

    </div>
  )
}

export default RAConnectMet