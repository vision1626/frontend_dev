import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Pagination from '../common/pagination.jsx';
import Loading from './../common/loading.jsx';
import Tab from './msg_tab.jsx';
import MLikeItem from './listitem_like.jsx';
import MFollowItem from './listitem_follow.jsx';
import MCommenyItem from './listitem_comment.jsx';
import MSystemItem from './listitem_system.jsx';
//import UserPopup from './listitem_user_popup.jsx';
import * as util from '../../script/util.jsx';

require('../../less/message.less');

class MessageEntity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name: "message",
      Classify: 'empty', //like,follow,comment,system
      recordCount: 1,
      currentPage: 1,
      dataLoading : false,
      dataLoaded : false ,
      dataPrepare : false,
      dataTime: null
    };
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

  componentWillUpdate(){

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
      //if (this.state.dataPrepare && this.state.dataLoaded){
      //  this.setState({
      //    dataPrepare: false
      //  });
      //}
    }
  }

  markAllRead(currentPage) {
    alert('未做完錒 咪点人家啦 ' + currentPage);
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
            data: result.data,
            dataLoading : false,
            dataLoaded: true,
            dataPrepare: true,
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
    let msg_content = [];
    let msg_pagination;
    let msg_data = this.state.data;
    let display ;

    if (this.props.currentPage.indexOf(this.state.Name) > -1){
      display = 'block';
    } else {
      display = 'none';
    }

    //if (this.state.dataPrepare) {
    if (!this.state.dataLoading && this.state.dataLoaded) {
      if (msg_data) {
        if (msg_data.length > 0) {
          switch (this.props.currentPage) {
            case 'message_like':
              msg_content =
                <dl className="ml_like">
                  {msg_data.map(function(md){
                      return <MLikeItem key={md.create_time} data={md}/>
                      })}
                </dl>;
              break;
            case 'message_follow':
              msg_content =
                <dl className="ml_follow">
                  {msg_data.map(function(md){
                    return <MFollowItem key={md.create_time} data={md}/>
                    })}
                </dl>;
              break;
            case 'message_comment':
              msg_content =
                <dl className="ml_comment">
                  {msg_data.map(function(md){
                    return <MCommenyItem key={md.create_time} data={md}/>
                    })}
                </dl>;
              break;
            default:
              msg_content =
                <dl className="ml_system">
                  {msg_data.map(function(md){
                    return <MSystemItem key={md.create_time} data={md}/>
                    })}
                </dl>;
          }
          msg_pagination = <Pagination recordCount={this.state.recordCount} currentPage={this.state.currentPage}
                                       pageTurning={this.pageTurning.bind(this)}/>
        } else {
          msg_content = <Loading text="列表为空" />;
          msg_pagination = '';
        }
      } else {
        msg_content = <Loading text="列表为空" />;
        msg_pagination = '';
      }
    } else {
      msg_content = <Loading text="正在努力加载中..." />;
      msg_pagination = '';
    }
    //}

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

export default MessageEntity;