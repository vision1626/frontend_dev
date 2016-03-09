import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import RichTextBox from './listitem_rich_text.jsx';
import * as util from '../../script/util.jsx';

class MessageListItem extends BaseComponent {
  constructor() {
    super();
    this.handlerReadDetail = this.handlerReadDetail.bind(this);
  }

  handlerReadDetail(e){}

  render() {
    let md = this.props.data;
    let title = decodeURIComponent(md.title);
    let summary_text = decodeURIComponent(md.message_text);
    let item_content;
    if (title == '系统通知'){
      item_content =
        <div className="mli_system_content">
          <div className="mli_icon">
            <i className="icon icon-notification" />
          </div>
          <div className="mil_system_text">
            <h3>{title}</h3>
            <RichTextBox text={md.message}/>
          </div>
        </div>
    } else {
      item_content =
        <div className="mli_system_content">
          <div className="mli_icon">
            <i className="icon icon-news" />
          </div>
          <div className="mil_system_text">
            <h3>{title}</h3>
            <div className="summary_text">{summary_text}</div>
            <div className="read_detail">
              <span onClick={this.handlerReadDetail}>查看详情</span>
            </div>
          </div>
        </div>
    }

    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        {item_content}
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
      </dd>
    );
  }
}
export default MessageListItem;