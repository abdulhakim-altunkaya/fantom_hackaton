import React from 'react';

import WAMember from "./WAMember";
import WALeave from "./WALeave";
import WABuy from "./WABuy";

function WAMain() {
  return (
    <div className='WriteAreaMain'>
        <WABuy />
        <WAMember />
        <WALeave />
    </div>
  )
}

export default WAMain