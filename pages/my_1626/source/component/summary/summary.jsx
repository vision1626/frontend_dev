import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Boards from './boards.jsx'
import Orders from './orders.jsx';
import Follows from './follows.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state.Name = "summary";
  }

  render() {
    let display ;
    let orders = '';
    let dashboard = '';
    if (this.props.currentPage == this.state.Name){
      display = 'block';
      orders = <Orders url='/services/service.php?m=home&a=get_order_list&limit=3' />;
      dashboard = <Follows url='/services/service.php?m=u&a=get_dashboard_ajax&ajax=1&limit=2' />;
    } else {
      display = 'none';
    }

    return (
      <div className='summary' style={{display:display}}>
        <h3>个人中心</h3>
        <Boards />
        {orders}
        {dashboard}
      </div>
    );
  }
}

export default Entity;
