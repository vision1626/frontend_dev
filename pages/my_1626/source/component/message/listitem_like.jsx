require('react-dom');
import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import UserPopup from './listitem_user_popup.jsx';
import * as util from '../../script/util.jsx';

class MessageListItem extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseOver = this.handlerMouseOver.bind(this);
    this.handlerMouseOut = this.handlerMouseOut.bind(this);
  }

  handlerMouseOver(e) {
    let all_popup = $('.msg_user_popup');
    //let my_popup = $(e.currentTarget).parent().parent().find('.msg_user_popup');
    let my_popup = $(this.refs.userPopup.refs.popup);
    all_popup.hide();
    my_popup.fadeIn(100);
    my_popup.css('left',e.currentTarget.offsetLeft+((e.currentTarget.offsetWidth/2)-17));
    my_popup.css('top',e.currentTarget.offsetTop+30);
  }

  handlerMouseOut(e){
    //let popup = $(e.currentTarget).parent().parent().find('.msg_user_popup');
    //popup.fadeOut(100);
  }

  render() {
    let md = this.props.data;
    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        <div className="mli_username">
          <a onMouseOver={this.handlerMouseOver} onMouseOut={this.handlerMouseOut} href={['/u/talk-',md.uid,'.html'].join('')} target="_blank" >{md.user_name}</a>
          <span>喜欢您的潮品</span>
        </div>
        <div className="mli_product_info">
          <img src={md.img} alt={decodeURIComponent(md.goods_name)} />
          <span>{decodeURIComponent(md.goods_name)}</span>
        </div>
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
        <UserPopup ref="userPopup" Name={md.user_name} Img={md.img_thumb} Introduce={md.introduce} Follows={md.follows} Fans={md.fans} FollowState={md.is_follow} UID={md.uid} MyID={window.myid}/>
      </dd>
    );
  }
}
export default MessageListItem;