import React from 'react';
import * as util from '../../script/util.jsx';
import DD from './dd.jsx';
import DIV from './div.jsx';

class Pagination2 extends React.Component {
  constructor() {
    super();
    this.state = {
      recordCount : 0,
      currentPageing : 0,
      pageRecords : 0,
      showNumCount : 7
    };
    this.handleKeyUp = this.handleKeyUp.bind(this);
    this.handleTextChange = this.handleTextChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
  }

  handlePageTurning(page) {
    this.props.pageTurning(page);
  }

  handleKeyUp(e){
    if(e.keyCode == 13 || e.which == 13){
      this.inputPageNum();
    }
  }

  handleTextChange(e){
    let me = $(e.currentTarget);
    if (me.val().match(/\d/g) == null){
      me.val('');
    } else {
      me.val(me.val().match(/\d/g).join(''));
    }
  }

  handleClick(e){
    this.inputPageNum();
  }

  inputPageNum(){
    let limit = this.state.pageRecords;
    let txt_num = $(this.refs.txtNum);
    let num = parseInt(txt_num.val());
    let total_record = this.state.recordCount;
    let total_page = Math.ceil(total_record / limit);
    if(num < 1){num = 1;}
    if(num > total_page ){ num = total_page; }
    if(num != this.state.currentPageing) {
      this.handlePageTurning(num);
    } else {
      txt_num.val('');
    }
  }

  render() {
    let limit = this.state.pageRecords;
    if (limit > 0) {
      let total_record = this.state.recordCount;
      let total_page = Math.ceil(total_record / limit);
      let current_page = this.state.currentPageing;
      let show_num_count = this.state.showNumCount;

      let left = 18;
      if (total_page > show_num_count) {
        if (current_page > 4 && (total_page - current_page) > 3) {
          left = 18 - ((current_page - 4) * 18) - (current_page - 4);
        } else if (current_page > 4 && (total_page - current_page) <= 3) {
          left = 18 - ((total_page - show_num_count) * 18) - (total_page - show_num_count)
        }
      }
      $('.dl_numbers').css('left', left);

      let dd_prev = (current_page > 1 ) ?
        <DIV classname="array" pageTurning={this.handlePageTurning.bind(this)} text="&#60;"
             content={current_page - 1}/> : <DIV text="&#60;" classname="array disabled"/>;
      let dd_next = (current_page < total_page) ?
        <DIV classname="array" pageTurning={this.handlePageTurning.bind(this)} text="&#62;"
             content={current_page + 1}/> : <DIV text="&#62;" classname="array disabled"/>;

      let dl;
      let dd_temp = [];
      for (let i = 0; i < total_page; i++) {
        dd_temp.push (<DD key={['page',i+1].join('_')} classname={current_page == (i+1) ? 'current d' : 'd'}
                          pageTurning={current_page == (i+1) ? null : this.handlePageTurning.bind(this)} text={i+1}
                          content={i+1}/>);
      }
      dl =
        <dl className="dl_numbers">
          {dd_temp}
        </dl>;

      let pagination_body = [];
      let container_width = 0;
      if (total_page > show_num_count) {
        container_width = (18 * (show_num_count + 2)) + (show_num_count + 1);
      } else {
        container_width = (18 * (total_page + 2)) + (total_page + 1);
      }

      if (total_page > 0) {
        pagination_body.push(
          <div key="p_num" className="pag_numbers" style={{width:container_width + 'px'}}>
            {dd_prev}
            {dl}
            {dd_next}
          </div>);
        if (total_page > 1) {
          pagination_body.push(
            <div key="p_desc" className="pag_description">
              <span>共{total_page}页到，第</span>
              <input ref="txtNum" maxLength="4" onKeyUp={this.handleKeyUp} onChange={this.handleTextChange}/>
              <span>页</span>
              <a onClick={this.handleClick}>确定</a>
            </div>);
        } else {
          pagination_body.push(
            <div key="p_desc" className="pag_description">
              <span>共{total_page}页</span>
            </div>);
        }
      } else {
        pagination_body = '';
      }

      return <div className="pagination2">
        {pagination_body}
      </div>
    } else {
      return <div className="pagination2"></div>
    }
  }
}
export default Pagination2;