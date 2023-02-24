import { create } from "zustand";
import { ethers } from 'ethers';
import {CONTRACT_ABI} from "./components/ContractABI";
import {CONTRACT_ADDRESS} from "./components/ContractAddress";

let signer;
let provider;
let contract1;

const connectContract1 = async () => {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract1 = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
}
connectContract1();

export const useAccount = create( () => (
    {
        number: "Hello from Zustand",
        contract: contract1,

    }
) )