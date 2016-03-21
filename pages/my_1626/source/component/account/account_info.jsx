import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Entity extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    util.setArrayPosition(this.props.currentPage,true);
    return (
      <div className="">
        基本信息
      </div>
    );
  }
}
export default Entity;