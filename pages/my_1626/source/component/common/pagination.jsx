import React from 'react';

class C_Pagination extends React.Component {
  constructor() {
    super();
    this.state = {
      current_page : 1
    }
  }

  calculatePages(){
    let total_record = this.props.recordCount;
    let current_page = this.state.current_page;
    //Math.ceil(1.1)
  }

  render() {
    return (
      <div clsaaName="pagination">
        <div>{this.props.recordCount}</div>
        <div>{this.state.current_page}</div>
      </div>
    );
  }
}

export default C_Pagination;