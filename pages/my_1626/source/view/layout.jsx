import React from 'react';
import {render} from 'react-dom';

import * as util from '../script/util.jsx';
import MnuUserHead from '../component/menu/mymenu_user_head.jsx';
import MnuSummary from '../component/menu/mymenu_summary.jsx';
import MnuFlashbuy from '../component/menu/mymenu_my_flashbuy.jsx';
import MnuDashboard from '../component/menu/mymenu_my_dashboard.jsx';
import MnuMessage from '../component/menu/mymenu_my_message.jsx';
//import Wallet from '../component/menu/mymenu_my_wallet.jsx';
import MnuAccount from '../component/menu/mymenu_my_account.jsx';

//import My_Order from '../component/order/my_order.jsx';
import My_Summery from '../component/summary/summary.jsx';
import My_Message from '../component/message/message.jsx';
import My_Account from '../component/account/account.jsx';

require('../less/layout.less');

class Layout extends React.Component {
  constructor() {
    super();
    this.init();
    this.state = {
      currentPage : ''
    };
    this.markRead = this.markRead.bind(this);
  }

  componentDidMount(){
    let pathname = util.getViewName(window.location.pathname);
    let pagename = util.exchangePathName(pathname);
    if (this.state.currentPage != pagename){
      this.setState({currentPage: pagename});
    }
  }

  init() {
    if (window.user_information_string != ''){
      window.user_information = $.parseJSON(window.user_information_string);
    }
    if (window.user_statistics_string != ''){
      window.user_statistics = $.parseJSON(window.user_statistics_string);
    }
    //if (window.user_order_string != ''){
    //  window.user_order = $.parseJSON(window.user_order_string);
    //}
  }

  changeView(view){
    this.setState({currentPage: view});
  }

  markRead(classify){
    let type = 0;
    switch (classify){
      case 'message_like':
        type = 1;
        break;
      case 'message_follow':
        type = 3;
        break;
      case 'message_comment':
        type = 2;
        break;
      case 'message_system':
        type = 4;
        break;
      case 'message_all':
        type = -1;
        break;
    }

    $.ajax({
      url: '/services/service.php',
      type: 'get',
      data: {'m': 'home', 'a': 'change_message_status', 'type': type},
      cache: false,
      dataType: 'json',
      success: function (result) {
        if (result.status == 1) {
          switch (classify){
            case 'message_like':
              this.refs.MnuMessage.setState({likeCount:0});
              break;
            case 'message_follow':
              this.refs.MnuMessage.setState({followCount:0});
              break;
            case 'message_comment':
              this.refs.MnuMessage.setState({commentCount:0});
              break;
            case 'message_system':
              this.refs.MnuMessage.setState({systemCount:0});
              break;
            case 'message_all':
              this.refs.MnuMessage.setState({
                likeCount:0,
                followCount:0,
                commentCount:0,
                systemCount:0
              });
              break;
          }
          this.refs.myMssage.refs.Tab.setState({
            marking : false,
            markDone : true
          });
        } else {
          util.showError('change_message_status', result.status, msg);
          this.refs.myMssage.refs.Tab.setState({marking : false});
        }
      }.bind(this),
      error: function (xhr, status, err) {
        util.showError('change_message_status', status, err);
        this.refs.myMssage.refs.Tab.setState({marking : false});
      }.bind(this)
    });
  }

  render () {
    //let mySummery = <My_Summery currentPage={this.state.currentPage} />;
    //let myMssage = <My_Message ref="myMssage" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} markRead={this.markRead} />;
    let currentView;
    switch (this.state.currentPage){
      case 'summary':
        currentView = <My_Summery currentPage={this.state.currentPage} />;
        break;
      case 'message_like':
        currentView = <My_Message ref="myMssage" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} markRead={this.markRead} />;
        break;
      case 'message_follow':
        currentView = <My_Message ref="myMssage" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} markRead={this.markRead} />;
        break;
      case 'message_comment':
        currentView = <My_Message ref="myMssage" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} markRead={this.markRead} />;
        break;
      case 'message_system':
        currentView = <My_Message ref="myMssage" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} markRead={this.markRead} />;
        break;
      case 'account':
        currentView = <My_Account ref="myAccount" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} />;
        break;
      case 'account_face':
        currentView = <My_Account ref="myAccount" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} />;
        break;
      case 'account_password':
        currentView = <My_Account ref="myAccount" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} />;
        break;
      case 'account_bind':
        currentView = <My_Account ref="myAccount" currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} />;
        break;
      default:
        currentView = <My_Summery currentPage={this.state.currentPage} />;
    }
    return (
      <div className="layout">
        <div className="my_menu">
          <div className="menu_array"></div>
          <MnuUserHead />
          <MnuSummary changeView={this.changeView.bind(this)} />
          <MnuFlashbuy changeView={this.changeView.bind(this)} />
          <MnuDashboard />
          <MnuMessage changeView={this.changeView.bind(this)} ref="MnuMessage" />
          <MnuAccount changeView={this.changeView.bind(this)} />
        </div>
        <div className="my_content_container">
          {currentView}
        </div>
      </div>
    );
  }
}

render(
  <Layout />,
  document.getElementById('wrapper')
);