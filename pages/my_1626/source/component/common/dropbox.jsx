import React from 'react';
import * as util from '../../script/util.jsx';

class DropBox extends React.Component {
  constructor() {
    super();
    this.state = {
      data : [],
      selectedValue : 0,
      showingOptions : false
    };
    this.handlerMouseEnter = this.handlerMouseEnter.bind(this);
    this.handlerMouseLeave = this.handlerMouseLeave.bind(this);
    this.handlerLostFocus = this.handlerLostFocus.bind(this);
    this.handlerOnFocus = this.handlerOnFocus.bind(this);
    this.handlerDropBoxClick = this.handlerDropBoxClick.bind(this);
    this.handlerOptionClick = this.handlerOptionClick.bind(this);
  }

  handlerDropBoxClick(e){
    let options =$(this.refs.Options);
    //options.show();
    this.setState({
      showingOptions:true
    })
  }

  handlerOnFocus(e){
    console.log('of');
  }

  handlerOptionClick(e){

  }

  handlerMouseEnter(e){

  }

  handlerLostFocus(e){
    console.log('lf');
  }

  handlerMouseLeave(e){
    //let options = $(e.currentTarget);
    //options.hide();
    this.setState({
      showingOptions:false
    })
  }

  render() {
    let class_name = '';
    let show_state = '';
    let disable_state = '';
    let ul = '';
    let options = [];
    let data = this.state.data;
    let selected_text = '---';
    let selected_id = 0;
    let selected_class = 'unselected';

    if (this.props.emptyText) {
      selected_text = this.props.emptyText;
    }

    if (this.props.className != '') {
      class_name = this.props.className;
    }

    if (data.length > 0){
      for(let i = 0 ; i < data.length ;i++){
        if (data[i].isselected){
          selected_text = data[i].text;
          selected_id = data[i].value;
          selected_class = '';
        }

        options.push(
          <li key={data[i].value} className={ data[i].isselected ? [data[i].value,'selected'].join(' ') : data[i].value }>
            <span>{data[i].text}</span>
          </li>
        );
        ul =
          <ul ref="Options" onMouseEnter={this.handlerMouseEnter} onMouseLeave={this.handlerMouseLeave} onblur={this.handlerLostFocus} style={this.state.showingOptions ? {display:'block'} : {display:'none'}}>
            {options}
          </ul>;
      }
    }

    return <div className={['dropbox',show_state,disable_state,class_name].join(' ')} onClick={this.handlerDropBoxClick}>
      <input type="text" readOnly="readonly" value={selected_text} className={[selected_id,selected_class].join(' ')} />
      {ul}
      <i className="icon icon-dropdown"></i>
    </div>
  }
}

export default DropBox;