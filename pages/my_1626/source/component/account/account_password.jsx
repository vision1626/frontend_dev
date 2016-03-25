import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import ValidateMessage from '../common/from_validate_message.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state = {
      init: true
    };
    this.handlerOldPasswordChange = this.handlerOldPasswordChange.bind(this);
    this.handlerNewPassword1Change = this.handlerNewPassword1Change.bind(this);
    this.handlerNewPassword2Change = this.handlerNewPassword2Change.bind(this);
    this.handlerSubmitClick = this.handlerSubmitClick.bind(this);
  }

  componentDidMount(){
    this.setState({
      init : false,
      saving : false,
      saved : false,
      saveTime : null
    })
  }

  componentDidUpdate() {
    util.setArrayPosition(this.props.currentPage, true);
  }

  handlerNewPassword1Change(e){

  }

  handlerNewPassword2Change(e){

  }

  handlerOldPasswordChange(e){

  }

  handlerSubmitClick(e){
    let verified = true;
    let txt_oldpassword = this.refs.txt_oldpassword;
    let txt_newpassword1 = this.refs.txt_newpassword1;
    let txt_newpassword2 = this.refs.txt_newpassword2;
    let vm_oldpassword = this.refs.vm_oldpassword;
    let vm_newpassword1 = this.refs.vm_newpassword1;
    let vm_newpassword2 = this.refs.vm_newpassword2;
    let original_information = $.parseJSON(window.user_information_string);

    if (!this.state.saving) {
      if (txt_oldpassword.value == '') {
        verified = false;
        vm_oldpassword.setState({
          show: true,
          type: 2,
          message: '请输入原密码'
        });
      } else if (txt_oldpassword.value != '' && !util.validateCharacter(txt_oldpassword.value) || !(txt_oldpassword.value.length >= 6  && txt_oldpassword.value.length <= 12)) {
        verified = false;
        vm_oldpassword.setState({
          show: true,
          type: 2,
          message: '原密码输入有误，请输入2-16个字，由中英文、数字组成。'
        });
      } else {
        vm_oldpassword.setState({
          show: false
        });
      }

      if (txt_newpassword1.value == '') {
        verified = false;
        vm_newpassword1.setState({
          show: true,
          type: 2,
          message: '请输入新密码'
        });
      } else if (txt_newpassword1.value != '' && !util.validateCharacter(txt_newpassword1.value) || !(txt_oldpassword.value.length >= 6  && txt_oldpassword.value.length <= 12)) {
        verified = false;
        vm_newpassword1.setState({
          show: true,
          type: 2,
          message: '新密码输入有误，请输入2-16个字，由中英文、数字组成。'
        });
      } else {
        vm_newpassword1.setState({
          show: false
        });
      }

      if (txt_newpassword2.value == '') {
        verified = false;
        vm_newpassword2.setState({
          show: true,
          type: 2,
          message: '请输入确认密码'
        });
      } else if (txt_newpassword1.value != txt_newpassword2.value) {
        verified = false;
        vm_newpassword2.setState({
          show: true,
          type: 2,
          message: '两次输入的密码不相同'
        });
      } else {
        vm_newpassword2.setState({
          show: false
        });
      }

      if (verified) {
        this.setState({
          saving: true
        });

        $.ajax ({
          url: SITE_URL + "services/service.php",
          type: "GET",
          data: {m: 'user', a: 'save_password', ajax: 1, oldpassword: txt_oldpassword.value, newpassword: txt_newpassword1.value, newpasswordagain: txt_newpassword2.value},
          cache: false,
          async: false,
          dataType: "json",
          success: function (result) {
            if (parseInt(result.status) == 1) {
              alert('修改成功');
            } else if (parseInt(result.status) == 2) {
              vm_oldpassword.setState({
                show: true,
                type: 2,
                message: '原密码不正确。'
              });
            } else {
              util.showError('save_password', status, err);
            }
            this.setState({
              saving: false
            });
          }.bind(this),
          error: function (xhr, status, err) {
            util.showError('save_password', status, err);
            this.setState({
              saving: false
            });
          }.bind(this)
        });
      }

    } else if (this.state.saved) {
      alert('已经保存成功,请勿重复保存!')
    } else {
      alert('正在保存中,请勿重复点击!')
    }
  }

  render() {

    return (
      <div className="user_information_form">
        <dl>
          <dt><span>原密码</span></dt>
          <dd><input ref="txt_oldpassword" type="password" placeholder="登录密码" maxlength="12" onChange={this.handlerOldPasswordChange}/></dd>
          <dt><span>新密码</span></dt>
          <dd><input ref="txt_newpassword1" type="password" placeholder="6-12位密码" maxlength="12" onChange={this.handlerOldPasswordChange}/></dd>
          <dt><span>确认密码</span></dt>
          <dd><input ref="txt_newpassword2" type="password" placeholder="确认新密码" maxlength="12" onChange={this.handlerOldPasswordChange}/></dd>
          <dd className="row_validate_message">
            <ValidateMessage ref="vm_oldpassword" key="vm_oldpassword" />
            <ValidateMessage ref="vm_newpassword1" key="vm_newpassword1" />
            <ValidateMessage ref="vm_newpassword2" key="vm_newpassword2"  />
          </dd>
          <dd className="row_submit">
            <div onClick={this.handlerSubmitClick} >
              <span ref="save_button">{this.state.saving ? '正在保存...' : '保存更改'}</span>
            </div>
          </dd>
        </dl>
      </div>
    );
  }
}
export default Entity;