import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Tab from './acc_tab.jsx';
import Acc_Info from './account_info.jsx';
import Acc_Face from './account_face.jsx';
import Acc_Password from './account_password.jsx';
import Acc_Bind from './account_bind.jsx';
import * as util from '../../script/util.jsx';

require('../../less/account.less');

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      Name: "account",
      Classify: 'empty' //info,face,password,bind
    };
  }

  componentDidMount(){
    this.setState({Classify : this.getInClassify()});
  }

  componentDidUpdate(){
    let my_classify = this.state.Classify;
    let in_classify = this.getInClassify();
    if (my_classify != in_classify){
      this.setState({
        Classify: in_classify
      });
    } else {

    }
  }

  getInClassify(){
    let page_name = this.props.currentPage;
    let result = '';
    if (page_name == 'account'){
      result = 'info';
    } else {
      result = page_name.substring(page_name.indexOf('_')+1,page_name.length);
    }
    return result
  }

  render() {
    let whole;
    let acc_content = [];
    let display ;

    if (this.props.currentPage.indexOf(this.state.Name) > -1){
      display = 'block';
    } else {
      display = 'none';
    }

    switch (this.props.currentPage) {
      case 'account_face':
        acc_content = <Acc_Face currentPage={this.props.currentPage}  />;
        break;
      case 'account_password':
        acc_content = <Acc_Password currentPage={this.props.currentPage}  />;
        break;
      case 'account_bind':
        acc_content = <Acc_Bind currentPage={this.props.currentPage}  />;
        break;
      default:
        acc_content = <Acc_Info currentPage={this.props.currentPage}  />;
    }

    whole =
      <div style={{display:display}}>
        <h3>账号设置</h3>
        <div className="acc_container">
          <Tab ref="Tab" classify={this.state.Classify} currentPage={this.props.currentPage} changeView={this.props.changeView.bind(this)} />
          <div className="acc_content">
            {acc_content}
          </div>
        </div>
      </div>;

    return whole
  }
}
export default Entity;