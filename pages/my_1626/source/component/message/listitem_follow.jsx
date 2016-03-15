import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import FollowButton from '../common/follow_button.jsx';
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
    let introduce = decodeURIComponent(md.introduce) ;
    let introduce_class = '';
    if (introduce == '') {
      introduce = '这个人太潮了，不屑于填写简介';
      introduce_class = ' empty';
    }
    return (
      <dd className={md.status == 0 ? 'unread' : ''}>
        <div className="mli_user_thumb">
          <a href={['/u/talk-',md.uid,'.html'].join('')} target="_blank" >
            <img src={md.img_thumb} alt={decodeURIComponent(md.user_name)} />
          </a>
        </div>
        <div className="mli_user_info">
          <div className="mli_username">
            <a onMouseOver={this.handlerMouseOver} href={['/u/talk-',md.uid,'.html'].join('')} target="_blank" >{md.user_name}</a>
            <span>关注了您</span>
          </div>
          <div className="ff_count">
            <div>
              <span>{util.formatCount(md.fans)}</span>
              <label>粉丝</label>
            </div>
            <div>
              <span>{util.formatCount(md.follows)}</span>
              <label>关注</label>
            </div>
          </div>
          <div className={'introduce' + introduce_class}>
            <label>简介: </label>
            <span>{introduce}</span>
          </div>
        </div>
        <FollowButton classname="fans__follow-btn" FollowState={md.is_follow} UID={md.uid} MyID={window.myid}/>
        <div className="mli_datetime">
          <span>{util.formatDate(md.create_time)}</span>
        </div>
      </dd>
    );
  }
}
export default MessageList;