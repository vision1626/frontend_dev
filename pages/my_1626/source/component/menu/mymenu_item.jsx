import React from 'react';
import * as util from '../../script/util.jsx';
class MenuItem extends React.Component {
  constructor(text,classname,count,iscurrent,method) {
    super();
    this._handleClick = this._handleClick.bind(this)
    this.props = {
      text : text || 'MenuItem',
      classname : classname || '',
      count : count || 0,
      iscurrent : iscurrent || 'false',
      method : method || ''
    }
  }

  _handleClick(e) {
    if ((this.props.viewName != '' && typeof(this.props.viewName) != 'undefined') && this.props.iscurrent != 'true') {
      this.props.changeView(this.props.viewName);
    }
  }

  render() {
    let numberDom = '';
    if (this.props.count > 0){
      numberDom = <span className="m_number">{this.props.count}</span>
    }
    let classname = '';
    if (this.props.iscurrent == 'true'){
      classname = ['m_item',this.props.classname,'current'].join(' ')
    } else {
      classname = ['m_item',this.props.classname].join(' ')
    }

    return (
      <dd className={classname} onClick={this._handleClick}>
        <a>
          <span>{this.props.text}</span>
          {numberDom}
        </a>
      </dd>
    );
  }
}

export default MenuItem;