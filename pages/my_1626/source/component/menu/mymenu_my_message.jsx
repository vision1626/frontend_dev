import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Message extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="m_component my_flashbuy">
        <div className="m_title">
          <i className="icon icon-comment"/>
          <span>我的消息</span>
        </div>
        <dl className="m_items">
          <MenuItem text="收到的喜欢" classname="my_msg_like" count={this.userStatistics.msg_like_count} />
          <MenuItem text="收到的关注" classname="" count={this.userStatistics.msg_follow_count} />
          <MenuItem text="收到的评论" classname="" count={this.userStatistics.msg_comment_count} />
          <MenuItem text="官方消息" classname="" count={this.userStatistics.msg_system_count} />
        </dl>
      </div>
    );
  }
}

export default M_Message;