import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class FollowButton extends BaseComponent {
  constructor() {
    super();
    this.handlerMouseEnter = this.handlerMouseEnter.bind(this);
    this.handlerMouseLeave = this.handlerMouseLeave.bind(this);
    this.handlerMouseClick = this.handlerMouseClick.bind(this);
    this.setFollowStatus = this.setFollowStatus.bind(this);
    this.state = {
      FollowState : 0
    };
  }

  componentDidMount(){
    this.setState({
      FollowState: this.props.FollowState
    });
  }

  handlerMouseClick(e){
    let uid = this.props.UID;
    let myid = this.props.MyID;
    //console.log('uid:' + uid );
    //console.log('myid:' + myid );
    let $btn = $(e.currentTarget);
    if (parseInt(window.myid) > 0){
      if (uid == myid){
        alert('你不能关注自己哦！');
      } else {
        //console.log('uid:' + uid );
        $.ajax({
          url: '/services/service.php?m=user&a=follow',
          type: 'post',
          data: { uid: uid },
          dataType: 'json',
          success: function(result) {
            if (result.status == 1 || result == 2) {
              this.sliderToRight($btn,result.status);
            } else {
              this.sliderToLeft($btn);
            }
          }.bind(this),
          error: function(xhr, status, err) {
            util.showError('get_message_ajax',status,err);
          }.bind(this)
        });
      }
    } else {
      location.href = SITE_URL + 'user/login.html';
    }
  }

  sliderToRight($btn,status){
    let $slider_btn = $btn.find('.slider-btn');
    $slider_btn.addClass('slide-to-right').removeClass('slide-to-left');
    let $slider = $btn.find ('.slider');
    $slider.css('opacity',0);
    this.setState({
      FollowState : status
    });
    //setTimeout(function() {
    this.setFollowStatus($btn,status);
    //}, 500).bind(this);
  }

  sliderToLeft($btn){
    let $slider_btn = $btn.find('.slider-btn');
    $slider_btn.addClass('slide-to-left').removeClass('slide-to-right');
    let $slider = $btn.find ('.slider');
    $slider.css('opacity',0);
    this.setState({
      FollowState : 0
    });
    //setTimeout(function() {
    this.setFollowStatus($btn,0);
    //}, 500).bind(this);
  }

  setFollowStatus($btn,status){
    let $slider = $btn.find('.slider');
    let $slider_icon = $slider.find('.icon');
    let $slider_text = $slider.find('.status_text');
    $slider.css('opacity',1);
    $slider.removeClass('to-unfollow');
    switch (status){
      case 0:
        $btn.removeClass('slider--on');
        $slider_icon.removeClass('icon-followed');
        $slider_icon.removeClass('icon-friends');
        $slider_icon.addClass('icon-follow');
        $slider_text.html("关注Ta");
        break;
      case 1:
        $btn.addClass('slider--on');
        $slider_icon.removeClass('icon-follow');
        $slider_icon.removeClass('icon-friends');
        $slider_icon.addClass('icon-followed');
        $slider_text.html("已关注");
        break;
      case 2:
        $btn.addClass('slider--on');
        $slider_icon.removeClass('icon-follow');
        $slider_icon.removeClass('icon-followed');
        $slider_icon.addClass('icon-friends');
        $slider_text.html("互相关注");
        break;
    }
  }

  handlerMouseEnter(e){
    let $btn = $(e.currentTarget);
    let is_follow = parseInt(this.state.FollowState);
    let $slider = $btn.find('.slider');
    let $slider_text = $slider.find('a.status_text');
    if (is_follow > 0){
      $slider.addClass('to-unfollow');
      $slider_text.html("取消关注");
    }
  }

  handlerMouseLeave(e){
    let $btn = $(e.currentTarget);
    let is_follow = parseInt(this.state.FollowState);
    let $slider = $btn.find('.slider');
    let $slider_text = $slider.find('a.status_text');
    $slider.removeClass('to-unfollow')
    switch (is_follow){
      case 1:
        $slider_text.html("已关注");
        break;
      case 2:
        $slider_text.html("互相关注");
        break;
    }
  }

  render() {
    let is_follow = parseInt(this.state.FollowState);

    let status_class = '';
    let status_text = '';
    let status_icon = '';
    let status_btn = '';

    if (is_follow >= 1){
      status_btn = 'slider--on';
      if (is_follow == 2){
        status_icon = 'icon-friends';
        status_text = '互相关注';
      }else {
        status_icon = 'icon-followed';
        status_text = '已关注';
      }
    } else {
      status_class = 'follow_nt';
      status_text = '关注Ta';
      status_icon = 'icon-follow';
    }

    return (
      <div className={this.props.classname ? [this.props.classname ,'follow-btn', status_btn ].join(' ') : ['follow-btn', status_btn ].join(' ')} onClick={this.handlerMouseClick} onMouseEnter={this.handlerMouseEnter} onMouseLeave={this.handlerMouseLeave}>
        <div className='slider'>
          <i className={['icon',status_icon].join(' ')}/>
          <a className="status_text">{status_text}</a>
        </div>
        <div className='slider-btn'></div>
      </div>
    );
  }
}
export default FollowButton;