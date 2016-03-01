import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Account extends BaseComponent {
  constructor() {
    super();
  }

  tick(newState) {
    alert(newState);
  }

  render() {
    return (
      <div className="m_component my_wallet">
        <div className="m_title">
          <i className="icon icon-user"/>
          <span>我的账号</span>
        </div>
        <dl className="m_items">
          <MenuItem text="账号设置" />
        </dl>
      </div>
    );
  }
}

export default M_Account;