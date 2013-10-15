// 弹出POP留言框
function show_pop_remark_form() {
    jQuery.fancybox({
        'autoDimensions' : false,
        href: '/remarks/pop_form' + '?firm_id='+$('#ajaxLoginForm').attr("data-firm-id")+'&praise='+$('#firm-big-star').attr("data-praise"),
        'width': 600,
        'height': 350,
        "scrolling" : "no",
        "titleShow": false,
        opacity: 0.2
    })
/*
	  jQuery.colorbox({
		  href: '/remarks/pop_form' + '?firm_id='+$('#ajaxLoginForm').attr("data-firm-id"),
			width: 650,
			height: 350,
			scrolling: false,
			opacity: 0.2
		});
     */
};
	
function show_pop_login() {
    jQuery.fancybox({
        'autoDimensions' : false,
        href: '/user_sessions/pop_login',
        'width': 600,
        'height': 260,
        "scrolling" : "no",
        "titleShow": false,
        opacity: 0.2,
        onComplete: function() {
            $('<img id="image_code_area" src="/user/get_image_code" width="50"  onclick="document.getElementById(\'image_code_area\').src = \'/user/get_image_code?\' + Math.random();" height="20" style="vertical-align:middle;">').insertAfter('#img_locator');
        }
    });
    
/*
	  jQuery.colorbox({
		  href: '/user_sessions/pop_login',
			width: 700,
			height: 330,
			scrolling: false,
			opacity: 0.2,
		onComplete: function() {
		  $('<img id="image_code_area" src="/user/get_image_code" width="50" height="20" style="vertical-align:middle;">').insertAfter('#img_locator');
	  }
		});
     */
};
	
jQuery(document).ready(function($) {
    //打分评价

    $(".set-praise").html("<p></p><p></p><p></p><p></p><p></p>");
	
    $(".set-praise p").mouseover(function() {
        $(this).addClass("one").prevAll().addClass("one").end().nextAll().removeClass("one");
        showPraiseTip($('.big-star .one').length*2);
    }).click(function() {
        var praise = $(this).siblings(".one").length * 2 + 2;
        $(this).parent().attr("data-praise", praise).next().val(praise);
        if ($('#pop_main_praise').length > 0) {
            $('#pop_main_praise').val(praise);
        };
    }).parent().mouseout(function() {
        var star = $(this).attr("data-praise")/2 - 1 ;
		
        if (star == -1 ) {
            $(this).children().removeClass("one");
        }else{
            $(this).children(":lt("+star+")").addClass("one").end().
            children(":eq("+star+")").addClass("one").end().
            children(":gt("+star+")").removeClass("one");
        };
    });
	
    // 页面上划动星星的文字提示
    function showPraiseTip(star) {
        switch (star.toString()){
            case "2":
                $("#show_key").text("很不满意");
                break;
            case "4":
                $("#show_key").text("不满意");
                break;
            case "6":
                $("#show_key").text("一般");
                break;
            case "8":
                $("#show_key").text("满意");
                break;
            case "10":
                $("#show_key").text("非常满意");
                break;
            default:
                $("#show_key").text("请评分");
        }
    };

	
    // 保存弹出留言
    $("#pop_mark_button").live("click",function(){
        if ($("#pop_youhaoma").val().length == 0 || $("#pop_youhaoma").val() != 1) {
            var verify_code = $("#pop_verify_code").val();
            if (verify_code.length != 4 || isNaN(verify_code)) {
                alert("请输入正确的验证码");
                return false;
            }
            $("#pop_mark_button").attr("disabled","disabled");
            $.post("/user/verify_mobile_code", {
                code: verify_code,
                mobile : $("#pop_mobile").val()
            }, function(data){
                if (!data.result) {
                    alert("验证码验证失败");
                    $("#pop_mark_button").removeAttr("disabled");
                }else{
                    $('#pop_remark').submit();
                }
            }, "json");
        }else{
            $('#pop_remark').submit();
        }
    });
  
	
    /* 公司终端页弹出留言评分*/
    $("#pop_code_button").live("click",function(){
        var mobile = $("#pop_mobile").val();
        var patrn=/^0?1(3\d|4\d|5[012356789]|8[056789])\d{8}$/;
        if (!patrn.exec(mobile)) {
            alert("请输入正确的手机号码");
            return false;
        }
        $("#pop_code_button").val("正在发送...");
        $("#pop_code_button").attr("disabled","disabled");
        $.post("/user/send_mobile_code",{
            mobile : mobile
        },
        function(data){
            $("#pop_code_button").val("重新发送");
            $("#pop_code_button").removeAttr("disabled");
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
	
    /* 下面是从pop留言框过来的  */
	
	
    // 设置一些初始数据
    var red="#f00" // 红色边框和姿态
    var green="#0c0" // 绿色边框和字体
    var blue="#09f" //蓝色
    //设置通过验证和未通过验证的样式
    $.fn.setBlue=function(){
        tip=$(this).next();
        if(tip.css("color")!=red){
            tip.css("color",blue);
        }
    };
    $.fn.setRed=function(message){
        // $(this).css("border-color",red);
        $tip=$(this).next();
        $tip.css("color",red);
        $tip.text(message);
        $tip.addClass("errorFlag");
    //   alert($("form .errorFlag").length);
    };
    $.fn.setGreen=function(){
        $tip=$(this).next();
        //   $(this).css("border-color",green);
        $tip.css("color",green);
        $tip.html("<img src='http://js.51hejia.com/img/right.gif'>");
        $tip.removeClass("errorFlag");
    };
    //开始验证输入的用户名
    $(".dafenbox input").focus(function(){
        $(this).setBlue();
    });
    $('#signup_username').live("blur",function(){
        var login_length=$(this).val().length;
        if(login_length<=1 || login_length>=14){
            $(this).setRed("用户名为2-14位");
        }
        else{
            $.getJSON("/user/validate_username?username="+$(this).val(),
                function(data) {
                    if (data["result"] == 0) {
                        $('#signup_username').setRed("已占用");
                    }else{
                        $('#signup_username').setGreen();;
                    }
                });
        };
    });

    //开始验证密码长度
    $("#signup_password").live("blur",function() {
        var password_length=$(this).val().length;
        if(  password_length <6 ||  password_length>16 ){
            $(this).setRed("密码长度应为6-16");
        }else{
            $(this).setGreen();
        }
    });

    //开始验证EMAIL
    $("#user_email").live("blur",function() {
        if( this.value=="" || this.value!="" && !/.+@.+\.[a-zA-Z]{2,4}$/.test(this.value) ){
            $(this).setRed("格式错误");
        }else{
            $.getJSON("/user/validate_email?email="+$(this).val(),
                function(data) {
                    if (data["result"] == 0) {
                        $('#user_email').setRed("已占用");
                    }else{
                        $('#user_email').setGreen();;
                    }
                });
        };
    });

    //开始验证密码确认
    $("#signup_password_confirm").live("blur",function() {
        var password=$("#signup_password").val()
        var password_confirmation=$(this).val()
        if(  password != password_confirmation || password_confirmation.length==0 ){
            $(this).setRed("两次密码不同");
        }else{
            $(this).setGreen();
        }
    });

    // 提交POP注册
    $('#signup_submit').live("click", function() {
        //		$("form :input").trigger('blur');
        var numError=$("form .errorFlag").length;
        if(numError==0){
            $("#signup_submit").attr("disabled","disabled");
            $.ajax({
                url: '/user/reg_save',
                type: 'POST',
                dataType: 'json',
                data: $("#signup_form").serialize(),
                success: function(data) {
                    if (data["result"] == 1) {
                        //	$('#ajaxLoginForm').attr("data-current-user","xx");
					
                        jQuery.fancybox({
                            href: '/remarks/pop_form' + '?firm_id='+$('#ajaxLoginForm').attr("data-firm-id")+'&praise='+$('#firm-big-star').attr("data-praise"),
                            width: 650,
                            height: 350,
                            scrolling: false,
                            opacity: 0.2
                        });
                    }else{
                        alert("验证码不正确,请重新输入");
                        $("#signup_submit").removeAttr("disabled");
                    };
                    return false;
                }
            });
        };
        return false;
    });


    $('#pop_login_submit').live("click",function(){
        if($('#pop_user_name').val().length <= 0){
            alert('请输入用户名');
        }else if($('#pop_password').val().length <= 0){
            alert('请输入密码');
        }else{
            $("#pop_login_submit").attr("disabled","disabled");
            $.ajax({
                type: "POST",
                url: "/user_sessions/user_login",
                dataType: "script",
                data: $("#pop_login_form").serialize(),
                success: function(data){
                    $('#pop_login_submit').removeAttr("disabled");
                    if(data == 'error'){
                        alert('用户名或密码错误!');
                        $("#pop_password").val("");
                    }else if(data == "freeze"){
                        alert("您的帐户已暂被冻结，如有疑问可直接联系客服人员！");
                        $("#pop_password").val("");
                    }else{
                        $('#ajaxLoginForm').attr("data-current-user","data")
                        $("#login").css("display","none");
                        $("#remark_button").html("<input type='submit' value='留言提交' id='pt_submit'  class='gsl_wyly_btn'  />");
                        //		$.fn.colorbox.close();
                        $.post("/user/verify_mark",
                        {
                            firm_id : $("#deco_frim_id").val()
                        },
                        function(data){
                            if (data.result) {
                                //if (data.result) {
                                //console.log("a");
                                jQuery.fancybox({
                                    href: '/remarks/pop_form' + '?firm_id='+$('#ajaxLoginForm').attr("data-firm-id")+'&praise='+$('#firm-big-star').attr("data-praise"),
                                    width: 650,
                                    height: 350,
                                    scrolling: false,
                                    opacity: 0.2
                                },function(data) {
                                    //console.log("b");
                                    $('#pop_main_praise').val($('#firm-big-star').attr("data-praise"));
                                    if(data.is_mobile){
                                        $(".dafentit").show();
                                        $("#pop_youhaoma").val(0);
                                    }else{
                                        $(".dafentit").hide();
                                        $("#pop_youhaoma").val(1);
                                    }
                                });
                            }else{
                                alert("对不起，您6个月只能评分一次");
                                jQuery.fancybox.close();
                                return false;
                            }
                        },"json");
                    }
                }
            })
        }
        return false;
    });


    $('#pop_mark_reset').click(function() {
        $('.small-star p').removeClass("one");
    });

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
    
    // 点击大猩猩打分
    $('#firm-big-star p').click(function(){
        if (firmRemarkPopedom()){
            var star = $(this).parent().attr("data-praise") ;
            //	showPraiseTip(star);
            var praise = $('#firm-big-star').children(".one").length * 2 ;
            $(this).attr("data-praise", praise);
            if ($('#ajaxLoginForm').attr("data-current-user") == "") {
                show_pop_login();
            }else{
                $.post("/user/verify_mark",
                {
                    firm_id : $("#deco_frim_id").val()
                },
                function(data){
                    if (data.result) {
                        jQuery.fancybox({
                            href: '/remarks/pop_form' + '?firm_id='+$('#ajaxLoginForm').attr("data-firm-id")+'&praise='+$('#firm-big-star').attr("data-praise"),
                            width: 650,
                            height: 350,
                            scrolling: false,
                            opacity: 0.2,
                            onComplete:function() {
                                $('#pop_main_praise').val($('#firm-big-star').attr("data-praise"));
                                if(data.is_mobile){
                                    $(".dafentit").show();
                                    $("#pop_youhaoma").val(0);
                                }else{
                                    $(".dafentit").hide();
                                    $("#pop_youhaoma").val(1);
                                }
                            }
                        }
                        );
                    }else{
                        alert("对不起，您6个月只能评分一次");
                        return false;
                    }
                },"json");
            };
        }
    });
	
	
	
	
});
