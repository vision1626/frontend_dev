import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
class UserHead extends BaseComponent {
  constructor() {
    super();
  }

  init(){
  }

  render() {
    return (
      <div className="my_base_info">
        <img className="avatar_bg" src={this.userInformation.img_thumb} alt='' />
        <img className="avatar" src={this.userInformation.img_thumb} alt={this.userInformation.user_name} />
        <i className="icon icon-edit"/>
        <div className="my_relations">
          <div className="my_relation">
            <i className="icon icon-fans-16"/>
            <span>{this.userStatistics.fans}粉丝</span>
          </div>
          <div className="my_relation">
            <i className="icon icon-following"/>
            <span>{this.userStatistics.follows}关注</span>
          </div>
        </div>
      </div>
    );
  }
}

export default UserHead;