import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';
import * as util from '../../script/util.jsx';

class RichTextBox extends BaseComponent {
  constructor() {
    super();
    this.handlerAfterMount = this.handlerAfterMount.bind(this);
  }

  componentDidMount(e){
    this.handlerAfterMount();
  }

  handlerAfterMount() {
    let me = $(this.refs.rich_text_box);
    me.html($.trim(this.props.text));
  }

  render() {
    return (
      <div ref="rich_text_box" className="rich_text_box">
      </div>
    );
  }
}
export default RichTextBox;