import React from 'react';
class C_PaginationDD extends React.Component {
  constructor() {
    super();
    this._handleClick = this._handleClick.bind(this);
  }

  _handleClick(e) {
    if (this.props.pageTurning) {
      this.props.pageTurning(this.props.content);
    }
  }

  render() {
    let classname = this.props.classname ? classname = this.props.classname : '' ;

    return (
      <dd className={classname} onClick={this._handleClick}>
        {this.props.text}
      </dd>
    );
  }
}

export default C_PaginationDD;