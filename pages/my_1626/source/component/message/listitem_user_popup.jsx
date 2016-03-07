import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class MessageUserPopup extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseOut = this.handlerMouseOut.bind(this);
  }

  handlerMouseOut(e){
    console.log(e);
    let popup = $(e.currentTarget);
    popup.hide();
  }

  render() {
    return (
      <div className="msg_user_popup" onMouseOut={this.handlerMouseOut}>
        <div className="popup_content">
          {this.props.Name}
        </div>
      </div>
    );
  }
}
export default MessageUserPopup;