import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
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
          <dd className="m_item">
            <a>潮品动态</a>
            <span className="m_number">{this.userStatistics.dynamic_count}</span>
          </dd>
          <dd className="m_item">
            <a>我的喜欢</a>
          </dd>
          <dd className="m_item">
            <a>我的发布</a>
          </dd>
        </dl>
      </div>
    );
  }
}

export default M_Dashboard;