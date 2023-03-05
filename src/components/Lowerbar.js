import React from 'react';
import { Route, Routes } from  "react-router-dom";

import LowForm from "./LowForm";
import LowMember from "./LowMember";


function Lowerbar() {
  return (
      <div className='lowerbarDiv'>
          <Routes>
            <Route path="/membership" element={ <LowMember /> } />
            <Route path="/" element={ <LowMember /> } />
            <Route path="/audit" element={ <LowForm /> } />
          </Routes>
      </div>
  )
}

export default Lowerbar