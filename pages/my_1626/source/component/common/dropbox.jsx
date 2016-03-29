import React from 'react';
import * as util from '../../script/util.jsx';

class DropBox extends React.Component {
  constructor() {
    super();
    this.state = {
      data : [],
      selectedValue : -1,
      showingOptions : false,
      optionsMouseOver : false
    };
    this.handlerLostFocus = this.handlerLostFocus.bind(this);
    this.handlerDropBoxClick = this.handlerDropBoxClick.bind(this);
    this.handlerOptionClick = this.handlerOptionClick.bind(this);
    this.handlerOptionMouseEnter = this.handlerOptionMouseEnter.bind(this);
    this.handlerOptionMouseLeave = this.handlerOptionMouseLeave.bind(this);
  }

  handlerDropBoxClick(e){
    //let options =$(this.refs.Options);
    this.setState({
      showingOptions:true
    });
  }

  handlerOptionClick(e){
    let selected_value = e.currentTarget.value;
    this.setState({
      selectedValue : selected_value,
      showingOptions : false
    });
    if (this.props.onSelected) {
      this.props.onSelected(selected_value);
    }
  }

  handlerLostFocus(e){
    if(!this.state.optionsMouseOver) {
      this.setState({
        showingOptions: false
      })
    }
  }

  handlerOptionMouseEnter(e){
    this.setState({
      optionsMouseOver:true
    });
  }

  handlerOptionMouseLeave(e){
    this.setState({
      optionsMouseOver:false
    });
  }

  componentDidUpdate(){
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
        if (data[i].value == this.state.selectedValue) {
          selected_text = data[i].text;
          selected_id = data[i].value;
          selected_class = '';
        }

        options.push(
          <li key={data[i].value} className={ data[i].value == this.state.selectedValue ? 'selected' : '' } value={data[i].value} onClick={this.handlerOptionClick} >
            <span>{data[i].text}</span>
          </li>
        );
        ul =
          <ul ref="Options" onMouseEnter={this.handlerOptionMouseEnter} onMouseLeave={this.handlerOptionMouseLeave} style={this.state.showingOptions ? {display:'block'} : {display:'none'}}>
            {options}
          </ul>;
      }
    }

    return <div className={['dropbox',show_state,disable_state,class_name].join(' ')}>
      <input type="text" readOnly="readonly" value={selected_text} className={[selected_id,selected_class].join(' ')} onBlur={this.handlerLostFocus} onClick={this.handlerDropBoxClick} />
      {ul}
      <i className="icon icon-dropdown"></i>
    </div>
  }
}

export default DropBox;