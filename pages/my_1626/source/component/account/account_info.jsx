import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
  }

  componentDidMount(){
    $.Bind_City("#province","#city","0","0");
  }

  render() {
    util.setArrayPosition(this.props.currentPage,true);
    return (
      <div className="user_information_form">
        <dl>
          <dt><span>昵称</span></dt>
          <dd><input /></dd>

          <dt><span>性别</span></dt>
          <dd><input /></dd>

          <dt><span>生日</span></dt>
          <dd><input /></dd>

          <dt><span>邮箱</span></dt>
          <dd><input /></dd>

          <dt><span>手机</span></dt>
          <dd><input /></dd>

          <dt><span>所在地</span></dt>
          <dd>
            <select className="province" id="province"/>
            <select className="city" id="city"/>
          </dd>

          <dt><span>个人介绍</span></dt>
          <dd><input /></dd>
        </dl>
      </div>
    );
  }
}
export default Entity;