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
          <h4>{this.userInformation.user_name}</h4>
          <div>
            <span>资料完整度：</span>
            <span>{this.userStatistics.infomation_degree}</span>
          </div>
          <a>立即完善</a>
        </div>
        
        <div className="board-ii">
          <ul>
            <li>
              <i className="icon icon-news" />
              <p>{this.userStatistics.dynamic_count}</p>
              <p>动态</p>
            </li>
            <li>
              <i className="icon icon-heart" />
              <p>{this.userStatistics.like_total.share_count +
                    this.userStatistics.like_total.dapei_count}</p>
              <p>动态</p>
            </li>
            <li>
              <i className="icon icon-publish" />
              <p>{this.userStatistics.publish_total}</p>
              <p>动态</p>
            </li>
          </ul>
        </div>
        
        <div className="board-iii">
          <ul>
            <li>
              <i className="icon icon-publish" />
              <p>{this.userOrder.unpay_count}</p>
              <p>待付款</p>
            </li>
            <li>
              <i className="icon icon-publish" />
              <p>{this.userOrder.shipped_count}</p>
              <p>待收货</p>
            </li>
          </ul>
        </div>
      </div>
    );
  };

}

export default Boards;