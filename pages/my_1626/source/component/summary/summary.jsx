import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    this.state.Name = "summary"
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
      <h3>个人中心</h3>
    </div>
  }
}

export default Entity;
