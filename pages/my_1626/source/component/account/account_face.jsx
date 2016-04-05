import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import Uploader from './uploader.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.handlerSubmitClick = this.handlerSubmitClick.bind(this);
    this.handlerAfterUpload = this.handlerAfterUpload.bind(this);

    this.state = {
      init : true,
      userInformation : {
        img_thumb : ''
      },
      uploaded : false,
      uploadReault : {
        src: ''
      },
      saving : false,
      saved : false,
      saveTime : null
    }
  }

  componentDidMount(){
    this.setState({
      init : false,
      userInformation : window.user_information,
      uploadReault : {
        src: ''
      },
    })
  }

  componentDidUpdate() {
    let ui = this.state.userInformation;
    util.setArrayPosition(this.props.currentPage, true);

    //if (this.state.uploaded){
    //  let result = this.state.uploadReault;
    //  if (result && result != null) {
    //    let url = [SITE_PATH, result.src].join('');
    //    $("#cropimg").Jcrop({
    //      setImage: url,
    //      onChange: this.showPreview,
    //      onSelect: this.showPreview,
    //      aspectRatio: 1,
    //      setSelect: [result.mark.x, result.mark.y, result.mark.w, result.mark.h],
    //      animateTo: [result.mark.x, result.mark.y, result.mark.w, result.mark.h]
    //    });
    //  }
    //}
  }

  handlerSubmitClick(e){}

  handlerAfterUpload(result){
    if (result && result != null) {
      let url = [SITE_PATH, result.src].join('');
      console.log(url);
      $('#cropimg').attr('src',url);
      $("#cropimg").Jcrop({
        trackDocument: false,
        keySupport: false,
        onChange: this.showPreview,
        onSelect: this.showPreview,
        aspectRatio: 1,
        setSelect: [result.mark.x, result.mark.y, result.mark.w, result.mark.h],
        setImage: url
      });
    }

    this.setState({
      uploaded : true,
      uploadReault : result
    });
  }

  showPreview(coords) {
    if (parseInt(coords.w) > 0)
    {
      var rx = 150 / coords.w;
      var ry = 150 / coords.h;
      var rx2 = 50 / coords.w;
      var ry2 = 50 / coords.h;
      var rx3 = 30 / coords.w;
      var ry3 = 30 / coords.h;

      jQuery('#big_img').css({
        width: Math.round(rx * $("#cropimg").width()) + 'px',
        height: Math.round(ry * $("#cropimg").height()) + 'px',
        marginLeft: '-' + Math.round(rx * coords.x) + 'px',
        marginTop: '-' + Math.round(ry * coords.y) + 'px'
      });

      jQuery('#middle_img').css({
        width: Math.round(rx2 * $('#cropimg').width()) + 'px',
        height: Math.round(ry2 * $('#cropimg').height()) + 'px',
        marginLeft: '-' + Math.round(rx2 * coords.x) + 'px',
        marginTop: '-' + Math.round(ry2 * coords.y) + 'px'
      });

      jQuery('#small_img').css({
        width: Math.round(rx3 * $('#cropimg').width()) + 'px',
        height: Math.round(ry3 * $('#cropimg').height()) + 'px',
        marginLeft: '-' + Math.round(rx3 * coords.x) + 'px',
        marginTop: '-' + Math.round(ry3 * coords.y) + 'px'
      });
    }
    $('#x').val(coords.x);
    $('#y').val(coords.y);
    $('#w').val(coords.w);
    $('#h').val(coords.h);
  }

  render() {
    let ui = this.state.userInformation;
    let ur = this.state.uploadReault;
    let cropimg_url = [SITE_PATH,ur.src].join('');

    return (
      <div className="user_face_form">
        <dl>
          <dt className="row_o_face"><span>当前头像</span></dt>
          <dd className="row_o_face">
            <img src={ui.img_thumb} alt="" className="o_face"/>
            <Uploader showText="上传新头像" callBack={this.handlerAfterUpload} />
            <span className="upload_desc">仅支持JPEG、GIF、PNG格式图片，文件小于1M。</span>
          </dd>
          <dt className="row_n_face"><span>编辑新头像</span></dt>
          <dd className="row_n_face">
            <img src='' alt="" className="cropimg" id="cropimg"/>
            <div className="face_preview">
              <span className="preview_desc">头像预览，你上传的头像会自动生成3种尺寸，请注意中小尺寸的头像是否清晰。</span>
              <div className="preview_img">
                <div className="preview_big">
                  <img src={this.state.uploaded ? cropimg_url : ui.img_thumb} alt="" className="big_img" id="big_img"/>
                </div>
                <span>大尺寸头像</span>
                <label>150 x 150</label>
              </div>
              <div className="preview_img">
                <div className="preview_middle">
                  <img src={this.state.uploaded ? cropimg_url : ui.img_thumb} alt="" className="middle_img" id="middle_img"/>
                </div>
                <span>中尺寸头像</span>
                <label>50 x 50</label>
              </div>
              <div className="preview_img">
                <div className="preview_small">
                  <img src={this.state.uploaded ? cropimg_url : ui.img_thumb} alt="" className="small_img" id="small_img"/>
                </div>
                <span>小尺寸头像</span>
                <label>30 x 30</label>
              </div>
            </div>
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