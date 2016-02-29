import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
import MenuItem from 'mymenu_item.jsx';
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
          <dd className="m_item">
            <a>
              收到的喜欢
              <span className="m_number">{this.userStatistics.msg_like_count}</span>
            </a>
          </dd>
          <MenuItem text="收到的喜欢收到的喜欢"/>
          <dd className="m_item">
            <a>
              收到的喜欢
              <span className="m_number">{this.userStatistics.msg_follow_count}</span>
            </a>
          </dd>
          <dd className="m_item">
            <a>
              收到的喜欢
              <span className="m_number">{this.userStatistics.msg_comment_count}</span>
            </a>
          </dd>
          <dd className="m_item">
            <a>
              收到的喜欢
              <span className="m_number">{this.userStatistics.msg_system_count}</span>
            </a>
          </dd>
        </dl>
      </div>
    );
  }
}

export default M_Message;