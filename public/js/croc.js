$(document).ready(function(){

  $('.carousel').carousel({
    interval: 1000
  });

});

$(function(){
  var last_date = $('div.carousel-inner div:first').attr('timestamp');
  $.ajax({
    url: '/update_messages',
    type: 'GET',
    data: {latest_timestamp: last_date}
  }).success(function(data){
    $('carousel-inner').prepend(data);
  })
})

// function pollServer(last_date){
//   var date_query;
//   console.log(last_date);
//   setTimeout(function(){
//     $.ajax({
//       url: '/timeline/poll',
//       type: 'GET',
//       data: {published_at: last_date},
//       dataType: 'json'
//     }).success(function(data){
//       var last_event = data[data.length-1];        
//       date_query = getQueryDate(last_event, last_date);
//       displayNew(data);
//     }).error(function(data){
//       console.log(data)
//     }).done(function(){
//       pollServer(date_query);
//     });
//   }, 2000);
// }