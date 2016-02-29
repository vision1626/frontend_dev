import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
class M_Summary extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="my_summary">
        <div className="m_title">
          <i className="icon icon-hand"/>
          <span>我的1626</span>
        </div>
        <dl className="m_items">
          <dd className="m_item current">
            <a>个人中心</a>
          </dd>
        </dl>
      </div>
    );
  }
}

export default M_Summary;