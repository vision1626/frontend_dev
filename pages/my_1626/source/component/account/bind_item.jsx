import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class BindItem extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    let data = this.props.data;
    let icon,short_name,desc,link;
    if(data.short_name != 'original'){
      icon = <i className={['icon',data.icon_name].join(' ')}/>;
      short_name = data.short_name;
    } else {
      icon = <img src={data.o_icon_name} alt=""/>;
      short_name = data.o_short_name;
    }

    if (data.isbinded){
      desc = <span className="bind_state binded">{['已绑定',short_name].join('')}</span>
      link = <a href={data.unbind_url} className="bind_button binded">解除绑定</a>
    } else {
      desc = <span className="bind_state">{[short_name,'未绑定'].join('')}</span>
      link = <a href={data.bind_url} className="bind_button unbind">立即绑定</a>
    }

    return (
      <dd className="bind_item">
        {icon}
        {desc}
        {link}
      </dd>
    );
  }
}
export default BindItem;