import React from 'react';
class C_PaginationDiv extends React.Component {
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
      <div className={classname} onClick={this._handleClick}>
        {this.props.text}
      </div>
    );
  }
}

export default C_PaginationDiv;