import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import MenuItem from './mymenu_item.jsx';
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
          <MenuItem text="我的订单" count={this.userOrder.unpay_count} viewName="order" changeView={this.props.changeView.bind(this)}/>
          <MenuItem text="退款管理" link="#"/>
          <MenuItem text="优惠券" link="#"/>
          <MenuItem text="收货地址管理" link="#"/>
        </dl>
      </div>
    );
  }
}

export default M_FlashBuy;