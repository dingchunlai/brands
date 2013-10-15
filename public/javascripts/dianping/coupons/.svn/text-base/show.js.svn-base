//coupon_event
$(function(){
    //$(".zxdp2011_diyq_contbox:first").show();
    $(".zxdp2011_diyq_conttab li").click(
        function(){
            $(this).addClass("active").siblings().removeClass("active");
            $(".zxdp2011_diyq_contbox").eq($(this).index()).siblings().hide().end().show();
        }
        )
});
//coupons_info
$(function(){
    $(".diyq_listbtn a").click(
        function(){
            $(".diyq_sms").show(300);
            $(".diyq_smscont").show(300);
        });

    $(".diyq_smscloseup a").click(
        function(){
            $(".diyq_smscont").hide(300);
        });
    $(".diyq_smsexpand a").click(
        function(){
            $(".diyq_smscont").show(300);
        });
});

//添加到下载脚本
jQuery(document).ready(function($) {
    $(".next input[type=image]").click(function(){
        window.location.href = "/coupons/" + $(this).attr('coupon-id');
    });
})