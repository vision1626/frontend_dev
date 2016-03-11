import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Boards extends BaseComponent {
  constructor() {
    super()
    this.userStatistics.like_total.share_count = this.userStatistics.like_total.share_count ? 
      this.userStatistics.like_total.share_count : 0;
    this.userStatistics.like_total.dapei_count = this.userStatistics.like_total.dapei_count ? 
      this.userStatistics.like_total.dapei_count : 0;
  };

  render() {
    return (
      <div className="boards">
        <div className="board-i">
          <h5>{this.userInformation.user_name}</h5>
          <div className="profile-progress">
            <span>资料完整度：</span>
            <span className="progress-bar" style={{backgroundImage: 'linear-gradient(90deg, grey, grey ' + 
              this.userStatistics.infomation_degree + '%, white 0)'}}></span>
            <span>{this.userStatistics.infomation_degree + '%'}</span>
          </div>
          <a href="/settings">立即完善</a>
        </div>
        
        <div className="board-ii">
          <ul>
            <li>
              <a href="/u/dashboard"><i className="icon icon-news" /></a>
              <p className="us-count">{this.userStatistics.dynamic_count}</p>
              <p className="us-name">动态</p>
            </li>
            <li>
              <a href="/u/fav"><i className="icon icon-heart" /></a>
              <p className="us-count">{this.userStatistics.like_total.share_count +
                    this.userStatistics.like_total.dapei_count}</p>
              <p className="us-name">喜欢</p>
            </li>
            <li>
              <a href="/u/talk"><i className="icon icon-publish" /></a>
              <p className="us-count">{this.userStatistics.publish_total}</p>
              <p className="us-name">发布</p>
            </li>
          </ul>
        </div>
        
        <div className="board-iii">
          <ul>
            <li>
              <a href="http://www.1626buy.cn/user/act-order_list.html"><i className="icon icon-publish" /></a>
              <p className="od-count">{this.userOrder.unpay_count}</p>
              <p className="od-name">待付款</p>
            </li>
            <li>
              <a href="http://www.1626buy.cn/user/act-order_list-status-3.html"><i className="icon icon-publish" /></a>
              <p className="od-count">{this.userOrder.shipped_count}</p>
              <p className="od-name">待收货</p>
            </li>
          </ul>
        </div>
      </div>
    );
  };

}

export default Boards;