import React from 'react';
import * as util from '../../script/util.jsx';
import DD from './dd.jsx';

class C_Pagination extends React.Component {
  constructor() {
    super();
    this.state = {
      current_page : 1
    };
  }

  handlePageTurning(page) {
    this.props.pageTurning(page);
  }

  render() {
    let total_record = this.props.recordCount;
    let total_page = Math.ceil(total_record/5);
    let current_page = this.props.currentPage;

    let dd_dotdotdot_left =( current_page > 4) ? <DD classname="invalid" text="..." /> : '' ;
    let dd_dotdotdot_right =(total_page == 8 && (total_page - current_page) > 3) || (total_page == 9 && current_page == 5) || (total_page > 8 && (total_page - current_page) > 3) ? <DD classname="invalid" text="..." /> : '' ;

    let dd_first = total_page > 5 && current_page > 3 ? <DD pageTurning={this.handlePageTurning.bind(this)} text={1} content={1} /> : '' ;
    let dd_last = total_page > 5 && (total_page - current_page) > 2 ? <DD pageTurning={this.handlePageTurning.bind(this)} text={total_page} content={total_page} /> : '' ;

    let dd_prev = (current_page > 1 ) ? <DD classname="array" pageTurning={this.handlePageTurning.bind(this)} text="&#60;" content={current_page - 1}/> : <DD text="&#60;" classname="array disabled" /> ;
    let dd_next = (current_page < total_page) ? <DD classname="array" pageTurning={this.handlePageTurning.bind(this)} text="&#62;" content={current_page + 1} /> : <DD text="&#62;" classname="array disabled" /> ;

    let dd_current_left4 = (total_page == current_page ) ? <DD classname="l4" pageTurning={this.handlePageTurning.bind(this)} text={current_page - 4} content={current_page - 4} /> : '' ;
    let dd_current_left3 = (total_page == current_page || (total_page - current_page) == 1) ? <DD classname="l3" pageTurning={this.handlePageTurning.bind(this)} text={current_page - 3} content={current_page - 3} /> : '' ;
    let dd_current_left2 = ( current_page > 2 && current_page < 5) || (total_page <= 8 && current_page > 5) || (total_page >8 && (total_page-current_page) <=2 )  ? <DD classname="l2" pageTurning={this.handlePageTurning.bind(this)} text={current_page - 2} content={current_page - 2} /> : '' ;
    let dd_current_left = (current_page >= 2) ? <DD classname="l1" pageTurning={this.handlePageTurning.bind(this)} text={current_page - 1} content={current_page - 1}/> : '' ;

    let dd_current = <DD classname="current" text={current_page} />

    let dd_current_right = ((total_page - current_page) >= 1 ) ? <DD classname="r1" pageTurning={this.handlePageTurning.bind(this)} text={current_page + 1} content={current_page + 1} /> : '' ;
    let dd_current_right2 = (total_page <= 8 && current_page <4) || (total_page <= 8 && current_page >= 5 && current_page < 7) || (total_page > 8 && current_page < 4) || (total_page == 8 && current_page >=7 && ((total_page - current_page) <= 3 && (total_page - current_page) >= 2)) ||  (total_page > 8 && current_page >=6 && ((total_page - current_page) <= 3 && (total_page - current_page) >= 2)) ? <DD classname="r2" pageTurning={this.handlePageTurning.bind(this)} text={current_page + 2} content={current_page + 2} /> : '';
    let dd_current_right3 = ((current_page == 2) || (current_page == 1)) ? <DD classname="r3" pageTurning={this.handlePageTurning.bind(this)} text={current_page + 3} content={current_page + 3} /> : '' ;
    let dd_current_right4 = (current_page == 1) ? <DD classname="r4" pageTurning={this.handlePageTurning.bind(this)} text={current_page + 4} content={current_page + 4} /> : '' ;

    let dl;
    if (total_page > 7) {
      dl =
      <dl>
        {dd_prev}
        {dd_first}
        {dd_dotdotdot_left}
        {dd_current_left4}
        {dd_current_left3}
        {dd_current_left2}
        {dd_current_left}
        {dd_current}
        {dd_current_right}
        {dd_current_right2}
        {dd_current_right3}
        {dd_current_right4}
        {dd_dotdotdot_right}
        {dd_last}
        {dd_next}
      </dl>;
    } else {
      let dd_temp = [] ;
      for (let i = 0 ; i < total_page ; i++){
        dd_temp.push (<DD classname={current_page == (i+1) ? 'current d' : 'd'} pageTurning={this.handlePageTurning.bind(this)} text={i+1} content={i+1} />);
      }
      dl =
        <dl>
          {dd_prev}
          {dd_temp}
          {dd_next}
        </dl>;
    }

    let pagination_body = [];
    if (total_page > 1) {
      pagination_body.push(
        <div className="pag_numbers">
          {dl}
        </div>);
      pagination_body.push(
        <div className="pag_description">
          <span>共{total_page}页</span>
        </div>);
    } else {
      pagination_body = '';
    }
    return (
      <div className="pagination">
        {pagination_body}
      </div>
    );
  }
}

export default C_Pagination;