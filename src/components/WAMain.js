import React from 'react';

//import WAMember from "./WAMember";
//import WALeave from "./WALeave";
import WABuy from "./WABuy";
import WAOwner from "./WAOwner";

function WAMain() {
  return (
    <div className='WriteAreaMain'>
        <WABuy />
        <WAOwner />
        {/*
        <WAMember />
        <WALeave />     
        */}

    </div>
  )
}

export default WAMain