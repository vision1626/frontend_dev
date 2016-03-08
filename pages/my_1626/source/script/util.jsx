
export function callMyOrder(){
  //return My_Order.initMyOrder();
  return alert('nothing');
}

export function setArrayPosition(currentpage,just_set_tab = false){
  let targetMenuItem = $('.mnu_' + currentpage);
  let targetTabItem = $('.tab_' + currentpage);
  if(just_set_tab) {
    $('.m_item').removeClass('current');
    targetMenuItem.addClass('current');
    $('.menu_array').css('top', targetMenuItem.position().top + 10);
  }
  if (targetTabItem.length > 0) {
    $('.mt_item').removeClass('current');
    targetTabItem.addClass('current');
    $('.msg_tab_slider').css('left', targetTabItem.position().left);
  }
}

export function formatDate(source){
  let td = new Date(source * 1000);
  return [[td.getFullYear(),td.getMonth(),td.getDate()].join('-'),[td.getHours(),td.getMinutes(),td.getSeconds()].join(':')].join(' ')
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
