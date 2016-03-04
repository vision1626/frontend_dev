import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class Loading extends BaseComponent {
  render() {
    return (
      <div className="loading_message">
        <i className="icon icon-hand" />
        <span>正在努力加载中...</span>
      </div>

    );
  }
}
export default Loading;