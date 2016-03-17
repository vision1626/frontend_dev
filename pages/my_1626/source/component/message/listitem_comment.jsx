import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import UserPopup from './listitem_user_popup.jsx';
import * as util from '../../script/util.jsx';

class MessageListItem extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseOver = this.handlerMouseOver.bind(this);
  }

  handlerMouseOver(e) {
    let all_popup = $('.msg_user_popup');
    let my_popup = $(this.refs.userPopup.refs.popup);
    all_popup.hide();
    my_popup.fadeIn(100);
    my_popup.css('left',e.currentTarget.offsetLeft+((e.currentTarget.offsetWidth/2)-17));
    my_popup.css('top',e.currentTarget.offsetTop+30);
  }

  render() {
    let md = this.props.data;

    let comment_traget = null;
    if (md.is_comment == 1){
      comment_traget =
        <div className="mli_product_info">
          <a href={md.url} target="_blank">
            <img src={md.img} alt={decodeURIComponent(md.goods_name)} />
            <span>{decodeURIComponent(md.goods_name)}</span>
          </a>
        </div>;
    } else {
      comment_traget =
        <div className="mli_comment_info">
          <a href={md.url} target="_blank">
            <label>{decodeURIComponent(md.parent_content)}</label>
          </a>
        </div>;
    }

    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        <div className="mli_username">
          <a onMouseOver={this.handlerMouseOver} onMouseOut={this.handlerMouseOut} href={['/u/talk-',md.uid,'.html'].join('')} target="_blank" >{md.user_name}</a>
          <span>{md.is_comment == 1 ? '评论我的单品' : '回复我的评论'}</span>
        </div>
        <div className="mli_comment_content">
          <span>{decodeURIComponent(md.content)}</span>
        </div>
        {comment_traget}
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
        <UserPopup ref="userPopup" Name={md.user_name} Img={md.img_thumb} Introduce={md.introduce} Follows={md.follows} Fans={md.fans} FollowState={md.is_follow} UID={md.uid} MyID={window.myid}/>
      </dd>
    );
  }
}
export default MessageListItem;