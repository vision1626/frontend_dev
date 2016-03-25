import React from 'react';
import * as util from '../../script/util.jsx';

class ValidateMessage extends React.Component {
  constructor() {
    super();
    this.state = {
      show : false,
      type : 1, //1:information 2:error
      message : ''
    };
  }

  componentDidMount(){

  }

  componentDidUpdate(){

  }

  render(){
    return <div className={this.state.type == 1 ? 'validate_message message_information' : 'validate_message message_error'} style={this.state.show ? {display:'block'} : {display:'none'}}>
      <i className={this.state.type == 1 ? 'icon icon-question' : 'icon icon-warning'} />
      <span>{this.state.message}</span>
    </div>
  }
}

export default ValidateMessage