import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Uploader from './uploader.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.handlerSubmitClick = this.handlerSubmitClick.bind(this);

    this.state = {
      init : true,
      userInformation : {
        img_thumb : ''
      },
      saving : false,
      saved : false,
      saveTime : null
    }
  }

  componentDidMount(){
    this.setState({
      init : false,
      userInformation : window.user_information
    })
  }

  componentDidUpdate() {
    let ui = this.state.userInformation;
    util.setArrayPosition(this.props.currentPage, true);

  }

  handlerSubmitClick(e){}

  render() {
    let ui = this.state.userInformation;

    return (
      <div className="user_face_form">
        <dl>
          <dt className="row_o_face"><span>当前头像</span></dt>
          <dd className="row_o_face">
            <img src={ui.img_thumb} alt="" className="o_face"/>
            <Uploader showText="上传新头像"/>
            <span className="upload_desc">仅支持JPEG、GIF、PNG格式图片，文件小于1M。</span>
          </dd>
          <dt className="row_n_face"><span>编辑新头像</span></dt>
          <dd className="row_n_face">
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