$(document).ready(function(){

  $('.carousel').carousel({
    interval: 1000
  });

});

$(setInterval(function(){
    var last_date = $('div.carousel-inner div:first').attr('timestamp');
    $.ajax({
      url: '/update_messages',
      data: {latest_timestamp: last_date},
      success: function(result){
        $('.carousel-inner').prepend(result);
      }
    });
  }, 10000)
);