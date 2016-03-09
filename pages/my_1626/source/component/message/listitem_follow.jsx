import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import UserPopup from './listitem_user_popup.jsx';
import * as util from '../../script/util.jsx';

class MessageList extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseOver = this.handlerMouseOver.bind(this);
  }

  handlerMouseOver(e) {
    let popup = $(e.currentTarget).parent().parent().find('.msg_user_popup');
    popup.fadeIn(100);
    popup.css('left',e.currentTarget.offsetLeft-5);
    popup.css('top',e.currentTarget.offsetTop);
  }

  render() {
    let md = this.props.data;
    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        <div className="mli_username">
          <a onMouseOver={this.handlerMouseOver} >{md.user_name}</a>
          <span>关注了你</span>
        </div>
        <div className="mli_user_info">
          <img src={md.img_thumb} alt={decodeURIComponent(md.user_name)} />
        </div>
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
        <UserPopup ref="userPopup" Name={md.user_name} Img={md.img_thumb} Introduce={md.introduce} Follows={md.follows} Fans={md.fans} FollowState={md.is_follow} UID={md.uid} MyID={window.myid}/>
      </dd>
    );
  }
}
export default MessageList;