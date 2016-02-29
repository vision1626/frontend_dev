import React from 'react';
import BaseComponent from '../script/BaseClass.jsx';
class M_Summary extends BaseComponent {
  constructor() {
    super();
  }

  render() {
    return (
      <div>
        {this.userInformation.img_thumb}
      </div>
    );
  }
}

export default M_Summary;