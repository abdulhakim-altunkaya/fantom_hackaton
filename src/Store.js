import { create } from "zustand";



export const useAccount = create( () => (
    {number: "Hello from Zustand"}
) )



export const useAccount = create((set, get) => (

    {
        number: "Hello from Zustand",
        connectContract = () => set((state) => ({number: state.number + 1}))
    }
   
))