
export function callMyOrder(){
  //return My_Order.initMyOrder();
  return alert('nothing');
}

export function setArrayPosition(currentpage,just_set_tab = false){
  let targetMenuItem = $('.mnu_' + currentpage);
  let targetTabItem = $('.tab_' + currentpage);
  if(!just_set_tab) {
    $('.m_item').removeClass('current');
    targetMenuItem.addClass('current');
    $('.menu_array').css('top', targetMenuItem.position().top + 10);
  }
  if (targetTabItem.length > 0) {
    $('.mt_item').removeClass('current');
    targetTabItem.addClass('current');
    $('.msg_tab_slider').css('left', targetTabItem.position().left);
  }
  closeMessageDetail();
}

export function formatDate(source,complete = false){
  let add_hours = 1000*60*60*8; //加翻8个钟
  let source_date = new Date((source * 1000)+add_hours);
  let source_date_text = [[source_date.getFullYear(),source_date.getMonth(),source_date.getDate()].join('-'),[source_date.getHours(),source_date.getMinutes(),source_date.getSeconds()].join(':')].join(' ');
  let now = new Date();
  //计算时间差
  let gap = now-source_date;
  let gap_days = (gap / (1000*3600*24)).toFixed();
  let gap_hours = (gap / (1000*3600)).toFixed();
  let gap_minute = (gap / (1000*60)).toFixed();
  let result = '';

  //判断是否输出完整日期(如不传入参数或者为false,则格式化为"XX分钟/天前"的格式)
  if (complete) {
    result = source_date_text;
  } else {
    if (gap_minute >= 0 && gap_minute < 60) {
      if (gap_minute == 0) {
        result = '1分钟前';
      } else {
        result = gap_minute + '分钟前';
      }
    } else if (gap_hours > 0 && gap_hours < 24) {
      result = gap_hours + '小时前';
    } else if (gap_days > 0 && gap_days <= 7) {
      if (gap_days == 1) {
        result = '昨天';
      } else {
        result = gap_days + '天前';
      }
    } else {
      result = source_date_text;
    }
  }

  return result
}

export function showError(title,state,message){
  if (typeof console !== 'undefined') {
    console.error(title,state,message);
  } else {
    alert([title,state,message].join(','));
  }
}

export function getOrderStatus(order_status, pay_status, shipping_status) {
  let obj = {
    text: '',
    action: '',
    className: ''
  }
  if (order_status == 1) {
    if (pay_status == 0) {
      obj.text = '待付款'
      obj.action = '付款'
      obj.className = 'unpay'
    } else if (pay_status == 2) {
      if (shipping_status == 0) {
        obj.text = '待发货'
      } else if (shipping_status == 1){
        obj.text = '待收货,物流跟踪'
        obj.action = '确认收货'
        obj.className = 'delivery'
      } else if (shipping_status == 2) {
        obj.text = '交易完成,查看物流'
      }
    }
  } else if (order_status == 2) {
    obj.text = '已取消'
  } else if (order_status == 0) {
    obj.text = '未确认'
  }

  return obj;
}

export function formatCount(count){
  if (parseInt(count) > 0){
    if(parseInt(count) >= 10000){
      return [Math.round(count/1000),'k'].join('');
    } else if (parseInt(count) >= 1000) {
      return [(count/1000).toFixed(1),'k'].join('');
    } else {
      return count;
    }
  } else {
    return 0;
  }
}

export function showMessageDetail(currentPage,title,content,datetime){
  let detail_box = $('.message_detail');
  let read_all_button = $('.mark_all_read');
  let pagination = $('.pagination');
  let date_time = formatDate(datetime);
  let parent_name = '';
  switch (currentPage) {
    case 'message_like':
      parent_name = '收到的喜欢';
      break;
    case 'message_follow':
      parent_name = '收到的关注';
      break;
    case 'message_comment':
      parent_name = '收到的评论';
      break;
    default:
      parent_name = '官方消息';
  }
  detail_box.find('.parent_name').html(parent_name);
  detail_box.find('.message_title').html(title);
  detail_box.find('.message_content').html(decodeURIComponent(content));
  detail_box.find('.create_time').html(date_time);
  detail_box.fadeIn(100);
  read_all_button.fadeOut(100);
  pagination.fadeOut(100);
}

export function closeMessageDetail(){
  let detail_box = $('.message_detail');
  let read_all_button = $('.mark_all_read');
  let pagination = $('.pagination');
  detail_box.find('.parent_name').html('');
  detail_box.find('.message_title').html('');
  detail_box.find('.message_content').html('');
  detail_box.find('.create_time').html('');
  detail_box.fadeOut(100);
  read_all_button.fadeIn(100);
  pagination.fadeIn(100);
}