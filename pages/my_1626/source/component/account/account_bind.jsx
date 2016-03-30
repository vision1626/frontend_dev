import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import BindItem from './bind_item.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    let bind_data = [];

    for(let index in window.user_information.login_modules){
      let name,short_name,icon_name,isbinded = false;

      switch (index){
        case 'sina':
          name = '新浪微博';
          short_name = '微博';
          icon_name = 'icon-weibo';
          break;
        case 'qq':
          name = 'QQ';
          short_name = 'QQ';
          icon_name = 'icon-qq';
          break;
        case 'taobao':
          name = '淘宝';
          short_name = '淘宝';
          icon_name = 'icon-taobao';
          break;
        case 'weixin':
          name = '微信';
          short_name = '微信';
          icon_name = 'icon-weibo';
          break;
        default:
          name = '第三方登录';
          short_name = 'original';
          icon_name = '';
      }

      let od = window.user_information.login_modules[index];

      for(let uindex in window.user_information.bind_list){
        if(uindex == index){isbinded = true; }
      }

      bind_data.push({
        index : index,
        name : name,
        short_name : short_name,
        icon_name : icon_name,
        bind_url : od.bind_url,
        unbind_url : od.unbind_url,
        o_short_name: od.short_name,
        o_icon_name : od.bind_img,
        isbinded : isbinded
      });
    }

    return (
      <div className="user_bind_form">
        <span className="bind_desc">绑定微博、QQ、微信或淘宝,可以方便地把您在1626上的内容分享給您的好友们。</span>
        <dl>
          {bind_data.map(function(bd){
            return <BindItem key={bd.index} data={bd} />
            })}
        </dl>
      </div>
    );
  }
}
export default Entity;