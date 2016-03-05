
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
  let td = new Date(source);
  return [[td.getFullYear,td.getMonth(),td.getDate].join('-'),[td.getHours(),td.getMinutes(),td.getSeconds()].join(':')].join(' ')
}

export function showError(title,state,message){
  if (typeof console !== 'undefined') {
    console.error(title,state,message);
  } else {
    alert([title,state,message].join(','));
  }
}
