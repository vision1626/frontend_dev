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
        账号绑定
      </div>
    );
  }
}
export default Entity;