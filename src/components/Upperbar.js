import React from 'react';
import { useNavigate } from 'react-router-dom';

function Upperbar() {
    const navigate = useNavigate();

    return (
      <div className='upperbarDiv'>
        <div>
          <div className='upperbarLogoDiv'>
            <img src="logo.png" onClick={() => navigate("/")}
            alt="logo of page. You can click on it to go to main page"/>
          </div>
          <div className='upperbarButtonsDiv'>
              <span className='button6' onClick={() => navigate("/membership")}>TOKEN OPERATIONS</span>
              <span className='button6' onClick={() => navigate("/audit")}>AUDIT CONTRACT</span>
          </div>

        </div>
      </div>
    )
}

export default Upperbar