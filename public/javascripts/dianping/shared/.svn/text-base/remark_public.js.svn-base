$(document).ready(function(){
    $("#remark_form").submit(function() {
        if( $("#user_id").val().length == 0 || $("#user_id").val()== ""){
            alert("请先登陆!");
        }else if($('#deco_firm_others_show').attr("deco_frim_popedom") == -1){
            alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
            return false;
        }else if ($.trim($("#reamrk_content").val()).length == 0) {
            alert("请填写内容后再发表评论.");
        }else{
            $("#comment").attr("disabled","disabled");
            $.ajax({
                type: "POST",
                url:jQuery(this).attr('action'),
                dataType:"html",
                data: $(this).serialize(),
                error: function(data) {
                    alert("保存失败,可能是在同一个浏览器中同时编辑两篇文章造成的");
                },
                success: function(data){
                    $("#comment").removeAttr("disabled");
                    if(data == "不能发表多次评论") {
                        alert("您在一分钟内，不能频繁发表多次评论!");
                    }else {
                        if($('#deco_firm_others_show').attr("deco_frim_popedom") == 1){
                            alert("您已评论成功，谢谢！");
                        }else{
                            alert("您发表的评论，需要审核之后才能显示，请耐心等待!");
                        }
                        $("#remark_form")[0].reset();
                        $('#remarks_list_wrapper').html(data);
                    }
                }
            });
        };
        return false;
    });

    //弹出登录框
    $(".the_login_dialog").click((function(){
        $('.the_login_dialog').colorbox({
            href: '/user_sessions/diary_show_pop_login',
            width: 700,
            height: 330,
            scrolling: false,
            opacity: 0.2
        });
    }));

});