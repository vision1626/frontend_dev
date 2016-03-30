import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class VerificationForm extends BaseComponent {
  constructor() {
    super();
    this.closeForm = this.closeForm.bind(this);
  }

  closeForm(e){
    util.closeAccountVerificationForm();
  }

  render() {
    return (
      <div className="account_verification_form">
        <div className="verification_title">
          <span className="parent_name" onClick={this.closeForm}></span>
          <span>/</span>
          <span className="form_title">设置手机</span>
          <i className="icon icon-closepop"  onClick={this.closeForm} />
        </div>
        <div className="verification_content"></div>
      </div>
    );
  }
}
export default VerificationForm;