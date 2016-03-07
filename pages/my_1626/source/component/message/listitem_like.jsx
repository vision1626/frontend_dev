require('react-dom');
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
    let popup = $(e.currentTarget).parent().parent().find('.msg_user_popup');
    popup.show();
    popup.css('left',e.currentTarget.offsetLeft);
    popup.css('top',e.currentTarget.offsetTop);
  }

  render() {
    let md = this.props.data;
    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        <div className="mli_username">
          <a onMouseOver={this.handlerMouseOver}>{md.user_name}</a>
          <span>喜欢您的潮品</span>
        </div>
        <div className="mli_product_info">
          <img src={md.img} alt={decodeURIComponent(md.goods_name)} />
          <span>{decodeURIComponent(md.goods_name)}</span>
        </div>
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
        <UserPopup ref="userPopup" Name={md.user_name}  />
      </dd>
    );
  }
}
export default MessageListItem;