import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Orders extends BaseComponent {
  constructor() {
    super()
    this.state = { orders: {} }
  }

  componentWillMount() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(orders) {
        this.setState({orders: orders.data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  }

  render() {
    let rows = [];
    if (this.state.orders != {}) {
      for (var i = 0; i < this.state.orders.length; i++) {
        rows.push(<Order order={this.state.orders[i]} key={i}/>)
      }
    }
    return (
      <div className="orders">
        <h5>
          <i className="icon icon-flashbuy" />
          我的潮闪购订单
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
    return (
      <tr>
        <td>
          <img src={this.props.order.thumb_url} />
        </td>
        <td>
          <p>{'订单号' + this.props.order.order_sn}</p>
          <p>{this.props.order.add_time}</p>
        </td>
        <td>
          <p>{'¥' + this.props.order.total_fee}</p>
        </td>
        <td>
          <p>{this.props.order.order_status}</p>
        </td>
      </tr>
    )
  }
}
export default Orders;