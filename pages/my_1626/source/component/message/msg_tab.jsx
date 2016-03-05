import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Tab extends BaseComponent {
  constructor() {
    super();
    this.handleTabClick = this.handleTabClick.bind(this);
    this.handleMarkAllRead = this.handleMarkAllRead.bind(this);
  }

  handleTabClick(e){
    let me = $(e.currentTarget)[0];
    //let my_class = me.className;

    if(!$(me).hasClass('current')){
      //let targetMenuItem = $('.mnu_' + my_class);
      //$('.m_item').removeClass('current');
      //targetMenuItem.addClass('current');
      //$('.menu_array').css('top',targetMenuItem.position().top + 10);
      //$('.msg_tab_slider').css('left',e.currentTarget.offsetLeft);
      util.setArrayPosition(this.props.currentPage);
      this.props.changeView(me.classList[2]);
    }
  }

  handleMarkAllRead(e){
    this.props.markAllRead(this.props.currentPage);
  }

  render() {
    util.setArrayPosition(this.props.currentPage,true);
    return (
      <div className="msg_tab">
        <dl>
          <dd onClick={this.handleTabClick} viewName="message_like" className={this.props.currentPage == 'message_like' ? 'mt_item tab_message_like current' : 'mt_item tab_message_like message_like'}><span>收到的喜欢</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_follow" className={this.props.currentPage == 'message_follow' ? 'mt_item tab_message_follow current' : 'mt_item tab_message_follow message_follow'}><span>收到的关注</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_comment" className={this.props.currentPage == 'message_comment' ? 'mt_item tab_message_comment current' : 'mt_item tab_message_comment message_comment'}><span>收到的评论</span></dd>
          <dd onClick={this.handleTabClick} viewName="message_system" className={this.props.currentPage == 'message_system' ? 'mt_item tab_message_system current' : 'mt_item tab_message_system message_system'}><span>官方消息</span></dd>
        </dl>
        <div onClick={this.handleMarkAllRead} className="mark_all_read">全部标为已读</div>
        <div className="msg_tab_slider"></div>
      </div>
    );
  }
}
export default Tab;