import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
class M_FlashBuy extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div className="m_component my_flashbuy">
        <div className="m_title">
          <i className="icon icon-flashbuy"/>
          <span>我的潮闪购</span>
        </div>
        <dl className="m_items">
          <dd className="m_item">
            <a>我的订单</a>
            <span className="m_number">{this.userOrder.unpay_count}</span>
          </dd>
          <dd className="m_item">
            <a>退款管理</a>
          </dd>
          <dd className="m_item">
            <a>优惠券</a>
          </dd>
          <dd className="m_item">
            <a>收货地址管理</a>
          </dd>
        </dl>
      </div>
    );
  }
}

export default M_FlashBuy;