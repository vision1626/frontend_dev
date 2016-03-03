import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Pagination from '../common/pagination.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name : "message",
      Classify : "", //like,follow,comment,system
      recordCount : 1,
      currentPage : 1
    }
  }

  pageTurning(page){
    this.setState({currentPage: page});
  }

  addCount(){
    this.setState({recordCount: this.state.recordCount + 5});
  }

  reduceCount(){
    this.setState({recordCount: this.state.recordCount - 5});
  }

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
      //this.build();
      display = 'block';
    } else {
      display = 'none';
    }

    return <div style={{display:display}}>
      <h3>我的消息</h3>
      <h5>{subtitle}</h5>
      <span onClick={this.addCount.bind(this)}>加</span>
      <span onClick={this.reduceCount.bind(this)}>减</span>
      <Pagination recordCount={this.state.recordCount} currentPage={this.state.currentPage} pageTurning={this.pageTurning.bind(this)} />
    </div>
  }
}

export default Entity;