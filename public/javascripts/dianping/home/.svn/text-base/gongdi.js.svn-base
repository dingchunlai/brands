 $(document).ready(function() {
    function save_register() {
      if ($("#deco_register_phone").val().search("^-?\\d+$") == 0 && $("#deco_register_phone").val().length==11) {
        $('#deco_register_submit').attr("disabled",true);
        $.post($('#register_form').attr("action"), $('#register_form').serialize(), function(data) {
          if (data.substring(0,1) == 1) {
            alert("预约保存成功.");
            _gaq.push(['_trackEvent','效果', '在建工地', data.substring(1), 1]);
            $.fancybox.close();
          }else{
            alert("预约保存失败");
          };
          $('#deco_register_submit').removeAttr("disabled");
          return false;
        });
      }else{
        alert("您的手机号有误，请重新输入！");
        return false;
      }
      return false;
    };


    $('a.fancy_box').fancybox({
      'autoDimensions' : false,
      'width':500,
      'height':370,
      "scrolling" : "no",
      "titleShow": false,
      onComplete	:	function() {
        $('#register_form').validate({
          submitHandler: function(form) {
            save_register();
          }
        });
      }
    });
  });
  // 在建工地 关闭窗口
  $('#close_box').live('click', function() {
    $.fancybox.close();
  });