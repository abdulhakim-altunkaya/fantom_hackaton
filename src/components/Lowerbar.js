import React from 'react';
import { Route, Routes } from  "react-router-dom";

import LowForm from "./LowForm";
import LowMember from "./LowMember";


function Lowerbar() {
  return (
    <div>
      <div className='lowerbarDiv'>
          <Routes>
            <Route path="/membership" element={ <LowMember /> } />
            <Route path="/audit" element={ <LowForm /> } />
          </Routes>
      </div>
    </div>
  )
}

export default Lowerbar