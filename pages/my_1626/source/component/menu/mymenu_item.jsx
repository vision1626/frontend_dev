import React from 'react';
class MenuItem extends React.Component {
  constructor(text,classname,count,iscurrent) {
    super();
    this.props = {
      text : text || 'MenuItem',
      classname : classname || '',
      count : count || 0,
      iscurrent : iscurrent || 'false'
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
      <dd className={classname}>
        <a>
          <span>{this.props.text}</span>
          {numberDom}
        </a>
      </dd>
    );
  }
}

export default MenuItem;