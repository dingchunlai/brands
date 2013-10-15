jQuery.fn.tagCloud = function(){
    var max_length = Math.max($(".tag_cloud a:lt(6)").text().length,$(".tag_cloud a:gt(5):lt(11)").text().length,$(".tag_cloud a:gt(10)").text().length);
    var b=0,a=0,c=8,
    d=[[14,10,5,8,15],[65,60,67,63,74],[125,128,117,119,132]],
    e=[[2,1,7,3,7],[5,4,8,9,9],[6,3,3,2,1]];
    this.addClass("tag_cloud").children("div").each(function(){
        if(a>3){
            ++b;
            if(b>2)return;
            a=0;
            c=8
        }
        $(this).css({
            left:a*90+5+Math.random()*10+"px",
            top:d[b][a]+"px"
        }).addClass("color"+e[b][a]).show();
        c=$(this).position().left+$(this).width()+5;
        ++a
    });
};

// 目的为 
jQuery.fn.tagCloud2 = function(){
    var max_length = Math.max($(".tag_cloud2 a:lt(6)").text().length,$(".tag_cloud2 a:gt(5):lt(11)").text().length,$(".tag_cloud2 a:gt(10)").text().length);
    var b=0,a=0,c=0,
    d=[[14,10,5,8,15],[65,60,67,63,74],[125,128,117,119,132]],
    e=[[2,1,7,3,7],[5,4,8,9,9],[6,3,3,2,1]];
    this.addClass("tag_cloud2").children("div").each(function(){
        if(a>4){
            ++b;
            //if(b>2)return;
            a=0;
            ++c;
        }
        if(c>2) c = 0;
        $(this).css({
            left:a*90+9+Math.random()*10+"px",
            //top:d[b][a]+"px"
            top: (5 + b * 40) + "px"
        }).addClass("color"+e[c][a]).show();
        //$(this).position().left+$(this).width()+9;
        ++a
    });
};


jQuery(document).ready(function($) {
    $.jGrowl.defaults.position = 'center';

    // 添加印象
    function addImpression(impression,message) {
        $.ajax({
            url: $('#impression_form').attr('action'),
            type: 'POST',
            data: $.param({
                title: impression
            }),
            dataType: 'html',

            error: function(request) {
                //   var msg;
                //  try {
                //      msg = eval('(' + request.responseText + ')').join('<br/>');
                //    }
                //    catch(e) {
                //        msg = '每天最多只能给每个公司添加或投票两个印象';
                //    }
                alert("每天最多只能给每个公司添加或投票两个印象");
            },
            success: function(data) {
                if (message!="印象投票成功") {
                    $('#deco_impression_cloud').replaceWith(data);
                    $('.tag_cloud').tagCloud();
                    replace_top_deco_impression($('#ajaxLoginForm').attr("data-firm-id"));
                }
                alert("印象投票成功，感谢您的参与");
                refreshImpressionSpan(impression);
                return false;
            }
        });
    }

    function refreshImpressionSpan(impression){
      $('#new_impression').prepend($('<a />').addClass('impression').attr('href', '/dianping/firms/save_deco_impression?id='+$('#ajaxLoginForm').attr("data-firm-id")).text(impression).append('&nbsp;'));
    }

    function replace_deco_impression_cloud_pop(firm_id){
        $.ajax({
            url: '/firms/deco_impression_cloud_pop',
            type: 'GET',
            dataType: 'html',
            data: {
                id: firm_id
            },
            success: function(data) {
                $('#deco_impression_cloud_pop').replaceWith(data);
                $('#deco_impression_cloud_pop').tagCloud2();
            }
        });
    }
    
    function replace_top_deco_impression(firm_id) {
        $.ajax({
            url: '/firms/top_deco_impression',
            type: 'GET',
            dataType: 'html',
            data: {
                id: firm_id
            },
            success: function(data) {
                $('#top_deco_impression').replaceWith(data);
            }
        });
      
    };
    
    $('#deco_impression #title').focus(function() {
        if( $.trim($(this).val()) == '不能多于5个字' ) $(this).val('')
    }).blur(function() {
        if( $.trim($(this).val()) == '' ) $(this).val('不能多于5个字')
    });

    $('#deco_impression').submit(function(event) {
        var textField = $('#impression_form').find(':text'),
        impression = $.trim(textField.val());
        textField.val('');
        if (impression != '' && impression != '不能多于5个字') addImpression(impression,'印象添加成功');
        event.preventDefault();
    });
    

    $('.impression').live("click",function(event) {
        addImpression($(this).text(), '印象投票成功');
        event.preventDefault();
    // return false;
    });


    // 印象标签
    $('#deco_impression_cloud').tagCloud();
    $('#deco_impression_cloud_pop').tagCloud2();

    //判断公司留言与回复功能是否被禁止
    function firmRemarkPopedom(){
        if ($('#ajaxLoginForm').attr("deco_frim_popedom") == -1 && $('#ajaxLoginForm').attr("data-current-user") != ""){
            alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
            return false;
        }else{
            return true;
        }
        return false;
    }

    //公司评论的回复
    function firmRemarkReply(event){
        var $this = $(this).parent('form');
        if($("#cookie_id").val()== ""||$("#cookie_id").val().length ==0 ){
            alert("请先登陆!");
            return false;
        } else if ($(this).parent('form').children("#remark_reply_content").val() == ""||$(this).parent('form').children("#remark_reply_content").val().length ==0 ) {
            alert("请填写回复内容.");
            return false;
        } else{
            var parent_id=$(this).parent('form').children("#remark_parent_id").val();
            var reply_content=$(this).parent('form').children("#remark_reply_content").val();
            $("#firm_contwbhuifu").removeClass("show_firm_remark_replies");
            $(this).parent('form').parents(".firm_contwbhuifu").addClass("show_firm_remark_replies");
            $.post("/dianping/remarks/firm_remark_save",{
                "remark[parent_id]":parent_id,
                "remark[content]":reply_content
            },function(data){
                $(".show_firm_remark_replies").html(data);
                $this[0].reset();
            });
        }

        event.preventDefault();
        return false;
    }
    
    

    // 左上角轮播
    $(".zxdp2010_slidebigimg img:gt(0)").hide();
    $(".zxdp2010_slidesmallimg li:first").addClass("active");
    $(".zxdp2010_slidesmallimg li.has_img").mouseover(function(){
        $(this).addClass("active").siblings().removeClass("active");
        var index = $(this).index();
        $(".zxdp2010_slidebigimg img").not(":eq("+index+")").fadeOut().end().eq(index).fadeIn();
    });
    /*
  	function switchImages() {
  	  var nextLi = $(".zxdp2010_slidesmallimg li.active").next();
  	  var $this = $(".zxdp2010_slidesmallimg li.active");
  	  var xx = $('.zxdp2010_slidesmallimg li').index($this);
  	  (xx == $('.zxdp2010_slidesmallimg').attr("data-img-count") ? $(".zxdp2010_slidesmallimg li:eq(0)") : nextLi).mouseover();
  	};
  	setInterval(switchImages, 5000);
  	*/

    // 施工图片的lightbox
    function initLightBox(id){
        $(id).lightBox(
        {
            imageLoading:'http://img.51hejia.com/lightbox/lightbox-ico-loading.gif',
            imageBtnPrev:'http://img.51hejia.com/lightbox/lightbox-btn-prev.gif',
            imageBtnNext:'http://img.51hejia.com/lightbox/lightbox-btn-next.gif',
            imageBtnClose:'http://img.51hejia.com/lightbox/lightbox-btn-close.gif',
            imageBlank:'http://img.51hejia.com/lightbox/lightbox-blank.gif',
            maxImageWidth:500
        });
    }
    // initLightBox("#photos a");
    initLightBox(".light_box_pictures a")
    // 控制案例和施工的卡片切换
    $(function(){
        $(".zxdp2010_atbox:gt(0)").hide();
        $(".zxdp2010_attab li:first").addClass("zxdp2010_attabcur");
        $(".zxdp2010_attab li").click(
            function(){
                $(this).addClass("zxdp2010_attabcur")
                .siblings().removeClass("zxdp2010_attabcur");
                $(".zxdp2010_atbox").eq($(this).index())
                .siblings().hide().end().show();
            }
            )
    }
    )

    // 评论的ajax翻页
    $('#remarks .pagination a').live('click', function() {
        var url = $(this).attr("href");
        $.get(url, function(html) {
            window.location.hash="st";
            $('#remarks').html(html);
        });
        return false;
    });



    // 在建工地预约参观 弹出窗口
    $('.zxdp2010_zjgdtd02 a').fancybox({
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


    // 在建工地 关闭窗口
    $('#close_box').live('click', function() {
        $.fancybox.close();
    });

    // 在线预约公司弹出窗口
    $('.firm_applicant').fancybox({
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



    // 在线预约公司弹出窗口
    $('#applicant').fancybox({
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

    //普通留言
    $('#pt_submit').live('click',function(){
        if (firmRemarkPopedom()){
            var $this = $(this).parents('form');
            if ($("#mark_tj").val() != 1){
                if ($.trim($("#content").val()).length == 0) {
                    alert("请填写留言内容");
                    return false;
                } else {
                    $.post("/dianping/remarks/firm_remark_save",{
                        'remark[resource_id]': $("#deco_frim_id").val(),
                        'remark[content]': $("#content").val()
                    },function(data){
                        $('.firm_contwbhuifu').hide();
                        if ($('#ajaxLoginForm').attr("deco_frim_popedom") == 1){
                            $("#remarks").html(data);
                        } else if($('#ajaxLoginForm').attr("deco_frim_popedom") == 0){
                            $("#putongliuyankuang").html(data);
                        }
                    });
                    return false;
                }
            }
        }
        return false;
    });


    $('#set-praise').click(function() {
        $('.small-star p').removeClass("one");
    });

    $('#mian_praise').attr("value",0);
    
    function mainPraise() {
        if($("#mian_praise").val() == 0) {
            alert("请评分");
            return false;
        }
        return false;
    }
    function trimContent() {
        if ($.trim($("#content").val()).length == 0) {
            alert("请填写留言内容");
            return false;
        }
        return false;
    }

    //提交打分留言信息的函数
    function savePraiseRemark(event) {
        $.post("/dianping/remarks/firm_remark_save",{
            'remark[resource_id]': $("#deco_frim_id").val(),
            'remark[content]': $("#content").val(),
            'remark[praise]': $("#mian_praise").val(),
            'this_mobile': $("#buildin_mobile").val(),
            'zuimanyi': $('[name="zuimanyi"][checked=true]:radio').val(),
            'jiaomanyi': $('[name="jiaomanyi"][checked=true]:radio').val()
        },function(data){
            //$("#remarks").html(data);
            //$("#putongliuyankuang").html(data);
            if ($('#ajaxLoginForm').attr("deco_frim_popedom") == 1){
                $("#remarks").html(data);
            } else if($('#ajaxLoginForm').attr("deco_frim_popedom") == 0){
                $("#putongliuyankuang").html(data);
            }
            event[0].reset();
            $(".pinjbox").hide();
            $("#simple_remark").show();
        });
    };

    //打分留言（非弹出框）
    $("#mark_remark").click(function(){
        var $this = $(this).parents('form');
        mainPraise();
        trimContent();
        if ($("#youhaoma").val().length == 0 || $("#youhaoma").val() != 1) {
            var verify_code = $("#buildin_verify_code").val();
            if (verify_code.length != 4 || isNaN(verify_code)) {
                alert("请输入正确的验证码");
                return false;
            }else{
                $.post("/user/verify_mobile_code", {
                    code: verify_code,
                    mobile : $("#buildin_mobile").val()
                }, function(data){
                    if (!data.result) {
                        alert("验证码验证失败");
                        $("#mark_submit").removeAttr("disabled");
                    }else{
                        savePraiseRemark($this);
                    }
                    return false;
                });
            }
            return false;
        }else{
            savePraiseRemark($this);
        }
        return false;
    });

    // 页面底部留言
    $("#open_mark").click(function(){
        if (firmRemarkPopedom()){
            if($("#cookie_id").val()== ""){
                alert("请先登录!")
            }else{
                $("#open_mark").unbind("click");
                $.post("/user/verify_mark",{
                    firm_id : $("#deco_frim_id").val()
                },
                function(data){
                    if(data.result){
                        $("#simple_remark").hide()
                        $(".pinjbox").show();
                        if(data.is_mobile){
                            $("#is_verify").show();
                            $("#youhaoma").val(0);
                        }else{
                            $("#is_verify").hide();
                            $("#youhaoma").val(1);
                        }
                    }else{
                        $("#open_mark").css({
                            "padding-left":"25px",
                            "color":"red"
                        }).text("提示：对不起.您6个月只能评分一次");
                    }
                },"json");
            }
        }
    });


    //弹出登录框
    $("#login").click(function(){
        $.fancybox({
            href: '/user_sessions/diary_show_pop_login',
            width: 600,
            height: 320,
            scrolling: false,
            opacity: 0.2
        });
    });

    function log(text) {
        console.log(text)
    }

    //对评论的回复框隐藏与显现
    $(".firm_remark_reply a").live("click",function(event){
        event.preventDefault();
        var remark = $(this);
        $this = $(this).parents("h4").next("p").next(".firm_contwbhuifu")
        if($this.hasClass('open')){
            $this.removeClass("open");
            remark.text("[+]");
            $this.find(".firm_contwbhfinput").hide();
            $this.hide();
        }else{
            $this.addClass("open");
            remark.text("[-]");
            $this.show();
        }
        return false;
    });
		
    $(".open_firm_contwbhfinput").live("click",function(event){
        if (firmRemarkPopedom()){            
            // event.preventDefault();
            $this = $(this).parents("p").next(".firm_contwbhuifu")
            if($this.hasClass('open')){
            }else{
                $this.addClass("open");
                $this.show();
                $(this).parents("p").prev("h4").find(".firm_remark_reply a").text("[-]");
            }
            $(".firm_contwbhfinput").hide();
            $this.find(".firm_contwbhfinput").show();
        }
    });

    //提交评论回复
    $(".replay_submit").live('click', firmRemarkReply);

    // 底部留言
    $('#login_form').submit(function(){
        if($('#user_name').val().length <= 0){
            alert('请输入用户名');
        }else if($('#password').val().length <= 0){
            alert('请输入密码');
        }else{
            $("#login_submit").attr("disabled","disabled");
            $.ajax({
                type: "POST",
                url: "/sessions/user_login",
                dataType: "script",
                data: jQuery(this).serialize(),
                success: function(data){
                    $('#login_submit').removeAttr("disabled");
                    if(data == 'error'){
                        alert('用户名或密码错误!');
                        $("#password").val("");
                    }else if(data == "freeze"){
                        alert("您的帐户已暂被冻结，如有疑问可直接联系客服人员！");
                        $("#password").val("");
                    }else{
                        $("#login").css("display","none");
                        $("#open_mark").show();
                        $(".gsl_rj").html("<a href='http://member.51hejia.com/member/user_note_list' title='发表日记' target='_blank'>发表日记</a>");
                        $("#remark_button").html("<input type='submit' value='留言提交' id='pt_submit'  class='gsl_wyly_btn'  />");
                        $('#ajaxLoginForm').attr("data-current-user",data);
                    }
                }
            })
        }
        return false;
    });


    $("#mark_submit").click(function(){
        if($("#mian_praise").val().length == 0) {
            alert("请评分");
            return false;
        }else if ($("#youhaoma").val().length == 0 || $("#youhaoma").val() != 1) {
            var verify_code = $("#verify_code").val();
            if (verify_code.length != 4 || isNaN(verify_code)) {
                alert("请输入正确的验证码");
                return false;
            }
            $("#mark_submit").attr("disabled","disabled");
            $.post("/user/verify_mobile_code", {
                code: verify_code,
                mobile : $("#mobile").val()
            }, function(data){
                if (!data.result) {
                    alert("验证码验证失败");
                    $("#mark_submit").removeAttr("disabled");
                }else{
                    $("#mark_tj").val(1);
                    $('#firm_remark').submit();
                }
            }, "json");
        }else{
            $("#mark_tj").val(1);
            $('#firm_remark').submit();
        }
    });
    
    //星星打分的文字提示
    $('#firm-big-star p').live("mouseover",function() {
        var praise = $('#firm-big-star .one').length * 2;
        showTip(praise);
    }).live("mouseleave",function() {
        $("#praise_tip").hide();
    });

    
    // 页面上划动星星的文字提示
    function showTip(star) {
        switch (star.toString()){
            case "2":
                $("#praise_tip").text("很不满意").css("left",31).show();
                break;
            case "4":
                $("#praise_tip").text("不满意").css("left",55).show();
                ;
                break;
            case "6":
                $("#praise_tip").text("一般").css("left",78).show();
                ;
                break;
            case "8":
                $("#praise_tip").text("满意").css("left",98).show();
                ;
                break;
            case "10":
                $("#praise_tip").text("非常满意").css("left",105).show();
                ;
                break;
        }
    };
  	
    // 页面下方的打分
  	
    /* 公司终端页弹出留言评分*/
    $("#buildin_code_button").live("click",function(){
        var mobile = $("#buildin_mobile").val();
        var patrn=/^0?1(3\d|4\d|5[012356789]|8[056789])\d{8}$/;
        if (!patrn.exec(mobile)) {
            alert("请输入正确的手机号码");
            return false;
        }
        $("#buildin_code_button").val("正在发送...");
        $("#buildin_code_button").attr("disabled","disabled");
        $.post("/user/send_mobile_code",{
            mobile : mobile
        },
        function(data){
            $("#buildin_code_button").val("重新发送");
            $("#buildin_code_button").removeAttr("disabled");
            if(data.result == 1){
                $(".pinjprompt").text("提示：此手机号码三分钟之内只能验证一次");
                return false;
            }else if(data.result == 2){
                $(".pinjprompt").text("提示：您在三分钟之内只能验证一次");
                return false;
            }else if(data.result == 3){
                $(".pinjprompt").text("提示：发送验证码失败。请稍后再试");
                return false;
            }else if(data.result == 4){
                $(".pinjprompt").text("提示：当前输入的手机号已经被其他账号绑定，请更换号码后重新绑定操作");
                return false;
            }else if(data.result == 0){
                $("#this_mobile").val(mobile);
                alert("验证码已发送至您手机！如果3分钟之内没有收到短信，请重新点击获取验证码");
            }else{
                alert("系统错误");
                return false;
            }
        },"json");
    });



});


jQuery(function($){
	$(".tag_cloud div").mouseover(
		function(){
			$(this).css("z-index","99");
					});
	$(".tag_cloud div").mouseout(
		function(){
			$(this).css("z-index","0");
					});
});