import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Boards from './boards.jsx'
import Orders from './orders.jsx';
import Follows from './follows.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name : "summary",
      step: 0, //1:Flashbuy 2:Order 3:Follows
      loadingFlashbuy : false,
      loadedFlashbuy : false,
      flashbuyDate : [],
      loadingOrder : false,
      loadedOrder : false,
      orderData : [],
      loadingFollows : false,
      loadedFollows : false,
      followsData : []
    }
  }

  componentDidMount() {
    this.setState({
      step: 1
    });
  }

  componentDidUpdate(){
    switch (this.state.step){
      case 1:
        if (!this.state.loadingFlashbuy && !this.state.loadedFlashbuy) {
          this.setState({
            loadingFlashbuy: true
          });

          let flashbuy_count = {
            unpay_count : 0,
            shipped_count : 0
          };
          $.ajax ({
            url: SITE_URL + "services/service.php",
            type: "GET",
            data: {m: 'home', a: 'get_order_count', ajax: 1},
            cache: false,
            async: false,
            dataType: "json",
            success: function (result) {
              if (parseInt(result.status) == 1) {
                flashbuy_count.shipped_count = result.data.unpay_count;
                flashbuy_count.shipped_count = result.data.shipped_count;
              }
              this.setState({
                step : 2,
                loadingFlashbuy : false,
                loadedFlashbuy : true,
                flashbuyDate : flashbuy_count
              });
            }.bind(this),
            error: function (xhr, status, err) {
              util.showError('get_order_count', status, err);
              this.setState({
                step : 2,
                loadingFlashbuy : false,
                loadedFlashbuy : true
              });
            }.bind(this)
          });
        }
        break;
      case 2:
        if (!this.state.loadingOrder && !this.state.loadedOrder) {
          this.setState({
            loadingOrder: true
          });
          let order_data = [];
          $.ajax ({
            url: SITE_URL + "services/service.php",
            type: "GET",
            data: {m: 'home', a: 'get_order_list', ajax: 1, limit: 3},
            cache: false,
            async: false,
            dataType: "json",
            success: function (result) {
              if (parseInt(result.status) == 1) {
                order_data = result.data
              }
              this.setState({
                step: 3,
                loadingOrder: false,
                loadedOrder: true,
                orderData: order_data
              });
            }.bind(this),
            error: function (xhr, status, err) {
              util.showError('get_order_list', status, err);
              this.setState({
                step: 3,
                loadingOrder: false,
                loadedOrder: true
              });
            }.bind(this)
          });
        }
        break;
      case 3:
        if (!this.state.loadingFollows && !this.state.loadedFollows) {
          this.setState({
            loadingFollows: true
          });
          let follows_data = [];
          $.ajax ({
            url: SITE_URL + "services/service.php",
            type: "GET",
            data: {m: 'u', a: 'get_dashboard_ajax', ajax: 1, limit: 2},
            cache: false,
            async: false,
            dataType: "json",
            success: function (result) {
              if (result.data) {
                follows_data = result.data
              }
              this.setState({
                step: 3,
                loadingFollows: false,
                loadedFollows: true,
                followsData: follows_data
              });
            }.bind(this),
            error: function (xhr, status, err) {
              util.showError('get_dashboard_ajax', status, err);
              this.setState({
                step: 3,
                loadingFollows: false,
                loadedFollows: true
              });
            }.bind(this)
          });
        }
        break;
    }
  }

  render() {
    let display ;
    if (this.props.currentPage == this.state.Name){
      display = 'block';
    } else {
      display = 'none';
    }

    return (
      <div className='summary' style={{display:display}}>
        <h3>个人中心</h3>
        <Boards data={this.state.flashbuyDate} />
        <Orders data={this.state.orderData} />
        <Follows data={this.state.followsData} />
      </div>
    );
  }
}

export default Entity;
