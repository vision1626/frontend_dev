import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Tab extends BaseComponent {
  constructor() {
    super();
    this.handleTabClick = this.handleTabClick.bind(this);
  }

  handleTabClick(e){
    let me = $(e.currentTarget)[0];
    if(!$(me).hasClass('current')){
      this.props.changeView(me.classList[2]);
    }
  }

  componentDidUpdate(){

  }

  render() {
    util.setArrayPosition(this.props.currentPage,true);
    return (
      <div className="acc_tab">
        <dl>
          <dd onClick={this.handleTabClick} viewName="account" className={this.props.currentPage == 'account' ? 'mt_item tab_account current' : 'mt_item tab_account account'}><span>基本信息</span></dd>
          <dd onClick={this.handleTabClick} viewName="account_face" className={this.props.currentPage == 'account_face' ? 'mt_item tab_account_face current' : 'mt_item tab_account_face account_face'}><span>头像设置</span></dd>
          <dd onClick={this.handleTabClick} viewName="account_password" className={this.props.currentPage == 'account_password' ? 'mt_item tab_account_password current' : 'mt_item tab_account_password account_password'}><span>密码修改</span></dd>
          <dd onClick={this.handleTabClick} viewName="account_bind" className={this.props.currentPage == 'account_bind' ? 'mt_item tab_account_bind current' : 'mt_item tab_account_bind account_bind'}><span>绑定账号</span></dd>
        </dl>
        <div className="tab_slider"></div>
      </div>
    );
  }
}
export default Tab;