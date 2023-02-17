import React, { useState } from 'react'

function LowForm() {
  let[contractCode, setContractCode] = useState("");



  return (

    <div>

      <h2>SUBMIT YOUR CONTRACT</h2>
      <p>Before submitting the contract, please make sure you upload only one contract at a time. Do not upload multiple contracts.
      </p>
      <form className='contractSubmitForm'>
          <textArea type="text" value={contractCode} onChange={ e => setContractCode(e.target.value) } required></textArea>
          <input type="submit" value="Send" className='button-87'/>
      </form>
      <p>{contractCode}</p>

    </div>
  )
}

export default LowForm;

