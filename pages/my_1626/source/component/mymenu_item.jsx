import React from 'react';
class MenuItem extends React.Component {
  constructor(text,classname,count,iscurrent) {
    super(text,classname,count,iscurrent);
    this.state = {
      text : text || 'MenuItem',
      classname : classname || '',
      count : count || 0,
      currentitem : iscurrent || false
    }
  }

  render() {
    let numberDom = '';
    if (this.state.count > 0){
      numberDom = <span className="m_number">this.state.count</span>
    }

    return (
      <dd className={this.state.currentitem == true ? "m_item current " + this.state.classname : "m_item " + this.state.classname}>
        <a>
          <span>{this.state.text}</span>
          {numberDom}
        </a>
      </dd>
    );
  }
}

export default MenuItem;