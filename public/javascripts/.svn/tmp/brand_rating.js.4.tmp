(function() {
 function enableRating() {
  $('.btn-rate').click(function(event) {
    event.preventDefault();
    try {
      var url_and_data = $(this).attr('data-remote').split('?', 2);

      $.ajax({
        cache: false,
        global: false,
        url: url_and_data[0],
        data: url_and_data[1],
        type: 'POST',
        dataType: 'script',
        error: function(request, textStatus, error) {
          alert(request.responseText);
        },
        success: function(data, textStatus, request){
          if(data == "false") {
              alert('一台电脑一天只能评分一次,谢谢!');
              return false;
          }
          alert('感谢您的参与和家网品牌口碑评价！');
        }
      });
    } catch(e) {
      //alert(e.name + ' : ' + e.message);
    }
    return false;
  });
 }

 $(enableRating);
})();
