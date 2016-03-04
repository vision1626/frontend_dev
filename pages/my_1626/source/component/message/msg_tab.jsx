import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Tab extends BaseComponent {
  constructor() {
    super();
    this.handleTabClick = this.handleTabClick.bind(this);
  }

  handleTabClick(e){
    let me = $(e.currentTarget)[0];
    let my_class = me.className;

    if(my_class != 'current'){
      let targetMenuItem = $('.mnu_' + my_class);
      $('.m_item').removeClass('current');
      targetMenuItem.addClass('current');
      $('.menu_array').css('top',targetMenuItem.position().top + 10);
      this.props.changeView(my_class);
    }
  }

  render() {
    return (
      <div className="msg_tab">
        <dl>
          <dd onClick={this.handleTabClick} viewName="message_like" className={this.props.currentPage == 'message_like' ? 'current' : 'message_like'}><span>收到的喜欢</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_follow" className={this.props.currentPage == 'message_follow' ? 'current' : 'message_follow'}><span>收到的关注</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_comment" className={this.props.currentPage == 'message_comment' ? 'current' : 'message_comment'}><span>收到的评论</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_system" className={this.props.currentPage == 'message_system' ? 'current' : 'message_system'}><span>官方消息</span></dd>
        </dl>
      </div>
    );
  }
}
export default Tab;