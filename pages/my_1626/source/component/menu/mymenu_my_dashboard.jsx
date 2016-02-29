import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
class M_Dashboard extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="m_component my_dashboard">
        <div className="m_title">
          <i className="icon icon-hand"/>
          <span>我的潮品</span>
        </div>
        <dl className="m_items">
          <MenuItem text="潮品动态" count={this.userStatistics.dynamic_count} />
          <MenuItem text="我的喜欢" />
          <MenuItem text="我的发布" />
        </dl>
      </div>
    );
  }
}

export default M_Dashboard;