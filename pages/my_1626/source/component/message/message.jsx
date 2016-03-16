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
import MDetail from './message_detail.jsx';
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
        wholeData : [],
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
    let limit = 0;
    let page = this.state.currentPage;
    let type = 1;
    let classify = this.state.Classify;
    switch (classify){
      case 'like':
        type = 1;
        limit = 5;
        break;
      case 'follow':
        type = 3;
        limit = 6;
        break;
      case 'comment':
        type = 2;
        limit = 4;
        break;
      default: //'sysetm'
        type = 4;
        limit = 7;
    }
    //由于后段提供的"收到评论消息"数据无法做到分页(也就是一次畀嗮所有数,所以需要前段自行分页)
    if(classify != 'comment' || (classify == 'comment' && page == 1)) {
      $.ajax({
        url: '/services/service.php',
        type: 'get',
        data: {'m': 'home', 'a': 'get_message_ajax', 'limit': limit, 'p': page, 'type': type},
        cache: false,
        dataType: 'json',
        success: function (result) {
          if (result.status == 1) {
            let data = [];
            let page_records = limit;
            let result_count = result.count;
            if (classify == 'comment'){
              if (result_count < page_records) { page_records = result_count; }
              for (let i = 0 ; i < page_records ; i ++){
                data.push(result.data[i]);
              }
            } else {
              data = result.data;
            }
            this.setState({
              wholeData: result.data,
              data: data,
              dataLoading: false,
              dataLoaded: true,
              dataPrepare: true,
              recordCount: result_count,
              dataTime: new Date()
            });
          } else {
            util.showError('get_message_ajax', result.status, msg);
          }
        }.bind(this),
        error: function (xhr, status, err) {
          util.showError('get_message_ajax', status, err);
        }.bind(this)
      });
    } else {
      let data = [];
      let whole_data = this.state.wholeData;
      let total_record = this.state.recordCount;
      //let total_page =  Math.ceil(total_record/limit);
      let start_record = (page-1)*limit;
      let end_record = start_record + limit;
      if (end_record > total_record) {end_record = total_record;}
      for (let i = start_record ; i < end_record ; i ++){
        data.push(whole_data[i]);
      }
      this.setState({
        data: data,
        dataLoading: false,
        dataLoaded: true,
        dataPrepare: true
      });
    }

  }

  render() {
    let whole;
    let limit = 0;
    let msg_content = [];
    let msg_pagination;
    let msd_data_count = this.state.recordCount;
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
              limit = 5;
              msg_content =
                <dl className="ml_like">
                  {msg_data.map(function(md){
                      return <MLikeItem key={md.create_time} data={md}/>
                      })}
                </dl>;
              break;
            case 'message_follow':
              limit = 6;
              msg_content =
                <dl className="ml_follow">
                  {msg_data.map(function(md){
                    return <MFollowItem key={md.create_time} data={md}/>
                    })}
                </dl>;
              break;
            case 'message_comment':
              limit = 4;
              msg_content =
                <dl className="ml_comment">
                  {msg_data.map(function(md){
                    return <MCommenyItem key={md.create_time} data={md}/>
                    })}
                </dl>;
              break;
            default:
              limit = 7;
              msg_content =
                <dl className="ml_system">
                  {msg_data.map(function(md){
                    return <MSystemItem key={md.create_time} data={md} recordCount={msd_data_count} pageRecords={4}/>
                    })}
                </dl>;
          }
          msg_pagination = <Pagination recordCount={this.state.recordCount} currentPage={this.state.currentPage}
                                       pageTurning={this.pageTurning.bind(this)} pageRecords={limit}/>
        } else {
          msg_content = <Loading text="还没有消息哦" />;
          msg_pagination = '';
        }
      } else {
        msg_content = <Loading text="还没有消息哦" />;
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
          <MDetail />
        </div>
        {msg_pagination}
      </div>
    </div>;

    return whole
  }
}

export default MessageEntity;