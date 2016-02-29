import React from 'react';
class MenuItem extends React.Component {
  constructor(text,classname,count,iscurrent) {
    super();
    this.props = {
      text : text || 'MenuItem',
      classname : classname || '',
      count : count || 0,
      currentitem : iscurrent || false
    }
  }

  render() {
    let numberDom = '';
    if (this.props.count > 0){
      numberDom = <span className="m_number">{this.props.count}</span>
    }

    return (
      <dd className={this.props.currentitem == true ? "m_item current " + this.props.classname : "m_item " + this.props.classname}>
        <a>
          <span>{this.props.text}</span>
          {numberDom}
        </a>
      </dd>
    );
  }
}

export default MenuItem;