import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import {formatDate, getOrderStatus} from '../../script/util.jsx';

class Orders extends BaseComponent {
  constructor() {
    super();
  }

  componentWillMount() {
    //$.ajax({
    //  url: this.props.url,
    //  dataType: 'json',
    //  cache: false,
    //  success: function(orders) {
    //    if (orders.status == 1) {
    //      this.setState({orders: orders.data});
    //    }
    //  }.bind(this),
    //  error: function(xhr, status, err) {
    //    console.error(this.props.url, status, err.toString());
    //  }.bind(this)
    //});
  }

  render() {
    let dt = this.props.data;

    let rows = [];
    if (dt.length > 0) {
      for (var i = 0; i < dt.length; i++) {
        rows.push(<Order order={dt[i]} key={i}/>)
      }
    } else {
      rows.push(
        <tr key={Math.random()}>
          <td className="blank-td">
            您还没有订单哦
          </td>
        </tr>
      )
    }
    return (
      <div className="orders">
        <h5>
          <i className="icon icon-flashbuy" />
          我的潮闪购订单
          <a className="check-all" 
            href="http://www.1626buy.cn/user/act-order_list.html">
            查看全部订单
          </a>
        </h5>
        <table>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    )
  }
}

class Order extends BaseComponent {
  render() {
    let orderStatus = getOrderStatus(this.props.order.order_status,
      this.props.order.pay_status, this.props.order.shipping_status) 
    return (
      <tr>
        <td className='img-td'>
          <img src={this.props.order.thumb_url} />
        </td>
        <td className="order-sn-and-date">
          <p>{'订单号' + this.props.order.order_sn}</p>
          <p>{formatDate(+this.props.order.add_time)}</p>
        </td>
        <td className='order-price-td'>
          <p>{'¥' + this.props.order.total_fee}</p>
        </td>
        <td className='order-status-td'>
          <p>{orderStatus.text}</p>
        </td>
        <td className='order-action-td'>
          {(() => {
            if (orderStatus.action) {
              return <button className={orderStatus.className}>{orderStatus.action}</button>
            }
          })()}
        </td>
        <td className='check-td'>
          <a href={this.props.order.detail_url}>查看</a>
        </td>
      </tr>
    )
  }
}
export default Orders;