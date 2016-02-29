import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Summary extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="m_component my_summary">
        <div className="m_title">
          <i className="icon icon-hand"/>
          <span>我的1626</span>
        </div>
        <dl className="m_items">
          <MenuItem text="个人中心" iscurrent="true" />
        </dl>
      </div>
    );
  }
}

export default M_Summary;