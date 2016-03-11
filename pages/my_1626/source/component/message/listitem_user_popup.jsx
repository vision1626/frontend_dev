import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import FollowButton from '../common/follow_button.jsx';
import * as util from '../../script/util.jsx';

class MessageUserPopup extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseEnter = this.handlerMouseEnter.bind(this);
    this.handlerMouseLeave = this.handlerMouseLeave.bind(this);
    this.state = {
      active: false
    }
  }

  handlerMouseEnter(e){
    this.setState({
      active: true
    });
  }

  handlerMouseLeave(e){
    //console.log(e);
    let popup = $(e.currentTarget);
    if (this.state.active) {
      popup.fadeOut(100);
    }
  }

  render() {
    return (
      <div ref="popup" className="msg_user_popup" onMouseEnter={this.handlerMouseEnter} onMouseLeave={this.handlerMouseLeave} >
        <div className="popup_content">
          <div className="base_info">
            <a href={['/u/talk-',this.props.UID,'.html'].join('')} target="_blank" >
              <img src={this.props.Img} alt={decodeURIComponent(this.props.Name)} />
            </a>
            <h3>{decodeURIComponent(this.props.Name)}</h3>
            <div className="ff_count">
              <div>{[util.formatCount(this.props.Fans),'粉丝'].join('')}</div>
              <div>{[util.formatCount(this.props.Follows),'关注'].join('')}</div>
            </div>
          </div>
          <div className="introduce">
            <span>{decodeURIComponent(this.props.Introduce)}</span>
          </div>
          <FollowButton classname="fans__follow-btn" FollowState={this.props.FollowState} UID={this.props.UID} MyID={this.props.MyID}/>
        </div>
        <div className="popup_array"></div>
      </div>
    );
  }
}
export default MessageUserPopup;