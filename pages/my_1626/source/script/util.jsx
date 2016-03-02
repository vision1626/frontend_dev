
export function callMyOrder(){
  //return My_Order.initMyOrder();
  return alert('nothing');
}

export function formatDate(source){
  let td = new Date(source);
  return [[td.getFullYear,td.getMonth(),td.getDate].join('-'),[td.getHours(),td.getMinutes(),td.getSeconds()].join(':')].join(' ')
}
