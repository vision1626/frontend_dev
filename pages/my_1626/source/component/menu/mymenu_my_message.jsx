import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Message extends BaseComponent {
  constructor() {
    super();
    this.state = {
      likeCount : this.userStatistics.msg_like_count,
      followCount : this.userStatistics.msg_follow_count,
      commentCount : this.userStatistics.msg_comment_count,
      systemCount : this.userStatistics.msg_system_count
    };
  }

  render() {
    return (
      <div className="m_component my_flashbuy">
        <div className="m_title">
          <i className="icon icon-comment"/>
          <span>我的消息</span>
        </div>
        <dl className="m_items">
          <MenuItem text="收到的喜欢" classname="mnu_message_like" viewName="message_like" count={this.state.likeCount} changeView={this.props.changeView.bind(this)}/>
          <MenuItem text="收到的关注" classname="mnu_message_follow" viewName="message_follow" count={this.state.followCount} changeView={this.props.changeView.bind(this)}/>
          <MenuItem text="收到的评论" classname="mnu_message_comment" viewName="message_comment" count={this.state.commentCount} changeView={this.props.changeView.bind(this)}/>
          <MenuItem text="系统消息" classname="mnu_message_system" viewName="message_system" count={this.state.systemCount} changeView={this.props.changeView.bind(this)}/>
        </dl>
      </div>
    );
  }
}

export default M_Message;