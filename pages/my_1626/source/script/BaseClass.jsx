import React from 'react';
class BaseComponent extends React.Component {
  constructor() {
    super();
    this.userInformation = window.user_information;
    this.userStatistics = window.user_statistics;
    this.userOrder = window.user_order;
  }
}

export default BaseComponent;