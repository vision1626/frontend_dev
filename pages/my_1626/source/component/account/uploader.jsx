import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Uploader extends BaseComponent {
  constructor() {
    super();
    this.state = {
      uploading : false,
      uploaded : false,
      uploaded_url : ''
    };
    this.handlerFileSelected = this.handlerFileSelected.bind(this);
  }

  componentDidMount(){
    let true_button = this.refs.upload_entity;
    let fake_button = this.refs.upload_fake;

    $(true_button).css('left',fake_button.offsetLeft).css('top',fake_button.offsetTop).css('width',fake_button.offsetWidth).css('height',fake_button.offsetHeight);
  }

  handlerFileSelected(e){
    let success = false;
    let uploaded_url = '';
    this.setState({
      uploading: true
    });
    $.ajaxFileUpload({
      url:SITE_PATH + "services/service.php?m=user&a=avatar",
      secureuri: false,
      fileElementId: e.target.id,
      dataType:'json',
      success:function(result)
      {
        if(result.status ==1){
          if(result.src != '')
          {
            //$("#textfield").val(result.name);
            //$("#viewAvartar").val(result.src);
            //$(".reset_pic_bg img").attr("src",SITE_PATH + result.src);
            //$(".sc_picsize img").attr("src",SITE_PATH + result.src);
            //$("#avatarmsg").hide();
            //$("#cropimg").Jcrop({
            //  onChange: showPreview,
            //  onSelect: showPreview,
            //  aspectRatio: 1,
            //  setSelect: [result.mark.x,result.mark.y,result.mark.w,result.mark.h]
            //});
            uploaded_url = [SITE_PATH,result.src].join('');
            //console.log(uploaded_url);
            this.props.callBack(result);
          }
          else
          {
            util.msgBox('上传头像失败','icon-sad');
          }
        }else if(result.status ==2){
          util.msgBox('请上传正确的图片格式','icon-sad');
        }else if(result.status ==3){
          util.msgBox('请上传大小在1M以内的图片！','icon-sad');
        }
        this.setState({
          uploading : false,
          uploaded : success,
          uploaded_url : uploaded_url
        });
      }.bind(this),
      error: function (xhr, status, err) {
        util.showError('avatar', status, err);
        if (xhr.responseText.indexOf('413') > -1){util.msgBox('请上传大小在1M以内的图片！','icon-sad'); }
        this.setState({
          uploading: false
        });
      }.bind(this)
    });
  }

  render() {
    return <div className="uploader" style={{position:'relative'}}>
      <a ref="upload_fake" href="" className="upload_button" >{this.state.uploading ? '正在上传...' : this.props.showText}</a>
      <input ref="upload_entity" id="upload_entity" name="avatar" type="file" className="upload_entity" onChange={this.handlerFileSelected} style={{position:'absolute',opacity:'0',cursor:'pointer'}} />
    </div>
  }
}

export default Uploader