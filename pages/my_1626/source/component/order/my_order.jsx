import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
    alert('order');
  }

  render() {
    return (
      <div>
        我的订单 {this.props.testValue}
      </div>
    );
  }
}
//
//Entity.propTypes = {
//  loaded : React.PropTypes.bool
//}
//
//Entity.defaultProps = {
//  loaded : false
//}

export default Entity;

