$(document).ready(function() {
    $(function(){
        $(".sjs_btn a").toggle(
            function () {
                $(".sjs_btn a").html("[关闭详细内容]");
                $(".zxdp2011_sjsanli p").height("auto");
            },
            function () {
                $(".sjs_btn a").html("[查看详细内容]");
                $(".zxdp2011_sjsanli p").height(66);
            });
    })
    
    $(function(){
        $(".num").html(1);
        $("#all").html($(".zxdp2011_focussmall li").length);
        $(".zxdp2011_focusbig div:first").show();
        $(".zxdp2011_focussmall li:first").addClass("active")
        $(".zxdp2011_focussmall li").click(
            function(){
                var index = $(".zxdp2011_focussmall li").index($(this));
                $("#num").html(index+1);

                $(this).addClass("active")
                .siblings().removeClass("active");
                $(".zxdp2011_focusbig div").eq($(this).index())
                .siblings().fadeOut().end().fadeIn();
                if ((index) % 4 == 0) {
                    $(".next").click();
                }

            })

        function switchImages() {
            var nextLi = $(".zxdp2011_focussmall li.active").next();
            (nextLi.size() < 1 ? $(".zxdp2011_focussmall li:eq(0)") : nextLi).click();
        }

        setInterval(switchImages, 5000);

        $.fn.hFlick = function(options) {
            $(this).each(function() {
                var pageCount = Math.ceil($(this).find('li').size() / options.size);
                var height = $(this).find('.v_content').height();

                function flick() {
                    var goNext = $(this).hasClass('next');
                    var list = $(this).parent().next().find('.v_content_list');
                    if(!list.is(':animated')) {
                        var top;
                        if(goNext)
                            if(list.position().top <= -(height * (pageCount - 1))) top = 0; else top = '-=' + height;
                        else
                        if(list.position().top >= 0) top = -(height * (pageCount - 1)); else top = '+=' + height;
                        list.animate({
                            'top': top
                        }, 'slow');
                    }
                }

                $(this).find('.next,.prev').click(flick);
            });
        };

        $('.v_show').hFlick({
            size: 4
        });
    })

    function diaryPostRemark(event){
        var $this = $(this).parent('form');
        if($(this).parent('form').children("#user_id").val()== ""||$(this).parent('form').children("#user_id").val().length ==0 ){
            alert("请先登陆!");
            return false;
        }else if($('#decoration_diary_show').attr("deco_frim_popedom") == -1){
            alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
            return false;
        }else if($(this).parent('form').children("#remark_content").val()== ""||$(this).parent('form').children("#remark_content").val().length ==0 ) {
            alert("请填写内容后再发表评论.");
            return false;
        }else{
            var user_id=$(this).parent('form').children("#user_id").val();
            var resource_id=$(this).parent('form').children("#resource_id").val();
            var resource_type=$(this).parent('form').children("#resource_type").val();
            var remark_content=$(this).parent('form').children("#remark_content").val();
            var popedom = $('#hejia_case_show').attr("deco_frim_popedom");
            $(".diary_body .diary_contwb #diary_hackwk").removeClass("show_diary_remarks");
            $(this).parent('form').parent().next().addClass("show_diary_remarks");
            $.post("/designers/new_case_remark",{
                "remark[user_id]":user_id,
                "remark[resource_id]":resource_id,
                "remark[resource_type]":resource_type,
                "remark[content]":remark_content,
                "popedom":popedom
            },function(data){
                $(".show_diary_remarks").html(data);
                $this[0].reset();
            });
        }

        event.preventDefault();
        return false;
    }

    function diaryRemarkReply(event){
        var $this = $(this).parent('form');
        if($(this).parent('form').children("#user_id").val()== ""||$(this).parent('form').children("#user_id").val().length ==0 ){
            alert("请先登陆!");
            return false;
        }else if($('#hejia_case_show').attr("deco_frim_popedom") == -1){
            alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
            return false;
        }else if ($(this).parent('form').children("#remark_reply_content").val() == ""||$(this).parent('form').children("#remark_reply_content").val().length ==0 ) {
            alert("请填写回复内容.");
            return false;
        } else{
            var user_id=$(this).parent('form').children("#user_id").val();
            var parent_id=$(this).parent('form').children("#remark_parent_id").val();
            var reply_content=$(this).parent('form').children("#remark_reply_content").val();
            var popedom = $('#hejia_case_show').attr("deco_frim_popedom");
            $(".diary_body .diary_contwb #diary_hackwk .diary_contwbtxt #diary_contwbhuifu").removeClass("show_diary_remark_replies");
            $(this).parent('form').parent(".diary_contwbhfinput").prev().addClass("show_diary_remark_replies");
            $.post("/designers/new_case_remark",{
                "remark[user_id]":user_id,
                "remark[parent_id]":parent_id,
                "remark[content]":reply_content,
                "popedom":popedom
            },function(data){
                $(".show_diary_remark_replies").html(data);
                $this[0].reset();
            });
        }

        event.preventDefault();
        return false;
    }

    //弹出登录框
    $(".the_login_dialog").click(function(){
        $('.the_login_dialog').colorbox({
            href: '/user_sessions/diary_show_pop_login',
            width: 700,
            height: 330,
            scrolling: false,
            opacity: 0.2
        });
    })


    //评论与回复的隐藏与显现
    $(".diary_body .diary_contlistpingl span a").live("click",function(event){
        event.preventDefault();
        if($(this).parent().hasClass('open')){
            $(this).parent().removeClass("open").
            parent().next(".diary_contwb").hide();
        }else{
            $(this).parent().addClass("open").
            parent().next(".diary_contwb").show();
        }
        return false;
    });
    //对评论的回复框隐藏与显现
    $(".diary_contwbtxt .diary_reply_remark span label a").live("click",function(event){
        event.preventDefault();
        $this = $(this).parents(".diary_reply_remark").next('p').next(".diary_reply_content").children(".diary_contwbhfinput")
        if($this.hasClass('open')){
            $this.removeClass("open");
            $this.hide();
        }else{
            $(".diary_contwbtxt .diary_reply_content .diary_contwbhfinput").hide();
            $(".diary_contwbtxt .diary_reply_content .diary_contwbhfinput").removeClass("open");
            $this.addClass("open");
            $this.show();
        }
        return false;
    });
    //提交评论
    $(".diary_post_remark").live('click', diaryPostRemark);
    //提交评论回复
    $(".diary_remark_reply").live('click', diaryRemarkReply);

    $(".diary_contwbpingl").keydown(function(event){
        if(event.keyCode == 13){
            var $this = $(this).children('form');
            if($(this).children('form').children("#user_id").val()== ""||$(this).children('form').children("#user_id").val().length ==0 ){
                alert("请先登陆!");
                return false;
            }else if($('#hejia_case_show').attr("deco_frim_popedom") == -1){
                alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
                return false;
            }else if($(this).children('form').children("#remark_content").val()== ""||$(this).children('form').children("#remark_content").val().length ==0 ) {
                alert("请填写内容后再发表评论.");
                return false;
            }else{
                var user_id=$(this).children('form').children("#user_id").val();
                var resource_id=$(this).children('form').children("#resource_id").val();
                var resource_type=$(this).children('form').children("#resource_type").val();
                var remark_content=$(this).children('form').children("#remark_content").val();
                var popedom = $('#hejia_case_show').attr("deco_frim_popedom");
                $(".diary_body .diary_contwb #diary_hackwk").removeClass("show_diary_remarks");
                $(this).children('form').parent().next().addClass("show_diary_remarks");
                $.post("/designers/new_case_remark",{
                    "remark[user_id]":user_id,
                    "remark[resource_id]":resource_id,
                    "remark[resource_type]":resource_type,
                    "remark[content]":remark_content,
                    "popedom":popedom
                },function(data){
                    $(".show_diary_remarks").html(data);
                    $this[0].reset();
                });
            }

            event.preventDefault();
            return false;
        }
    });

    $(".diary_contwbhfinput").keydown(function(event){
        if(event.keyCode == 13){
            console.log($(this).children('form').children("#remark_content").val());
            var $this = $(this).children('form');
            if($(this).children('form').children("#user_id").val()== ""||$(this).children('form').children("#user_id").val().length ==0 ){
                alert("请先登陆!");
                return false;
            }else if($('#hejia_case_show').attr("deco_frim_popedom") == -1){
                alert("对不起，目前本公司拒绝一切评论，敬请谅解！");
                return false;
            } else if ($(this).children('form').children("#remark_reply_content").val() == ""||$(this).children('form').children("#remark_reply_content").val().length ==0 ) {
                alert("请填写回复内容.");
                return false;
            } else{
                var user_id=$(this).children('form').children("#user_id").val();
                var parent_id=$(this).children('form').children("#remark_parent_id").val();
                var reply_content=$(this).children('form').children("#remark_reply_content").val();
                var popedom = $('#hejia_case_show').attr("deco_frim_popedom");
                $(".diary_body .diary_contwb #diary_hackwk .diary_contwbtxt #diary_contwbhuifu").removeClass("show_diary_remark_replies");
                $(this).children('form').parent(".diary_contwbhfinput").prev().addClass("show_diary_remark_replies");
                $.post("/designers/new_case_remark",{
                    "remark[user_id]":user_id,
                    "remark[parent_id]":parent_id,
                    "remark[content]":reply_content,
                    "popedom":popedom
                },function(data){
                    $(".show_diary_remark_replies").html(data);
                    $this[0].reset();
                });
            }
            event.preventDefault();
            return false;
        }
    });

    $(".show_all_remark").live('click',function(){
        $(this).siblings(".diary_contwbtxt").show();
        $(this).hide();
    });

});
