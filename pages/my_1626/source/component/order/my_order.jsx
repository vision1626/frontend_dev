import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state.Name = "order"
  }

  render() {
    let display ;
    if (this.props.currentPage == this.state.Name){
      if (!this.state.Build) {
        //this.setState({Build: true});
        //alert('build');
      }
      display = 'block';
    } else {
      display = 'none';
    }

    return <div style={{display:display}}>
      <h3>订单</h3>
    </div>
  }
}

export default Entity;

