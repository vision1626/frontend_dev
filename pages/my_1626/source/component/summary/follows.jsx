import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Follows extends BaseComponent {
  constructor() {
    super()
    this.state = { follows: [] }
  }

  loadFollowsFromServer() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(follows) {
        if(follows.data) {
          this.setState({follows: follows.data});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  }

  componentWillMount() {
    let self = this
    setTimeout(function() {
      self.loadFollowsFromServer()
    }, 1000)
  }

  render() {
    let rows = [];
    if (this.state.follows.length > 0) {
      for (var i = 0; i < this.state.follows.length; i++) {
        rows.push(<Follow follow={this.state.follows[i]} key={i}/>)
      }
    } else {
      rows.push(
        <tr key={Math.random()}>
          <td className="blank-td" >
            您还没有新动态
          </td>
        </tr>
      )
    }
    return (
      <div className="follows">
        <h5>
          <i className="icon icon-news" />
          关注动态
          <a className="check-all" 
            href="/u/dashboard">
            查看全部动态
          </a>
        </h5>
        <table>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    )
  }
}

class Follow extends BaseComponent {
  render() {
    let div = '';
    if (this.props.follow.like_user_list && 
      this.props.follow.like_user_list.length > 0) {
      div = <div>
              <a href={this.props.follow.like_user_list[0].user_href}>{this.props.follow.like_user_list[0].user_name}</a>
              <span>喜欢了</span>
            </div> 
    } else {
        div = <div>
                <a href={this.props.follow.user_href}>{this.props.follow.user_name}</a>
                <span>发布了</span>
              </div>
    }
    return (
      <tr>
        <td className="img-td">
          <img src={this.props.follow.img} />
        </td>
        <td className="news-info-td">
          {div}
          <p>{decodeURIComponent(this.props.follow.title)}</p>
        </td>
        <td className="publisher-td"> 
          <p>
            发布者
            <img src={this.props.follow.img_thumb} />
          </p>
        </td>
        <td className="price-td">
          <p>{this.props.follow.goods_price ? 
              '¥' + this.props.follow.goods_price :
              ''}</p>
        </td>
        <td className="check-td">
          <a href={this.props.follow.url}>查看</a>
        </td>
      </tr>
    )
  }
}
export default Follows;