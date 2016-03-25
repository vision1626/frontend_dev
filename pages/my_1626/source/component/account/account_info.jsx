import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import DropBox from '../common/dropbox.jsx';
import ValidateMessage from '../common/from_validate_message.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.handlerSubmitClick = this.handlerSubmitClick.bind(this);
    this.handlerUserNameChange = this.handlerUserNameChange.bind(this);
    this.handlerSexChange = this.handlerSexChange.bind(this);
    this.handlerBirthDayChange = this.handlerBirthDayChange.bind(this);
    this.handlerEmailChange = this.handlerEmailChange.bind(this);
    this.handlerMobileChange = this.handlerMobileChange.bind(this);
    this.handlerIntroduceChange = this.handlerIntroduceChange.bind(this);

    this.state = {
      init : true,
      userInformation : {
        user_name : '',
        gender : 0 ,
        birth_year : 0,
        birth_month : 0,
        birth_day : 0,
        email : '',
        mobile : '' ,
        introduce : ''
      },
      saving : false,
      saved : false,
      saveTime : null
    }
  }

  handlerSubmitClick(e){
    let verified = true;
    let txt_nickname = this.refs.txt_nickname;
    let txt_email = this.refs.txt_email;
    let txt_mobile = this.refs.txt_mobile;
    let txt_introduce = this.refs.txt_introduce;
    let vm_nickname = this.refs.vm_nickname;
    let vm_email = this.refs.vm_email;
    let vm_mobile = this.refs.vm_mobile;
    let vm_introduce = this.refs.vm_introduce;
    let original_information = $.parseJSON(window.user_information_string);

    if (!(original_information.user_name == txt_nickname.value &&
          original_information.email == txt_email.value &&
          original_information.mobile == txt_mobile.value &&
          (original_information.introduce == txt_introduce.value || (!(original_information.introduce) && txt_introduce.value == '')) )) {
      if (!this.state.saving) {
        if (txt_nickname.value == '') {
          verified = false;
          vm_nickname.setState({
            show: true,
            type: 2,
            message: '请输入昵称'
          });
        } else if (txt_nickname.value != '' && !util.validateNickname(txt_nickname.value)) {
          verified = false;
          vm_nickname.setState({
            show: true,
            type: 2,
            message: '昵称输入有误，请输入2-16个字，由中英文、数字组成。'
          });
        } else {
          vm_nickname.setState({
            show: false
          });
        }

        //检验email输入框
        if (txt_email.value != '' && !util.validateEmail(txt_email.value)) {
          verified = false;
          vm_email.setState({
            show: true,
            type: 2,
            message: '邮箱输入有误。'
          });
        } else {
          vm_email.setState({
            show: false
          });
        }

        //检验手机输入框
        if (txt_mobile.value != '' && !util.validateMobile(txt_mobile.value)) {
          verified = false;
          vm_mobile.setState({
            show: true,
            type: 2,
            message: '邮箱手机有误。'
          });
        } else {
          vm_mobile.setState({
            show: false
          });
        }

        //检验个人介绍输入框
        if (txt_introduce.value.length > 140) {
          verified = false;
          vm_introduce.setState({
            show: true,
            type: 2,
            message: '个人介绍不能超过120字。'
          });
        }

        if (verified) {
          //检查昵称是否存在(如果昵称修改过)
          this.setState({
            saving: true
          });
          if (original_information.user_name != txt_nickname.value) {
            $.ajax ({
              url: SITE_URL + "services/service.php",
              type: "GET",
              data: {m: 'user', a: 'check_nickname_exist', ajax: 1, nick_name: txt_nickname.value},
              cache: false,
              async: false,
              dataType: "json",
              success: function (result) {
                if (parseInt(result.status) == 1) {
                  this.saveUserInformation()
                } else if (parseInt(result.status) == 3) {
                  vm_nickname.setState({
                    show: true,
                    type: 2,
                    message: '昵称已存在。'
                  });
                } else {
                  util.showError('check_nickname_exist', status, err);
                }
                this.setState({
                  saving: false
                });
              }.bind(this),
              error: function (xhr, status, err) {
                util.showError('check_nickname_exist', status, err);
                this.setState({
                  saving: false
                });
              }.bind(this)
            });
          } else {
            this.saveUserInformation()
          }
        }
      } else if (this.state.saved) {
        alert('已经保存成功,请勿重复保存!')
      } else {
        alert('正在保存中,请勿重复点击!')
      }
    }
  }

  saveUserInformation(){
    let txt_nickname = this.refs.txt_nickname;
    let txt_email = this.refs.txt_email;
    let txt_mobile = this.refs.txt_mobile;
    let txt_introduce = this.refs.txt_introduce;
    $.ajax ({
      url: SITE_URL + "services/service.php",
      type: "GET",
      data: {m: 'home', a: 'update_user_base_profile', ajax: 1,
        nick_name : txt_nickname.value,
        mobile : txt_mobile.value,
        introduce : txt_introduce.value
      },
      cache: false,
      async: false,
      dataType: "json",
      success: function (result) {
        if (parseInt(result.status) == 1) {
          alert('保存成功!');
          this.setState({
            saved : true,
            saving : false
          });
        } else {
          util.showError('update_user_base_profile', status, err);
        }
        this.setState({
          saving: false
        });
      }.bind(this),
      error: function (xhr, status, err) {
        util.showError('update_user_base_profile', status, err);
        this.setState({
          saving: false
        });
      }.bind(this)
    });
  }

  handlerUserNameChange(e){
    let tempUserInformation = this.state.userInformation;
    tempUserInformation.user_name = e.target.value;

    this.setState({
      userInformation : tempUserInformation
    })
  }

  handlerSexChange(e){
    let tempUserInformation = this.state.userInformation;
    tempUserInformation.gender = parseInt(e.target.value);

    this.setState({
      userInformation : tempUserInformation
    })
  }

  handlerBirthDayChange(e){
    let tempUserInformation = this.state.userInformation;
    let borthday = new Date($(e.target).val());
    tempUserInformation.birth_year = borthday.getFullYear();
    tempUserInformation.birth_month = borthday.getMonth();
    tempUserInformation.birth_day = borthday.getDate();

    this.setState({
      userInformation : tempUserInformation
    })

    console.log(this.state.userInformation)
  }

  handlerEmailChange(e){
    let tempUserInformation = this.state.userInformation;
    tempUserInformation.email = e.target.value;

    this.setState({
      userInformation : tempUserInformation
    })
  }

  handlerMobileChange(e){
    let tempUserInformation = this.state.userInformation;
    tempUserInformation.mobile = e.target.value;

    this.setState({
      userInformation : tempUserInformation
    })
  }

  handlerIntroduceChange(e){
    if(e) {
      let tempUserInformation = this.state.userInformation;
      tempUserInformation.introduce = e.target.value;

      this.setState({
        userInformation: tempUserInformation
      })
    }
  }

  componentDidMount(){
    this.setState({
      init : false,
      userInformation : window.user_information
    })
  }

  componentDidUpdate(){
    let ui = this.state.userInformation;
    util.setArrayPosition(this.props.currentPage,true);
    let provinces = util.getProvince(3);

    this.refs.slt_province.setState({
      selectedValue : 3,
      data : provinces
    });
  }

  render() {
    let ui = this.state.userInformation;
    return (
      <div className="user_information_form">
        <dl>
          <dt><span>昵  称</span></dt>
          <dd><input ref="txt_nickname" placeholder="昵称" onChange={this.handlerUserNameChange} value={ui.user_name} maxLength="16"/></dd>

          <dt><span>性  别</span></dt>
          <dd className="row_sex">
            <input type="radio" name="rdoSex" id="rdoMale" value={1} checked={parseInt(ui.gender) == 1 ? 'checked' : ''} onChange={this.handlerSexChange} /><label htmlFor="rdoMale">男</label>
            <input type="radio" name="rdoSex" id="rdoFemale" value={2} checked={parseInt(ui.gender) == 2 ? 'checked' : ''} onChange={this.handlerSexChange}/><label htmlFor="rdoFemale">女</label>
            <input type="radio" name="rdoSex" id="rdoUnknow" value={0} checked={parseInt(ui.gender) == 0 ? 'checked' : ''} onChange={this.handlerSexChange}/><label htmlFor="rdoUnknow">中性</label>
          </dd>
          <dt><span>生  日</span></dt>
          <dd><input className="sang_Calender" onChange={this.handlerBirthDayChange} value={[ui.birth_year,ui.birth_month,ui.birth_day].join('-')} maxLength="10"/></dd>

          <dt><span>邮  箱</span></dt>
          <dd><input ref="txt_email" placeholder="E-Mail" value={ui.email} onChange={this.handlerEmailChange} maxLength="50" /></dd>

          <dt><span>手  机</span></dt>
          <dd><input ref="txt_mobile" placeholder="手机号码" value={ui.mobile} onChange={this.handlerMobileChange} maxLength="11" /></dd>

          <dt><span>所在地</span></dt>
          <dd>
            <DropBox className="slt_province" ref="slt_province" key="slt_province" emptyText="选择省份" />
            <DropBox className="slt_city" ref="slt_city" key="slt_city" emptyText="选择城市" />
          </dd>

          <dt><span>个人介绍</span></dt>
          <dd className="row_introduce">
            <textarea ref="txt_introduce" placeholder="填写个人介绍" value={ui.introduce} onChange={this.handlerIntroduceChange} maxLength="120" />
          </dd>

          <dd className="row_validate_message">
            <ValidateMessage ref="vm_nickname" key="vm_nickname" />
            <ValidateMessage ref="vm_email" key="vm_email" />
            <ValidateMessage ref="vm_mobile" key="vm_mobile"  />
            <ValidateMessage ref="vm_introduce" key="vm_introduce"  />
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