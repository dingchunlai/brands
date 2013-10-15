$(document).ready(function(){
    // 在线预约公司弹出窗口
    $('.applicant').fancybox({
        'autoDimensions' : false,
        'width':580,
        'height': 295,
        "scrolling" : "no",
        "titleShow": false,
        onComplete	:	function() {
            $('#new_applicant').validate({
                submitHandler: function(form) {
                    save_applicant();
                }
            })
        }
    });

    // 保存在线预约数据
    function save_applicant() {
        if ($("#applicant_tel").val().search("^-?\\d+$") == 0 && $("#applicant_tel").val().length==11) {
            $('#applicant_submit').attr("disabled",true);
            $.post($('#new_applicant').attr("action"), $('#new_applicant').serialize(), function(data) {
                if (data.substring(0,1) == 1) {
                    alert("预约保存成功.");
                    _gaq.push(['_trackEvent','效果', '免费量房', data.substring(1), 1]);
                    $.fancybox.close();
                }else{
                    alert("预约保存失败");
                };
                $('#applicant_submit').removeAttr("disabled");
                return false;
            });
        }else{
            alert("您的手机号有误，请重新输入！");
            return false;
        }
        return false;
    };
});