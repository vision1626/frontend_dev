import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name : "message",
      Classify : "" //like,follow,comment,system
    }
  }

  build(){
    alert('building msg');
  }

  //componentDidMount(){
  //  alert('aaa');
  //}

  render() {
    let display ;
    let subtitle = '';
    if (this.props.currentPage.indexOf(this.state.Name) > -1){
      switch (this.props.currentPage){
        case 'message_like':
          subtitle = '收到的喜欢';
          break;
        case 'message_follow':
          subtitle = '收到的关注';
          break;
        case 'message_comment':
          subtitle = '收到的评论';
          break;
        case 'message_system':
          subtitle = '官方消息';
          break;
      }
      this.build();
      display = 'block';
    } else {
      display = 'none';
    }

    return <div style={{display:display}}>
      <h3>我的消息</h3>
      <h5>{subtitle}</h5>
    </div>
  }
}

export default Entity;