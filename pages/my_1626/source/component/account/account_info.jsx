import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import DropBox from '../common/dropbox.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.handlerSubmitClick = this.handlerSubmitClick.bind(this);
  }

  handlerSubmitClick(e){
    alert('save');
  }

  componentDidMount(){
    //$.Bind_City("#province","#city","0","0");
  }

  componentDidUpdate(){
    let ui = window.user_information;
    util.setArrayPosition(this.props.currentPage,true);
    let provinces = util.getProvince(3);

    this.refs.slt_province.setState({
      selectedValue : 3,
      data : provinces
    });
  }

  render() {
    let ui = window.user_information;

    return (
      <div className="user_information_form">
        <dl>
          <dt><span>昵  称</span></dt>
          <dd><input value={ui.user_name}/></dd>

          <dt><span>性  别</span></dt>
          <dd className="row_sex">
            <input type="radio" name="rdoSex" id="rdoMale" checked={parseInt(ui.gender) == 1 ? 'checked' : ''} /><label htmlFor="rdoMale">男</label>
            <input type="radio" name="rdoSex" id="rdoFemale" checked={parseInt(ui.gender) == 2 ? 'checked' : ''}/><label htmlFor="rdoFemale">女</label>
            <input type="radio" name="rdoSex" id="rdoUnknow" checked={parseInt(ui.gender) == 0 ? 'checked' : ''}/><label htmlFor="rdoUnknow">中性</label>
          </dd>
          <dt><span>生  日</span></dt>
          <dd><input value={ui.birth_year}/></dd>

          <dt><span>邮  箱</span></dt>
          <dd><input value={ui.email} /></dd>

          <dt><span>手  机</span></dt>
          <dd><input value={ui.mobile} /></dd>

          <dt><span>所在地</span></dt>
          <dd>
            <DropBox className="slt_province" ref="slt_province" key="slt_province" emptyText="选择省份" />
            <DropBox className="slt_city" ref="slt_city" key="slt_city" emptyText="选择城市" />
          </dd>

          <dt><span>个人介绍</span></dt>
          <dd className="row_introduce">
            <textarea >{ui.introduce}</textarea>
          </dd>
          <dd className="row_submit">
            <div onClick={this.handlerSubmitClick}>
              <span>保存更改</span>
            </div>
          </dd>
        </dl>
      </div>
    );
  }
}
export default Entity;