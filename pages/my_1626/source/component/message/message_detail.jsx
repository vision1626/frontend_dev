import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class MessageDetail extends BaseComponent {
  constructor() {
    super();
    this.closeDetail = this.closeDetail.bind(this);
  }

  closeDetail(e){
    util.closeMessageDetail();
  }

  render() {
    return (
      <div className="message_detail">
        <div className="message_info">
          <span className="parent_name" onClick={this.closeDetail}></span>
          <span>/</span>
          <span className="message_title"></span>
          <i className="icon icon-closepop"  onClick={this.closeDetail} />
          <div className="message_datetime">
            <span className="create_time"></span>
          </div>
        </div>
        <div className="message_content"></div>
      </div>
    );
  }
}
export default MessageDetail;