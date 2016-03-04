import React from 'react';
import {render} from 'react-dom';

import * as util from '../script/util.jsx';
import UserHead from '../component/menu/mymenu_user_head.jsx';
import Summary from '../component/menu/mymenu_summary.jsx';
import Flashbuy from '../component/menu/mymenu_my_flashbuy.jsx';
import Dashboard from '../component/menu/mymenu_my_dashboard.jsx';
import Message from '../component/menu/mymenu_my_message.jsx';
//import Wallet from '../component/menu/mymenu_my_wallet.jsx';
import Account from '../component/menu/mymenu_my_account.jsx';

import My_Order from '../component/order/my_order.jsx';
import My_Summery from '../component/summary/summary.jsx';
import My_Message from '../component/message/message.jsx';

require('../less/layout.less');

class Layout extends React.Component {
  constructor() {
    super();
    this.init();
    this.state = {
      currentPage : 'summary'
    }
  }

  init() {
    if (window.user_information_string != ''){
      window.user_information = $.parseJSON(window.user_information_string);
    }
    if (window.user_statistics_string != ''){
      window.user_statistics = $.parseJSON(window.user_statistics_string);
    }
    if (window.user_order_string != ''){
      window.user_order = $.parseJSON(window.user_order_string);
    }
  }

  changeView(view){
    this.setState({currentPage: view});
  }

  render () {
    let mySummery = <My_Summery currentPage={this.state.currentPage} />;
    let myOrder = <My_Order currentPage={this.state.currentPage} />;

    let myMssage = <My_Message currentPage={this.state.currentPage} changeView={this.changeView.bind(this)} />;

    let currentView;
    switch (this.state.currentPage){
      case 'summary':
        currentView = mySummery;
        break;
      case 'message_like':
        currentView = myMssage;
        break;
      case 'message_follow':
        currentView = myMssage;
        break;
      case 'message_comment':
        currentView = myMssage;
        break;
      case 'message_system':
        currentView = myMssage;
        break;
      default:
        currentView = mySummery;
    }

    return (
      <div className="layout">
        <div className="my_menu">
          <div className="menu_array"></div>
          <UserHead />
          <Summary changeView={this.changeView.bind(this)} />
          <Flashbuy changeView={this.changeView.bind(this)} />
          <Dashboard />
          <Message changeView={this.changeView.bind(this)} />
          <Account changeView={this.changeView.bind(this)} />
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