import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Pagination from '../common/pagination.jsx';
import Loading from './../common/loading.jsx';
import Tab from './msg_tab.jsx';
import * as util from '../../script/util.jsx';

require('../../less/message.less');

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name: "message",
      Classify: '', //like,follow,comment,system
      recordCount: 1,
      currentPage: 1,
      data: [],
      dataLoading : false,
      dataLoaded : false ,
      dataTime: null
    }
    this.markAllRead = this.markAllRead.bind(this);
  }

  pageTurning(page){
    this.setState({
      currentPage: page,
      dataLoaded : false 
    });
  }

  getInClassify(){
    let page_name = this.props.currentPage;
    return page_name.substring(page_name.indexOf('_')+1,page_name.length)
  }

  componentDidMount(){
    this.setState({Classify : this.getInClassify()});
  }

  componentDidUpdate(){
    let my_classify = this.state.Classify;
    let in_classify = this.getInClassify();
    if (my_classify != in_classify){
      this.setState({
        Classify: in_classify,
        recordCount: 1,
        currentPage: 1,
        data: [],
        dataLoading : true,
        dataLoaded : false,
        dataTime: null
      });
    } else {
      if (!this.state.dataLoaded) {
        this.queryMessageData();
      }
    }
  }

  markAllRead(currentPage) {
    alert('未做完錒 咪点人家啦 ');
  }

  queryMessageData(){
    let limit = 5;
    let page = this.state.currentPage;
    let type = 1;
    switch (this.state.Classify){
      case 'like':
        type = 1;
        break;
      case 'follow':
        type = 3;
        break;
      case 'comment':
        type = 2;
        break;
      default: //'sysetm'
        type = 4;
    }
    $.ajax({
      url: '/services/service.php',
      type: 'get',
      data : {'m':'home', 'a':'get_message_ajax', 'limit':limit , 'p': page ,'type': type},
      cache: false,
      dataType: 'json',
      success: function(result) {
        if (result.status == 1) {
          this.setState({
            orders: result.data,
            dataLoading : false,
            dataLoaded: true,
            recordCount: result.count,
            dataTime: new Date()
          });
        } else {
          util.showError('get_message_ajax',result.status,msg);
        }
      }.bind(this),
      error: function(xhr, status, err) {
        util.showError('get_message_ajax',status,err);
      }.bind(this)
    });
  }

  render() {
    let whole;
    let msg_content;
    let msg_pagination;
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

    //for (let i =0 ; i < this.state.data.length ; i++ ){
    //  let d = this.state.data[i];
    //  substance.push(<span>{i}</span>);
    //}
    if (this.state.dataLoading){
      msg_content = <Loading />;
      msg_pagination = '';
    } else {
      msg_content = <span>done</span>;
      msg_pagination = <Pagination recordCount={this.state.recordCount} currentPage={this.state.currentPage} pageTurning={this.pageTurning.bind(this)} />
    }

    whole =
    <div style={{display:display}}>
      <h3>我的消息</h3>
      <div className="msg_container">
        <Tab classify={this.state.Classify} currentPage={this.props.currentPage} changeView={this.props.changeView.bind(this)} markAllRead={this.markAllRead} />
        <div className="msg_content">
          {msg_content}
        </div>
        {msg_pagination}
      </div>
    </div>;

    return whole
  }
}

export default Entity;