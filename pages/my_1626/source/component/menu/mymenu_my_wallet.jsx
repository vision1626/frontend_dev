import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Wallet extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="m_component my_wallet">
        <div className="m_title">
          <i className="icon icon-user"/>
          <span>我的钱包</span>
        </div>
        <dl className="m_items">
          <MenuItem text="我的钱包" link="#" />
        </dl>
      </div>
    );
  }
}

export default M_Wallet;