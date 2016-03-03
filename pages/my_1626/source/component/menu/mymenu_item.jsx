import React from 'react';
import * as util from '../../script/util.jsx';
class MenuItem extends React.Component {
  constructor() {
    super();
    this._handleClick = this._handleClick.bind(this);
  }

  _handleClick(e) {
    let me = $(e.currentTarget);
    if (!me.hasClass('current')) {
      if (this.props.viewName) {
        this.props.changeView(this.props.viewName);
        $('.m_item').removeClass('current');
        me.addClass('current');
        $('.menu_array').css('top',e.currentTarget.offsetTop+10);
      } else if (this.props.link) {
        window.open(this.props.link);
      }
    }
  }

  render() {
    let numberDom = '';
    if (this.props.count > 0){
      numberDom = <span className="m_number">{this.props.count}</span>
    }
    let classname = 'm_item empty';
    if (this.props.iscurrent){
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