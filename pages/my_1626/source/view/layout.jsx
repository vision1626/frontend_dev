import React from 'react';
import {render} from 'react-dom';

import * as util from '../script/util.jsx';
import UserHead from '../component/menu/mymenu_user_head.jsx';
import Summary from '../component/menu/mymenu_summary.jsx';
import Flashbuy from '../component/menu/mymenu_my_flashbuy.jsx';
import Dashboard from '../component/menu/mymenu_my_dashboard.jsx';
import Message from '../component/menu/mymenu_my_message.jsx';
import Wallet from '../component/menu/mymenu_my_wallet.jsx';
import Account from '../component/menu/mymenu_my_account.jsx';

import My_Order from '../component/order/my_order.jsx';

require('../less/layout.less');

class Layout extends React.Component {
  constructor() {
    super();
    this.init();
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

  render () {
    return (
      <div className="layout">
        <div className="my_menu">
          <div className="menu_array"></div>
          <UserHead />
          <Summary />
          <Flashbuy />
          <Dashboard />
          <Message />
          <Wallet />
          <Account />
        </div>
        <div className="my_content_container">
          <My_Order className="component_order" />
        </div>
      </div>
    );
  }
}

render(
  <Layout />,
  document.getElementById('wrapper')
);